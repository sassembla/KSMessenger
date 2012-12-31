//
//  KSMessenger.m
//  KSMessenger
//
//  Created by sassembla on 2012/12/27.
//  Copyright (c) 2012年 KISSAKI Inc,. All rights reserved.
//

#import "KSMessenger.h"



@interface KSMessenger (PrivateImplements)


//内部実行系
- (void) innerPerform:(NSNotification * )notification;//内部実装メソッド

- (void) sendPerform:(NSMutableDictionary * )dict;//実行メソッド
- (void) sendPerform:(NSMutableDictionary * )dict withDelay:(float)delay;//遅延実行メソッド

- (void) sendMessage:(NSMutableDictionary * )dict;//送信実行ブロック




//remote invocation
- (BOOL) isIncludeRemote:(NSDictionary * )dict;
- (void) remoteInvocation:(id)inv withDict:(NSDictionary * )dict, ...;//遅延実行　プライベート版
- (NSDictionary * ) setPrivateRemoteInvocationFrom:(id)mySelf withSelector:(SEL)sel;//MessengerSystemの親決め限定の仕掛け

//private notices
- (void) createdNotice;//作成完了声明発行メソッド
- (void) updatedNotice:(NSString * )parentName withParentMID:(NSString * )parentMID;//更新発行メソッド
- (void) killedNotice;//自死声明発行メソッド

//parent manage
- (void) setMyParentName:(NSString * )parent;
- (void) setMyParentMID:(NSString * )parentMID;
- (void) resetParent;

//childrenDict manage
- (void) setChildrenDictChildNameAsValue:(NSString * )senderName withMIDAsKey:(NSString * )senderMID;
- (void) removeChildrenDictChildNameAsValue:(NSString * )senderName withMIDAsKey:(NSString * )senderMID;

//logs
- (void) addCreationLog:(NSMutableDictionary * )dict;//メッセージ初期作成ログを内部に保存する/返すメソッド
- (void) saveLogForReceived:(NSMutableDictionary * )m_logDict;//受信時に付与するログを内部に保存するメソッド
- (NSMutableDictionary * ) createLogForReply;//返答送信時に付与するログを内部に保存する/返すメソッド
- (void) saveToLogStore:(NSString * )name log:(NSDictionary * )value;




@end

@implementation KSMessenger (PrivateImplements)
/**
 内部実行で先ず呼ばれるメソッド
 自分宛のメッセージでなければ無視する
 */
