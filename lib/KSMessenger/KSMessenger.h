//
//  KSMessenger.h
//  KSMessenger
//
//  Created by sassembla on 2012/12/27.
//  Copyright (c) 2012年 KISSAKI Inc,. All rights reserved.
//

#define MS_VERSION (@"0.5.2")//2013/05/17 0:35:19 fixed parent-missmatch bug.
/*
    (@"0.5.1")//2013/01/26 15:39:05 add "name@identity" function
    (@"0.5.0")//2013/01/24 14:18:14 open
    (@"0.0.1")//2012/12/27 20:09:37
 */





#import <Foundation/Foundation.h>

//カテゴリ系タグ メッセージの種類を用途ごとに分ける
#define MS_CATEGOLY                 (@"MESSENGER_SYSTEM_COMMAND")//コマンドに類するキー
#define MS_CATEGOLY_LOCAL			(@"MESSENGER_SYSTEM_COMMAND:CATEGOLY_LOCAL")//自分呼び出し
#define MS_CATEGOLY_CALLCHILD		(@"MESSENGER_SYSTEM_COMMAND:CATEGOLY_CALL_CHILD")//子供呼び出し
#define	MS_CATEGOLY_CALLPARENT		(@"MESSENGER_SYSTEM_COMMAND:CATEGOLY_CALL_PARENT")//親呼び出し
#define MS_CATEGOLY_CALLBACK_FROM_CHILD        (@"MESSENGER_SYSTEM_COMMAND:CATEGOLY_CALLBACK_FROM_CHILD")//呼び主(親)へと返答
#define MS_CATEGOLY_CALLBACK_FROM_PARENT        (@"MESSENGER_SYSTEM_COMMAND:CATEGOLY_CALLBACK_FROM_PARENT")//呼び主(子)へと返答
#define MS_CATEGOLY_PARENTSEARCH	(@"MESSENGER_SYSTEM_COMMAND:CATEGOLY_PARENTSEARCH")//親探索
#define MS_CATEGOLY_REMOVE_PARENT	(@"MESSENGER_SYSTEM_COMMAND:CATEGOLY_REMOVEPARENT")//親の登録を消す
#define MS_CATEGOLY_REMOVE_CHILD	(@"MESSENGER_SYSTEM_COMMAND:CATEGOLY_REMOVECHILD")//子供の登録を消す
#define MS_CATEGOLY_CALLBACK        (@"MESSENGER_SYSTEM_COMMAND:CATEGOLY_CALLBACK")//呼び主へと返答


//通知系タグ
#define	MS_NOTICE_CREATED           (@"MESSENGER_SYSTEM_COMMAND:NOTICE_CREATED")//自分の発生を通知
#define MS_NOTICE_UPDATE            (@"MESSENGER_SYSTEM_COMMAND:NOTICE_UPDATED")//自分の関係性更新を通知
#define MS_NOTICE_DEATH             (@"MESSENGER_SYSTEM_COMMAND:NOTICE_DEATH")//自分の削除を通知


//送信者名、送信者MIDに関するタグ
#define MS_SENDERNAME               (@"MESSENGER_SYSTEM_COMMAND:LOGGED_SENDER_NAME")//自分の名前に類するキー
#define MS_SENDERMID                (@"MESSENGER_SYSTEM_COMMAND:LOGGED_SENDER_MID")//自分固有のMIDに類するキー


//実行内容に関するタグ
#define MS_ADDRESS_NAME             (@"MESSENGER_SYSTEM_COMMAND:ADDRESS_NAME")//宛先名に類するキー
#define MS_ADDRESS_MID              (@"MESSENGER_SYSTEM_COMMAND:ADDRESS_MID")//宛先MIDに類するキー
#define MS_EXECUTE                  (@"MESSENGER_SYSTEM_COMMAND:EXECUTE")//実行内容名に類するキー
#define MS_SPECIFYMID               (@"MESSENGER_SYSTEM_COMMAND:SPECIFY_MID")//特定の対象を識別するためのMIDに類するキー


//Parentに関するタグ
#define MS_PARENTNAME               (@"MESSENGER_SYSTEM_COMMAND:PARENT_NAME")//親の名前に類するキー
#define MS_PARENTMID                (@"MESSENGER_SYSTEM_COMMAND:PARENT_MID")//親の固有MIDに類するキー


//メソッド実行オプションに関するタグ
#define MS_RETURN                   (@"MESSENGER_SYSTEM_COMMAND:RETURN")//フック実行に類するキー
#define MS_RETURNID                 (@"MESSENGER_SYSTEM_COMMAND:RETURN_ID")//フック実行メソッドのidに類するキー
#define MS_RETURNSIGNATURE          (@"MESSENGER_SYSTEM_COMMAND:RETURN_SIGNATURE")//フック実行メソッドのSignature指定に類するキー
#define MS_RETURNSELECTOR           (@"MESSENGER_SYSTEM_COMMAND:RETURN_SELECTOR")//フック実行メソッドのSelector指定に類するキー


//遅延実行に関するタグ
#define MS_DELAY                    (@"MESSENGER_SYSTEM_COMMAND:DELAY")//遅延実行