- (void) innerPerform:(NSNotification * )notification {
	NSDictionary * dict = [notification userInfo];
	
	//カテゴリについて確認
	NSString * categolyName = [dict valueForKey:MS_CATEGOLY];
	if (!categolyName) {
		//		NSLog(@"コマンドが無いため、何の処理も行われずに帰る");
		return;
	}
	
	//送信者名
	NSString * senderName = [dict valueForKey:MS_SENDERNAME];
	if (!senderName) {//送信者不詳であれば無視する
		//		NSLog(@"送信者NAME不詳");
		return;
	}
	
	
	//送信者MID
	NSString * senderMID = [dict valueForKey:MS_SENDERMID];
	if (!senderMID) {//送信者不詳であれば無視する
		//		NSLog(@"送信者ID不詳");
		return;
	}
	
    
	//宛名確認
	NSString * address = [dict valueForKey:MS_ADDRESS_NAME];
	if (!address) {
		//		NSLog(@"宛名が無い_%@ Iam_%@", commandName, [self getMyName]);
		return;
	}
	
	
	//ログ関連
	NSMutableDictionary * recievedLogDict = [dict valueForKey:MS_LOGDICTIONARY];
	if (!recievedLogDict) {
		//		NSLog(@"ログが無いので受け付けない_%@", commandName);
		return;
	} else {
		//メッセージIDについて確認
		NSString * messageID = [recievedLogDict valueForKey:MS_LOG_MESSAGEID];
		if (!messageID) {
			//			NSLog(@"メッセージIDが無いため、何の処理も行われずに帰る");
			return;
		}
	}
	
	//カテゴリごとの処理に移行
	
	
	//LPC
	if ([categolyName isEqualToString:MS_CATEGOLY_LOCAL]) {
		
		
		if (![senderName isEqualToString:[self myName]]) {
			//			NSLog(@"MS_CATEGOLY_LOCAL 名称が違う_%@", [self getMyName]);
			return;
		}
		
		if (![senderMID isEqualToString:[self myMID]]) {//MIDが異なれば処理をしない
			//			NSLog(@"名前が同様の異なるMIDを持つオブジェクト");
			return;
		}
		
		
		[self saveLogForReceived:recievedLogDict];
		
		
		//設定されたbodyのメソッドを実行
		IMP func = [myBodyID methodForSelector:myBodySelector];
		(*func)(myBodyID, myBodySelector, notification);
		
		
		return;
	}
	
	
	
	
	
	
	//親から子供に向けてのコールを受け取った
	if ([categolyName isEqualToString:MS_CATEGOLY_CALLCHILD]) {
		//宛名が自分の事でなかったら帰る
		if (![address isEqualToString:[self myName]]) {
			//			NSLog(@"自分宛ではないので却下_From_%@,	To_%@,	Iam_%@", senderName, address, [self getMyName]);
			return;
		}
		
		
		//オプションでの特定MID宛先がある場合、合致する場合のみ処理を進める
		NSString * specifiedMID = [dict valueForKey:MS_SPECIFYMID];
		if (specifiedMID) {//特定MID宛先があり、自分宛ではない
			if (![specifiedMID isEqualToString:[self myMID]]) {
				return;
			}
		}
		
		
		//送信者の名前と受信者の名前が同一であれば、抜ける 送信側で既に除外済み
		if ([senderName isEqualToString:[self myName]]) {
			NSAssert(false, @"同名の子供はブロードキャストの対象に出来ない");
		}
		
		
		if ([senderName isEqualToString:[self myParentName]]) {//送信者が自分の親の場合のみ、処理を進める
			
			[self saveLogForReceived:recievedLogDict];
			
			
			//設定されたbodyのメソッドを実行
			IMP func = [myBodyID methodForSelector:myBodySelector];
			(* func)(myBodyID, myBodySelector, notification);
			return;
		}
		
		//対象ではなかった
		return;
	}
	
	
	
	//子供から親に向けてのコールを受け取った
	if ([categolyName isEqualToString:MS_CATEGOLY_CALLPARENT]) {//親に送られたメッセージ
		
		if (![address isEqualToString:[self myName]]) {//送信者の指定した宛先が自分か
			//			NSLog(@"MS_CATEGOLY_CALLPARENT_宛先ではないMessnegerが受け取った");
			return;
		}
		
		
		//宛先MIDのキーがあるか
		NSString * calledParentMSID = [dict valueForKey:MS_ADDRESS_MID];
		if (!calledParentMSID) {
			//			NSLog(@"親のMIDの入力が無ければ無効");
			return;//値が無ければ無視する
		}
		
		
		//自分のMIDと一致するか
		if (![calledParentMSID isEqualToString:[self myMID]]) {
			//			NSLog(@"同名の親が存在するが、呼ばれている親と異なるため無効");
			return;
		}
		
		for (id key in [self childrenDict]) {//子供リストに含まれていなければ実行しないし、受け取らない。
			if ([[[self childrenDict] objectForKey:key] isEqualToString:senderName]) {
				[self saveLogForReceived:recievedLogDict];
				
				//設定されたbodyのメソッドを実行
				IMP func = [myBodyID methodForSelector:myBodySelector];
				(*func)(myBodyID, myBodySelector, notification);
				return;
			}
		}
		
		return;
	}
    
    
    //返り値系 カテゴリが届いた
    //子供から親へのcallback
    if ([categolyName isEqualToString:MS_CATEGOLY_CALLBACK_FROM_CHILD]) {
        
        //自分宛かどうか、先ず名前で判断
		if (![address isEqualToString:[self myName]]) {
			return;
		}
        
        //宛先MIDのキーがあるか
		NSString * calledParentMSID = [dict valueForKey:MS_ADDRESS_MID];
		if (!calledParentMSID) {
			return;//値が無ければ無視する
		}
		
		
		//自分のMIDと一致するか
		if (![calledParentMSID isEqualToString:[self myMID]]) {
			return;
		}
		
		for (id key in [self childrenDict]) {//子供リストに含まれていなければ実行しないし、受け取らない。
			if ([[[self childrenDict] objectForKey:key] isEqualToString:senderName]) {
				[self saveLogForReceived:recievedLogDict];
				
				//設定されたbodyのメソッドを実行
				m_callbackDict = [self tagValueDictionaryFromNotification:notification];
				
                return;
			}
		}
        
        return;
    }
    
    //親から子供へのcallback
    if ([categolyName isEqualToString:MS_CATEGOLY_CALLBACK_FROM_PARENT]) {
        
        //自分宛かどうか、先ず名前で判断
		if (![address isEqualToString:[self myName]]) {
			return;
		}
        
        //オプションでの特定MID宛先がある場合、合致する場合のみ処理を進める
		NSString * specifiedMID = [dict valueForKey:MS_SPECIFYMID];
		if (specifiedMID) {//特定MID宛先があり、自分宛ではない
			if (![specifiedMID isEqualToString:[self myMID]]) {
				return;
			}
		}
		
		
		//送信者の名前と受信者の名前が同一であれば、抜ける 送信側で既に除外済み
		if ([senderName isEqualToString:[self myName]]) {
			NSAssert(false, @"同名の子供はブロードキャストの対象に出来ない");
		}
		
		
		if ([senderName isEqualToString:[self myParentName]]) {//送信者が自分の親の場合のみ、処理を進める
			//ログ
			[self saveLogForReceived:recievedLogDict];
			
			m_callbackDict = [self tagValueDictionaryFromNotification:notification];
            
			return;
		}
        
        return;
    }
	
	//親探索のサーチが届いた
	if ([categolyName isEqualToString:MS_CATEGOLY_PARENTSEARCH]) {
		
		//自分宛かどうか、先ず名前で判断
		if (![address isEqualToString:[self myName]]) {
			//			NSLog(@"MS_CATEGOLY_PARENTSEARCHのアドレスcheckに失敗");
			return;
		}
		
		//送信者が自分であれば無視する 自分から自分へのメッセージの無視
		if ([senderMID isEqualToString:[self myMID]]) {
			//			NSLog(@"自分が送信者なので無視する_%@", [self getMyMID]);
			return;
		}
		
		NSString * calledParentName = [dict valueForKey:MS_PARENTNAME];
		if (!calledParentName) {
			//			NSLog(@"親の名称に入力が無ければ無視！");
			return;//値が無ければ無視する
		}
		
		
		if ([calledParentName isEqualToString:[self myName]]) {//それが自分だったら
			
			id invocatorId = [notification object];
			
			//オプションでの特定MID宛先がある
			NSString * specifiedMID = [dict valueForKey:MS_SPECIFYMID];
			if (specifiedMID) {//特定MID宛先があり、自分宛ではない
				if (![specifiedMID isEqualToString:[self myMID]]) {
					
					return;
				}
				
				if ([invocatorId hasParent]) {
					NSAssert(FALSE, @"親が既に存在している specified    %@", [self myName]);//現在は複数の親を許容する仕様ではないので、エラーとして発生させる
				}
				
			} else {
                NSLog(@"parent candidate received, %@, %@", [self myName], [self myMID]);
				NSLog(@"child is, %@, %@", [invocatorId myName], [invocatorId myMID]);
				//特定MIDが無い場合、親は先着順で設定される。既に子供が自分と同名の親にアクセスし、そのMIDを持っている場合があり得るため、ここで子供の持っている親MIDを確認する必要がある
				if ([invocatorId hasParent]) {
					NSAssert(FALSE, @"親が既に存在している    %@", [self myName]);//現在は複数の親を許容する仕様ではないので、エラーとして発生させる
				}
			}
			
			
			//受信時にログに受信記録を付け、保存する
			[self saveLogForReceived:recievedLogDict];
			
            //遠隔実行で子供の親名簿に自分のMIDを登録する 子供がもつ、引数１の関数[setMyParentMID　を親から実行する。]
			[self remoteInvocation:invocatorId withDict:dict, [self myMID], nil];
			
			
			//遠隔実行後、自分の子供として記録する
			[self setChildrenDictChildNameAsValue:senderName withMIDAsKey:senderMID];
			
			return;
		}
		
		
		//自分宛ではない
		//		NSLog(@"自分宛ではないので、無視する_%@	called%@", myName, calledParentName);
		return;
	}
	
	
	//親解消のコマンドが届いた
	if ([categolyName isEqualToString:MS_CATEGOLY_REMOVE_PARENT]) {
		
		//自分宛かどうか、先ず名前で判断
		if (![address isEqualToString:[self myName]]) {
			return;
		}
		
		//自分宛かどうか、MIDで判断
		//宛先MIDのキーがあるか
		NSString * calledParentMSID = [dict valueForKey:MS_ADDRESS_MID];
		if (!calledParentMSID) {
			return;
		}
		
		
		//受信時にログに受信記録を付け、保存する
		[self saveLogForReceived:recievedLogDict];
		
		
		//自分の子供辞書にある、子供情報を削除する
		[self removeChildrenDictChildNameAsValue:senderName withMIDAsKey:senderMID];
		
		return;
	}
	
	//子供解消のコマンドが届いた
	if ([categolyName isEqualToString:MS_CATEGOLY_REMOVE_CHILD]) {
		//		NSLog(@"MS_CATEGOLY_REMOVE_CHILD到着");
		
		//自分自身を除外
		if ([[self myMID] isEqualToString:senderMID]) {
			return;
		}
		
		//親を持っていなければ除外
		if (![self hasParent]) {
			return;
		}
		
		//送信者が自分の親の名前と一致するか
		if (![senderName isEqualToString:[self myParentName]]) {
			return;
		}
		
		
		//送信者のMIDが自分の親MIDと同一の場合のみ、実行
		if ([senderMID isEqualToString:[self myParentMID]]) {
			//ログ
			[self saveLogForReceived:recievedLogDict];
			
            [self resetParent];
			
			//通知
			[self updatedNotice:[self myParentName] withParentMID:[self myParentMID]];
		}
		return;
	}
	
	NSAssert1(false, @"MessengerSystem_innerPerform_想定外のカテゴリ_%@",categolyName);
}

/**
 パフォーマンス実行を行う
 */
- (void) sendPerform:(NSMutableDictionary * )dict {
	
	[[NSNotificationCenter defaultCenter] postNotificationName:OBSERVER_ID object:self userInfo:(id)dict];
	
}

/**
 send message with delay
 */
- (void) sendPerform:(NSMutableDictionary * )dict withDelay:(float)delay {
	[self performSelector:@selector(sendPerform:) withObject:dict afterDelay:delay];
}


/**
 メッセージの送信
 */
- (void) sendMessage:(NSMutableDictionary * )dict {
	
	[self addCreationLog:dict];
	
	//遅延実行キーがある場合
	NSNumber * delay = [dict valueForKey:MS_DELAY];
	if (delay) {
		float delayTime = [delay floatValue];
		[self sendPerform:dict withDelay:delayTime];
		return;
	}
	
	
	//通常の送信を行う
	[self sendPerform:dict];
}




/**
 受け取ったデータに遠隔実行が含まれているか否か返す
 */
- (BOOL) isIncludeRemote:(NSDictionary * )dict {
	if ([dict valueForKey:MS_RETURN]) {
		return TRUE;
	}
	return FALSE;
}

/**
 遠隔実行発行メソッド
 プライベート版、可変長引数受付
 */
- (void) remoteInvocation:(id)inv withDict:(NSDictionary * )dict, ... {
	
	if (![self isIncludeRemote:dict]) {
		NSAssert(FALSE, @"リモート実行コマンドが設定されていないメッセージに対してremoteInvocationメソッドを実行しています。");
		return;
	}
	
	NSDictionary * invokeDict = [dict valueForKey:MS_RETURN];
	
	id invocatorId;
	id signature;
	SEL method;
	
	id invocation;
	
	
	invocatorId = inv;
	if (!invocatorId) {
		NSAssert(FALSE, @"MS_RETURNIDが無い");
		return;
	}
	
	signature = [invokeDict valueForKey:MS_RETURNSIGNATURE];
	if (!signature) {
		NSAssert(FALSE, @"MS_RETURNSIGNATUREが無い");
		return;
	}
	
	method = NSSelectorFromString([invokeDict valueForKey:MS_RETURNSELECTOR]);
	if (!method) {
		NSAssert(FALSE, @"MS_RETURNSELECTORが無い");
		return;
	}
	
	
	//NSInvocationを使った実装
	invocation = [NSInvocation invocationWithMethodSignature:signature];
	[invocation setSelector:method];
	[invocation setTarget:invocatorId];
	
	
	int i = 2;//0,1が埋まっているから固定値 2から先に値を渡せるようにする必要がある
	
	va_list ap;
	id param;
	va_start(ap, dict);
	param = va_arg(ap, id);
	
	while (param) {
		
		[invocation setArgument:&param atIndex:i];
		i++;
		
		param = va_arg(ap, id);
	}
	va_end(ap);
	
	[invocation invoke];//実行
}