//logに関するタグ
#define MS_LOGDICTIONARY            (@"MESSENGER_SYSTEM_COMMAND:LOG")
#define MS_LOG_MESSAGEID            (@"MESSENGER_SYSTEM_COMMAND:LOGGED_MESSAGE_ID")//メッセージ発生時割り振られるIDに類するキー
#define MS_LOG_LOGTYPE_NEW          (@"MESSENGER_SYSTEM_COMMAND:LOGGED_TYPE_NEW")//メッセージ作成時に設定される記録タイプに類するキー
#define MS_LOG_LOGTYPE_REC          (@"MESSENGER_SYSTEM_COMMAND:LOGGED_TYPE_RECEIVED")//メッセージ受取時に設定される記録タイプに類するキー
#define MS_LOG_LOGTYPE_REP          (@"MESSENGER_SYSTEM_COMMAND:LOGGED_TYPE_REPLIED")//メッセージ返送時に設定される記録タイプに類するキー
#define MS_LOG_LOGTYPE_GOTP         (@"MESSENGER_SYSTEM_COMMAND:LOGGED_TYPE_GOTPARENT")//親決定時に設定される記録タイプに類するキー

#define MS_LOG_TIMESTAMP            (@"MESSENGER_SYSTEM_COMMAND:LOGGED_TIMESTAMP")//タイムスタンプに類するキー

#define MS_LOGMESSAGE_CREATED       (@"MESSENGER_SYSTEM_COMMAND:MESSAGE_CREATED")
#define MS_LOGMESSAGE_RECEIVED      (@"MESSENGER_SYSTEM_COMMAND:MESSAGE_RECEIVED")


//initial param
#define MS_DEFAULT_PARENTNAME       (@"MESSENGER_SYSTEM_COMMAND:MS_DEFAULT_PARENTNAME")//デフォルトのmyParentName
#define MS_DEFAULT_PARENTMID        (@"MESSENGER_SYSTEM_COMMAND:MS_DEFAULT_PARENTMID")//デフォルトのmyParentMID

//exec of undefined
#define NONE                        (-1)
#define MS_DEFAULT_NONTARGETED_EXEC (NONE)
#define MS_DEFAULT_UNDEFINED_EXEC   (NONE)

#define VIEW_NAME_DEFAULT           (@"MESSENGER_SYSTEM_COMMAND:VIEW_NAME_DEFAULT")//デフォルトのViewのName ここに記述することで名称衝突を防ぐ


/**
 SPECIFIED_ID OF THIS CLASS for NSNOtification network
 */
#define OBSERVER_ID                 (@"MessengerSystemDefault_E2FD8F50-F6E9-42F6-8949-E7DD20312CA0")





@interface KSMessenger : NSObject {
	id myBodyID;    //master id
	SEL myBodySelector;//the selector that'll fire when received message
		
	NSString * myName;
	NSString * myMID;

	NSString * myParentName;
	NSString * myParentMID;
	
	
    NSMutableDictionary * m_childrenDict;
	
	
	NSMutableDictionary * m_logDict;//log
    
    NSDictionary * m_callbackDict;//返り値反映用辞書
}

/**
 generate Messenger Identity
 */
+ (NSString * ) generateMID;

/**
 open connection to NSNotification
 */
- (void) openConnection;

/**
 close connection to NSNotification
 */
- (void) closeConnection;


/**
 initialize
 */
- (id) initWithBodyID:(id)body_id withSelector:(SEL)body_selector withName:(NSString * )name;


//relationship
- (void) connectParent:(NSString * )parentName;//input myself to "parentName" messenger as these child.
- (void) connectParent:(NSString *)parent withSpecifiedMID:(NSString * )mID;//with specified id
- (void) removeFromParent;//remove relationship from the child to the parent
- (void) removeAllChildren;//remove all relationships from the parent to the children
- (BOOL) hasParent;
- (BOOL) hasChild;
- (NSMutableDictionary * ) childrenDict;


//call
- (void) callMyself:(int)exec, ... NS_REQUIRES_NIL_TERMINATION;//send message from myself to myself
- (NSDictionary * ) call:(NSString * )childName withExec:(int)exec, ... NS_REQUIRES_NIL_TERMINATION;//send message to child
- (NSDictionary * ) call:(NSString * )childName withSpecifiedMID:(NSString * )mID withExec:(int)exec, ... NS_REQUIRES_NIL_TERMINATION;//send message to child who has specified-id
- (NSDictionary * ) callParent:(int)exec, ... NS_REQUIRES_NIL_TERMINATION;//send message to parent
- (void) callback:(NSNotification * )notif, ... NS_REQUIRES_NIL_TERMINATION;//send callback to sender


/**
 tags and values
 */
- (NSDictionary * ) tag:(id)obj_tag val:(id)obj_value;
- (NSDictionary * ) val:(id)obj_value tag:(id)obj_tag;
- (NSDictionary * ) addTagValues:(NSDictionary * )tagValuesDict;
- (NSDictionary * ) withDelay:(float)delay;//set delay


/**
 log
 */
- (NSMutableDictionary * ) logStore;//保存されたログ一覧を取得するメソッド


/**
 Unitlity
 */
- (void) setMyBodyID:(id)bodyID;
- (void) setMyBodySelector:(SEL)body_selector;

- (NSString * )myName;
- (NSString * )myMID;
- (NSString * )myNameAndMID;
- (NSString * )myParentName;
- (NSString * )myParentMID;



/**
 generate exec as NSString from int & messenger's name
 */
- (NSString * )generateExec:(int)exec withMyName:(NSString * )name;

/**
 get exec as int from specified sender via notification
 */
- (int) execFrom:(NSString * )sender viaNotification:(NSNotification * )notif;



/**
 get dictionary via notification
 */
- (NSDictionary * ) tagValueDictionaryFromNotification:(NSNotification * )notif;



/**
 cancel send message with delay
 */
- (void) cancelPerform;



@end