/**
 MessengerSystem間の親決めでのみ使用する、遠隔実行セットメソッド
 */
- (NSDictionary * ) setPrivateRemoteInvocationFrom:(id)mySelf withSelector:(SEL)sel {
	
	NSDictionary * retDict = [NSDictionary dictionaryWithObjectsAndKeys:
							  @"DUMMY_POINTER",	MS_RETURNID,
							  [mySelf methodSignatureForSelector:sel],	MS_RETURNSIGNATURE,
							  NSStringFromSelector(sel),	MS_RETURNSELECTOR,
							  nil];
	return retDict;
}




//private notices
/**
 自分が作成完了した事をお知らせする
 受け取っても行う処理の存在しない、宛先の無いメソッド
 */
- (void) createdNotice {
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:3];
	
	[dict setValue:MS_NOTICE_CREATED forKey:MS_CATEGOLY];
	[dict setValue:[self myName] forKey:MS_SENDERNAME];
	[dict setValue:[self myMID] forKey:MS_SENDERMID];
	
	//最終送信処理
	[self sendPerform:dict];
}

/**
 親が決定した事をお知らせする
 受け取っても行う処理の存在しない、宛先の無いメソッド
 */
- (void) updatedNotice:(NSString * )parentName withParentMID:(NSString * )parentMID {
	
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:5];
	
	[dict setValue:MS_NOTICE_UPDATE forKey:MS_CATEGOLY];
	
	[dict setValue:[self myParentName] forKey:MS_PARENTNAME];
	[dict setValue:[self myParentMID] forKey:MS_PARENTMID];
	
	[dict setValue:[self myName] forKey:MS_SENDERNAME];
	[dict setValue:[self myMID] forKey:MS_SENDERMID];
	
	//最終送信処理
	[self sendPerform:dict];
}

/**
 自死をお知らせする
 受け取っても行う処理の存在しない、宛先の無いメソッド
 */
- (void) killedNotice {
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:3];
	
	[dict setValue:MS_NOTICE_DEATH forKey:MS_CATEGOLY];
	
	[dict setValue:[self myName] forKey:MS_SENDERNAME];
	[dict setValue:[self myMID] forKey:MS_SENDERMID];
	
	//最終送信処理
	[self sendPerform:dict];
}





//parent manage
- (void) setMyParentName:(NSString * )parent {
    myParentName = parent;
}
- (void) setMyParentMID:(NSString * )parentMID {
    if ([[self myParentMID] isEqualToString:MS_DEFAULT_PARENTMID]) {
		
		[self saveToLogStore:@"setMyParentMID" log:[self tag:MS_LOG_LOGTYPE_GOTP val:[self myParentName]]];
		
		
		myParentMID = parentMID;
		
		[self updatedNotice:[self myParentName] withParentMID:[self myParentMID]];
	}
}
- (void) resetParent {
    [self setMyParentName:MS_DEFAULT_PARENTNAME];
    myParentMID = MS_DEFAULT_PARENTMID;
}



//children manage
/**
 自分をParentとして指定してきたChildについて、子供のmyNameとmyMIDを自分のm_childDictに登録する。
 */
- (void) setChildrenDictChildNameAsValue:(NSString * )senderName withMIDAsKey:(NSString * )senderMID {
	
	[[self childrenDict] setValue:senderName forKey:senderMID];
	
}
/**
 子供からの要請で、m_childDictから該当の子供情報を削除する
 */
- (void) removeChildrenDictChildNameAsValue:(NSString * )senderName withMIDAsKey:(NSString * )senderMID {
	[[self childrenDict] removeObjectForKey:senderMID];
}





//log
/**
 メッセージ発生時のログ書き込み、ログ初期化
 メッセージIDを作成、いろいろな情報をまとめる
 */
- (void) addCreationLog:(NSMutableDictionary * )dict {
	
	//ログタイプ、タイムスタンプを作成
	//メッセージに対してはメッセージIDひも付きの新規ログをつける事になる。
	//ストアについては、新しいIDのものが出来るとIDの下に保存する。多元木構造になっちゃうなあ。カラムでやった方が良いのかしら？それとも絡み付いたKVSかしら。
	
	NSString * messageID = [KSMessenger generateMID];//このメッセージのIDを出力(あとでID認識するため)
	
	
	//ストアに保存する
	[self saveToLogStore:MS_LOGMESSAGE_CREATED log:[self tag:MS_LOG_MESSAGEID val:messageID]];
	
	
	//messageとともに移動するログに内容をセットする
	NSDictionary * newLogDictionary;
	newLogDictionary = [NSDictionary dictionaryWithObject:messageID forKey:MS_LOG_MESSAGEID];
	
	[dict setValue:newLogDictionary forKey:MS_LOGDICTIONARY];
}

/**
 受け取り時のログ書き込み
 
 受信したメッセージからログを受け取り、
 ログの末尾に含まれているメッセージIDでもって、過去に受け取ったことがあるかどうか判定(未実装)、
 ログストアに保存する。
 */
- (void) saveLogForReceived:(NSMutableDictionary * ) recievedLogDict {
	//ログタイプ、タイムスタンプを作成
	NSString * messageID = (NSString * )[recievedLogDict valueForKey:MS_LOG_MESSAGEID];
	
	//ストアに保存する
	[self saveToLogStore:MS_LOGMESSAGE_RECEIVED log:[self tag:MS_LOG_MESSAGEID val:messageID]];
}

/**
 返信時のログ書き込み
 
 どこからか取得したメッセージIDでもって、
 保存していたログストアからログデータを読み出し、
 最新の「送信しました」記録を行い、
 記録をログ末尾に付け加えたログを返す。
 */
- (NSMutableDictionary * ) createLogForReply {
	NSAssert(FALSE, @"createLogForReplyは未完成のため、使用禁止です。");
	//ログタイプ、タイムスタンプを作成
	[m_logDict setValue:@"仮のmessageID" forKey:MS_LOG_MESSAGEID];
	
	return m_logDict;
}

/**
 可変長ログストア入力
 */
- (void) saveToLogStore:(NSString * )name log:(NSDictionary * )value {
	
	NSArray * key = [value allKeys];//1件しか無い内容を取得する
	
	[m_logDict setValue:
	 [NSString stringWithFormat:@"%@ %@", name, [value valueForKey:[key objectAtIndex:0]]]
				 forKey:
	 [NSString stringWithFormat:@"%@ %@", [KSMessenger generateMID], [NSDate date]]
	 ];
	
	
}




@end



@implementation KSMessenger

+ (NSString * ) generateMID {
	CFUUIDRef	uuidObj = CFUUIDCreate(nil);
	NSString * uuidString = (NSString * )CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return uuidString;
}


- (void) openConnection {
    [self resetParent];
    m_childrenDict = [[NSMutableDictionary alloc] init];
    m_logDict = [[NSMutableDictionary alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(innerPerform:) name:OBSERVER_ID object:nil];

}
- (void) closeConnection {
    NSLog(@"i will exit, %@, %@", [self myName], [self myMID]);
	[[NSNotificationCenter defaultCenter] removeObserver:self name:OBSERVER_ID object:nil];//ノーティフィケーションから外す
	
	if ([self hasChild]) [self removeAllChildren];
	NSAssert([[self childrenDict] count] == 0, @"childDict_%d",[[self childrenDict] count]);
	
	if ([self hasParent]) [self removeFromParent];
	NSAssert([myParentName isEqualToString:MS_DEFAULT_PARENTNAME], @"myParentName is not MS_DEFAULT_PARENTNAME");
    NSAssert([myParentMID isEqualToString:MS_DEFAULT_PARENTMID], @"myParentName is not MS_DEFAULT_PARENTMID");
}


//init

- (id) initWithBodyID:(id)body_id withSelector:(SEL)body_selector withName:(NSString * )name {

	if (self = [super init]) {
        
		NSAssert(name, @"withName引数がnilです。　名称をセットしてください。");
		myName = [[NSString alloc]initWithString:name];
		
		NSAssert(body_id, @"initWithBodyID引数がnilです。　制作者のidをセットしてください。");
		[self setMyBodyID:body_id];
		
		NSAssert(body_selector, @"withSelector引数がnilです。　実行セレクタをセットしてください。");
		[self setMyBodySelector:body_selector];
		
		myMID = [[NSString alloc] initWithString:[KSMessenger generateMID]];
        NSLog(@"i am %@, %@",name, myMID);
        
        [self openConnection];
        
        [self createdNotice];
	}
	
	return self;
}


//relationship

/**
 親候補を探索、存在する場合、親子関係を構築する
 
 親へと自分が子供である事の通知を行い、返り値として親のMIDをmyParentMIDとして受け取るメソッド
 受け取り用のメソッドの情報を親へと渡し、親からの遠隔MID入力を受ける。
 */
- (void) connectParent:(NSString * )parentName {
	NSAssert1(![parentName isEqualToString:[self myName]], @"自分と同名のmessengerを親に指定する事は出来ません_指定されたparentName_%@", parentName);
	[self connectParent:parentName withSpecifiedMID:nil];
}


/**
 特定IDを持つ親候補を探索、存在する場合、親子関係を構築する
 
 親へと自分が子供である事の通知を行い、返り値として親のMIDをmyParentMIDとして受け取るメソッド
 親のMIDを特に特定できる場合に使用する。
 */
- (void) connectParent:(NSString *)parent withSpecifiedMID:(NSString * )mID {
	
	NSAssert([[self myParentName] isEqualToString:MS_DEFAULT_PARENTNAME], @"デフォルト以外の親が既にセットされています。親を再設定する場合、resetMyParentDataメソッドを実行してから親指定を行ってください。");
	
	//親の名前を設定
    myParentName = parent;
	
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:7];
	
	[dict setValue:MS_CATEGOLY_PARENTSEARCH forKey:MS_CATEGOLY];
	[dict setValue:[self myParentName] forKey:MS_ADDRESS_NAME];
	[dict setValue:[self myParentName] forKey:MS_PARENTNAME];
	
	[dict setValue:[self myName] forKey:MS_SENDERNAME];
	[dict setValue:[self myMID] forKey:MS_SENDERMID];
	
	
	if (mID) [dict setValue:mID forKey:MS_SPECIFYMID];//特定の親宛であればキーを付ける
	
	
	//遠隔実装メソッドを設定 一般的なinvokeメソッドではなく、senderIDを偽装、カウンタが増えないようにしたものを使用する。
	[dict setValue:[self setPrivateRemoteInvocationFrom:self withSelector:@selector(setMyParentMID:)] forKey:MS_RETURN];
	
	
	//ログを作成する
	[self addCreationLog:dict];
	
	//最終送信処理
	[self sendPerform:dict];
	
	//この時点で親からの実行が完了。
	[dict removeAllObjects];
	
	
	NSAssert1([self hasParent], @"指定した親が存在しないようです。inputParentに指定している名前を確認してください_現在探して見つからなかった親の名前は_%@",[self myParentName]);
	
}

/**
 現在の親情報を削除する
 */
- (void) removeFromParent {
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:6];
	
	[dict setValue:MS_CATEGOLY_REMOVE_PARENT forKey:MS_CATEGOLY];
	
	[dict setValue:[self myParentName] forKey:MS_ADDRESS_NAME];
	[dict setValue:[self myParentMID] forKey:MS_ADDRESS_MID];
	
	[dict setValue:[self myName] forKey:MS_SENDERNAME];
	[dict setValue:[self myMID] forKey:MS_SENDERMID];
	
	//ログを作成する
	[self addCreationLog:dict];
	
	//最終送信処理
	[self sendPerform:dict];//送信に失敗すると、親子関係は終了しない。この部分でエラーが出るのがたより。
	
	//初期化
	[self resetParent];//初期化 この時点で子供から見た親情報はデフォルトになる
	
	//更新通知
	[self updatedNotice:[self myParentName] withParentMID:[self myParentMID]];
}

- (void) removeAllChildren {
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:6];
	
	[dict setValue:MS_CATEGOLY_REMOVE_CHILD forKey:MS_CATEGOLY];
	
	[dict setValue:[self myName] forKey:MS_ADDRESS_NAME];
	[dict setValue:[self myMID] forKey:MS_ADDRESS_MID];
	
	[dict setValue:[self myName] forKey:MS_SENDERNAME];
	[dict setValue:[self myMID] forKey:MS_SENDERMID];
	
	//ログを作成する
	[self addCreationLog:dict];
	
	//最終送信処理
	[self sendPerform:dict];
	
	//初期化
	[[self childrenDict] removeAllObjects];
	
	//通知
	[self updatedNotice:[self myParentName] withParentMID:[self myParentMID]];
}

/**
 親が設定されているか否か返す
 */
- (BOOL) hasParent {
	if (![[self myParentMID] isEqual:MS_DEFAULT_PARENTMID]) {//デフォルト
		return TRUE;
	}
	return FALSE;
}

/**
 子供が設定されているか否か返す
 */
- (BOOL) hasChild {
	if (0 < [[self childrenDict] count]) {
		return TRUE;
	}
	return FALSE;
}

- (NSMutableDictionary * ) childrenDict {
    return m_childrenDict;
}





/**
 自分自身のmessengerへと通信を行うメソッド
 */
- (void) callMyself:(int)exec, ... {
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:5];
	
	[dict setValue:MS_CATEGOLY_LOCAL forKey:MS_CATEGOLY];
	[dict setValue:[self myName] forKey:MS_ADDRESS_NAME];
	
	[dict setValue:[self generateExec:exec withMyName:[self myName]] forKey:MS_EXECUTE];
	[dict setValue:[self myName] forKey:MS_SENDERNAME];
	[dict setValue:[self myMID] forKey:MS_SENDERMID];
	
	va_list ap;
	id kvDict;
	
	//NSLog(@"start_%@", exec);
	
	va_start(ap, exec);
	kvDict = va_arg(ap, id);
	
	while (kvDict) {
		//NSLog(@"kvDict_%@", kvDict);
		
		for (id key in kvDict) {
			//					NSLog(@"[kvDict valueForKey:key]_%@, key_%@", [kvDict valueForKey:key], key);
			[dict setValue:[kvDict valueForKey:key] forKey:key];
		}
		
		kvDict = va_arg(ap, id);
	}
	va_end(ap);
	
	
	[self sendMessage:dict];
}

/**
 特定の名前のmessengerへの通信を行うメソッド
 異なる名前の親から子へのメッセージ限定
 */
- (NSDictionary * ) call:(NSString * )childName withExec:(int)exec, ... {
	
	NSAssert(![childName isEqualToString:[self myName]], @"自分自身/同名の子供達へのメッセージブロードキャストをこのメソッドで行う事はできません。　callMyselfメソッドを使用してください");
	NSAssert(![childName isEqualToString:MS_DEFAULT_PARENTNAME], @"システムで予約してあるデフォルトの名称です。　この名称を使ってのシステム使用はお勧めしません。");
    NSAssert(exec != MS_DEFAULT_UNDEFINED_EXEC, @"you cannnot use exec = -1, this param is system-reserved as NONE, MS_DEFAULT_UNDEFINED_EXEC.");
    NSAssert(0 <= exec, @"must not negative. 0 <= exec");
	
	//特定のvalが含まれているか
	NSArray * arrays = [[self childrenDict] allValues];
	for (int i = 0; i <= [arrays count]; i++) {
		if (i == [arrays count]) {
			NSAssert1(FALSE, @"Without MID call先に指定したmessengerが存在しないか、未知のものです。このメソッドを使用するより先に、子供MessengerからfindParent(子から親を指定)を使ってください。_%@",childName);
			return nil;
		}
		
		if ([[arrays objectAtIndex:i] isEqualToString:childName]) {
			break;
		}
	}
	
	
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:5];
	
	[dict setValue:MS_CATEGOLY_CALLCHILD forKey:MS_CATEGOLY];
	[dict setValue:childName forKey:MS_ADDRESS_NAME];
	
	[dict setValue:[self generateExec:exec withMyName:[self myName]] forKey:MS_EXECUTE];
	[dict setValue:[self myName] forKey:MS_SENDERNAME];
	[dict setValue:[self myMID] forKey:MS_SENDERMID];
	
	va_list ap;
	id kvDict;
	
	//NSLog(@"start_%@", exec);
	
	va_start(ap, exec);
	kvDict = va_arg(ap, id);
	
	while (kvDict) {
		//NSLog(@"kvDict_%@", kvDict);
		
		for (id key in kvDict) {
			//					NSLog(@"[kvDict valueForKey:key]_%@, key_%@", [kvDict valueForKey:key], key);
			[dict setValue:[kvDict valueForKey:key] forKey:key];
		}
		
		kvDict = va_arg(ap, id);
	}
	va_end(ap);
	
	[self sendMessage:dict];
    
    //m_callbackDictがあれば返す
    if (m_callbackDict) return m_callbackDict;
    
	return nil;
}

/**
 特定の子への通信を行うメソッド、特にMIDを使い、相手を最大限特定する。
 */
- (NSDictionary * ) call:(NSString * )childName withSpecifiedMID:(NSString * )mID withExec:(int)exec, ... {
	NSAssert(![childName isEqualToString:[self myName]], @"自分自身/同名の子供達へのメッセージブロードキャストをこのメソッドで行う事はできません。　callMyselfメソッドを使用してください");
	NSAssert(![childName isEqualToString:MS_DEFAULT_PARENTNAME], @"システムで予約してあるデフォルトの名称です。　この名称を使ってのシステム使用は、その、なんだ、お勧めしません。");
	NSAssert(mID ,@"mIDはnilでないNSStringである必要があります");
	
    NSAssert(exec != MS_DEFAULT_UNDEFINED_EXEC, @"you cannnot use exec = -1, this param is system-reserved as NONE, MS_DEFAULT_UNDEFINED_EXEC.");
    NSAssert(0 <= exec, @"must not negative. 0 <= exec");
    
    
	//MIDキーが含まれているか、その値がchildNameと一致するか
	NSString * val = [[self childrenDict] valueForKey:mID];
	if (!val) {
		NSAssert1(FALSE, @"with MID call先に指定したmessengerが存在しないか、未知のものです。本messengerを親とした設定を行うよう、子から親を指定してください。_%@",childName);
		return nil;
	}
	
	if (![val isEqualToString:childName]) {
		NSAssert1(FALSE, @"with MID call先に指定したmessengerの名称とMIDのペアが一致しません_%@",childName);
		return nil;
	}
	
	
	NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:6];
	
	[dict setValue:MS_CATEGOLY_CALLCHILD forKey:MS_CATEGOLY];
	[dict setValue:childName forKey:MS_ADDRESS_NAME];
	
	[dict setValue:[self generateExec:exec withMyName:[self myName]] forKey:MS_EXECUTE];
	[dict setValue:[self myName] forKey:MS_SENDERNAME];
	[dict setValue:[self myMID] forKey:MS_SENDERMID];
	
	[dict setValue:mID forKey:MS_SPECIFYMID];
	
	
	va_list ap;
	id kvDict;
	
	//NSLog(@"start_%@", exec);
	
	va_start(ap, exec);
	kvDict = va_arg(ap, id);
	
	while (kvDict) {
		//NSLog(@"kvDict_%@", kvDict);
		
		for (id key in kvDict) {
			//					NSLog(@"[kvDict valueForKey:key]_%@, key_%@", [kvDict valueForKey:key], key);
			[dict setValue:[kvDict valueForKey:key] forKey:key];
		}
		
		kvDict = va_arg(ap, id);
	}
	va_end(ap);
	
	[self sendMessage:dict];
    
    //m_callbackDictがあれば返す
    if (m_callbackDict) return m_callbackDict;
    
    return nil;
}

/**
 親への通信を行うメソッド
 */
- (NSDictionary * ) callParent:(int)exec, ... {
	
    NSAssert(exec != MS_DEFAULT_UNDEFINED_EXEC, @"you cannnot use exec = -1, this param is system-reserved as NONE, MS_DEFAULT_UNDEFINED_EXEC.");
    NSAssert(0 <= exec, @"must not negative. 0 <= exec");
    
	//親が居たら
	if ([self hasParent]) {
		NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:5];
		
		[dict setValue:MS_CATEGOLY_CALLPARENT forKey:MS_CATEGOLY];
		[dict setValue:[self myParentName] forKey:MS_ADDRESS_NAME];
		[dict setValue:[self myParentMID] forKey:MS_ADDRESS_MID];
		
		
		[dict setValue:[self generateExec:exec withMyName:[self myName]] forKey:MS_EXECUTE];
		[dict setValue:[self myName] forKey:MS_SENDERNAME];
		[dict setValue:[self myMID] forKey:MS_SENDERMID];
		
		
		//tag付けされた要素以外は無視するように設定
		//可変長配列に与えられた要素を処理する。
		
		va_list vp;//可変引数のポインタになる変数
		id kvDict;//可変長引数から辞書を取り出すときに使用するポインタ
		
		//NSLog(@"start_%@", exec);
		
		va_start(vp, exec);//vpを可変長配列のポインタとして初期化する
		kvDict = va_arg(vp, id);//vpから現在の可変長配列のヘッドにあるidを抽出し、kvDictに代入。この時点でkvDictは可変長配列のトップの要素のidを持っている。
		
		while (kvDict) {//存在していなければnull、可変長引数の終了の合図。
			
			//NSLog(@"kvDict_%@", kvDict);
			
			for (id key in kvDict) {
				
				//NSLog(@"[kvDict valueForKey:key]_%@, key_%@", [kvDict valueForKey:key], key);
				//型チェック、kvDict型で無ければ無視する必要がある。
				if (true) [dict setValue:[kvDict valueForKey:key] forKey:key];
				
			}
			
			kvDict = va_arg(vp, id);//次の値を読み出す
		}
		
		va_end(vp);//終了処理
		
		[self sendMessage:dict];
		
        //m_callbackDictがあれば返す
        if (m_callbackDict) return m_callbackDict;
        
		return nil;
	}
	
	NSAssert(false, @"親設定が無い");
    return nil;
}

/**
 callかcallParentで呼ばれた側が、callbackを行う。
 */
- (void) callback:(NSNotification * )notif, ... {
    
    //Notificationが欲しい情報を保持しているかどうかチェック
    NSMutableDictionary * sourceDict = (NSMutableDictionary *)[notif userInfo];
	NSLog(@"sourceDict  %@", sourceDict);
    
	//送信者MID
	NSString * senderMID = [sourceDict valueForKey:MS_SENDERMID];
	NSAssert(senderMID, @"senderMID is nil");
    
	//送信者名
    NSString * parentOrChild = [sourceDict valueForKey:MS_SENDERNAME];
    NSAssert(parentOrChild, @"parentOrChild is nil");
    
    //categolyName
    NSString * categolyName = [sourceDict valueForKey:MS_CATEGOLY];
    NSAssert(categolyName, @"categolyName is nil");
    
    //遅延実行があったら、値を返せない旨でAssertFalse
    if ([sourceDict valueForKey:MS_DELAY]) {
        NSAssert(false, @"this callback was called with -withDelay- keyword. not approrval in this version yet.");
    }
    
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:5];
    
    //自分が子供で、親から呼ばれた
    if ([categolyName isEqualToString:MS_CATEGOLY_CALLCHILD]) {
        if (![parentOrChild isEqualToString:[self myParentName]]) {
            NSAssert([parentOrChild isEqualToString:[self myParentName]], @"一致しない親へのcallback name");
            return;
        }
        
        if (![senderMID isEqualToString:[self myParentMID]]) {
            NSAssert([senderMID isEqualToString:[self myParentMID]], @"一致しない親へのcallback mid");
            return;
        }
        
		[dict setValue:MS_CATEGOLY_CALLBACK_FROM_CHILD forKey:MS_CATEGOLY];
		[dict setValue:[self myParentName] forKey:MS_ADDRESS_NAME];
		[dict setValue:[self myParentMID] forKey:MS_ADDRESS_MID];
    }
    
    //自分が親で、子供から呼ばれた
    if ([categolyName isEqualToString:MS_CATEGOLY_CALLPARENT]) {
        [dict setValue:MS_CATEGOLY_CALLBACK_FROM_PARENT forKey:MS_CATEGOLY];
		[dict setValue:parentOrChild forKey:MS_ADDRESS_NAME];
    }
    
    //共通処理
    {
		[dict setValue:[self myName] forKey:MS_SENDERNAME];
		[dict setValue:[self myMID] forKey:MS_SENDERMID];
		
		va_list vp;//可変引数のポインタになる変数
		id kvDict;//可変長引数から辞書を取り出すときに使用するポインタ
		
		va_start(vp, notif);//vpを可変長配列のポインタとして初期化する
		kvDict = va_arg(vp, id);//vpから現在の可変長配列のヘッドにあるidを抽出し、kvDictに代入。この時点でkvDictは可変長配列のトップの要素のidを持っている。
		
		while (kvDict) {//存在していなければnull、可変長引数の終了の合図。
			
			for (id key in kvDict) if (true) [dict setValue:[kvDict valueForKey:key] forKey:key];
			
			kvDict = va_arg(vp, id);//次の値を読み出す
		}
		
		va_end(vp);//終了処理
		[self sendMessage:dict];
    }
}




- (void) setMyBodyID:(id)bodyID {
	myBodyID = bodyID;
}
- (void) setMyBodySelector:(SEL)body_selector {
	myBodySelector = body_selector;
}
- (NSString * )myName {
	return myName;
}
- (NSString * )myMID {
	return myMID;
}
- (NSString * )myParentName {
    return myParentName;
}
- (NSString * )myParentMID {
    return myParentMID;
}


- (NSString * )generateExec:(int)exec withMyName:(NSString * )name {
	return [NSString stringWithFormat:@"%@%d", name, exec];
}

/**
 get exec from sender(parent/child/myself) via notification
    if input the name of sender who is not included in the relationship,
    assert will fail.
 */
- (int) execFrom:(NSString * )sender viaNotification:(NSNotification * )notif {
    NSDictionary * dict = [self tagValueDictionaryFromNotification:notif];
    NSString * execSource = [dict valueForKey:MS_EXECUTE];
    
    int exec;
    
    //sender name check
    if ([[dict valueForKey:MS_SENDERNAME] isEqualToString:sender]) {
        exec = [[execSource substringFromIndex:[sender length]] intValue];
        NSAssert(exec != MS_DEFAULT_UNDEFINED_EXEC, @"cannnot receive exec-param = -1, this is reserved as NONE in this system.");
        NSAssert(0 <= exec, @"cannnot receive negative-exec < 0");
    } else {
        exec = MS_DEFAULT_NONTARGETED_EXEC;// = NONE
    }
    
    //check relationship
    if ([sender isEqualToString:myName]) {
        return exec;
    }
    
    if ([sender isEqualToString:myParentName]) {
        return exec;
    }
    
    if ([[m_childrenDict allValues] containsObject:sender]) {
        return exec;
    }
    
    NSAssert(false, @"there is no relationships between self:%@ to sender:%@", [self myName], sender);
    return MS_DEFAULT_UNDEFINED_EXEC;
}

- (NSDictionary * ) tagValueDictionaryFromNotification:(NSNotification * )notif {
    return [notif userInfo];
}



/**
 tag-value function
 if nil is inserted to tag or val, assert failure.
 */
- (NSDictionary * ) tag:(id)obj_tag val:(id)obj_value {
	NSAssert1(obj_tag, @"tag_%@ is nil",obj_tag);
	NSAssert2(obj_value, @"val_%@ is nil for tag_%@",obj_value, obj_tag);
	
	return [NSDictionary dictionaryWithObject:obj_value forKey:obj_tag];
}


/**
 cancel send message with delay
 */
- (void) cancelPerform {
	[NSRunLoop cancelPreviousPerformRequestsWithTarget:self];
}


/**
 delay-tag
 send massage with delay.
 */
- (NSDictionary * ) withDelay:(float)delay {
	NSAssert1(delay,@"withDelay_%f is nil",delay);
	
	return [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:delay] forKey:MS_DELAY];
}



//Log
- (NSMutableDictionary * ) logStore {
	return m_logDict;
}





/**
 Dealloc
 */
- (void) dealloc {
	[self closeConnection];
    
	//ログ削除
	[m_logDict removeAllObjects];
    
    [self killedNotice];
}

@end
