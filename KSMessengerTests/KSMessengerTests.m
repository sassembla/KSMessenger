//
//  KSMessengerTests.h
//  KSMessengerTests
//
//  Created by sassembla on 2012/12/27.
//  Copyright (c) 2012年 KISSAKI Inc,. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "KSMessenger.h"


@interface KSMessengerTests : SenTestCase @end




//-------------------test stuff defines & enums
#define TEST_PARENT_NAME        (@"TEST_PARENT_NAME")
#define TEST_CHILDPERSIS_NAME   (@"TEST_CHILDPERSIS_NAME")

#define TEST_CHILD_NAME_0       (@"TEST_CHILD_NAME_0")
#define TEST_CHILD_NAME_1       (@"TEST_CHILD_NAME_1")
#define TEST_CHILD_NAME_2       (@"TEST_CHILD_NAME_2")
#define TEST_CHILD_NAME_3       (@"TEST_CHILD_NAME_3")

#define TEST_NAME_2012_12_27_20_51_04   (@"TEST_NAME_2012_12_27_20_51_04")

#define TEST_FORBIDDEN_EXEC_PARAM   (-1)


typedef enum {
    TEST_EXEC = 0,
    TEST_EXEC_CALLMYSELF,
    TEST_EXEC_1,
    TEST_EXEC_2,
    TEST_EXEC_2REPLY,
    
    TEST_PARENT_MULTICHILD,
    
    TEST_EXEC_2012_12_27_20_23_44,
    TEST_EXEC_2012_12_27_20_24_04,
    TEST_EXEC_2012_12_27_20_25_46,
    TEST_EXEC_2012_12_27_20_26_22,
    TEST_EXEC_2012_12_27_20_26_32,
    TEST_EXEC_2012_12_27_20_49_31,
    TEST_EXEC_2012_12_27_20_49_56,
    TEST_EXEC_2012_12_27_20_52_33,
    TEST_EXEC_2012_12_27_20_52_47,
    TEST_EXEC_2012_12_27_22_06_53,
    TEST_EXEC_2012_12_27_22_11_16,
    TEST_EXEC_2012_12_27_22_13_00,
    TEST_EXEC_2012_12_27_22_14_13,
    TEST_EXEC_2012_12_27_22_53_30,
    TEST_EXEC_2012_12_29_21_04_06,
    TEST_EXEC_2012_12_29_21_05_40,
    
    TEST_EXEC_2012_12_31_22_35_49,
    TEST_EXEC_2012_12_31_22_36_17,
    
    TEST_EXEC_2013_01_24_15_09_19,
    TEST_EXEC_2013_01_24_15_09_20,
    TEST_EXEC_2013_01_24_15_09_21,
    TEST_EXEC_2013_01_24_15_09_22,
    
    TEST_EXEC_CALLBACK_1,
    TEST_EXEC_CALLBACK_2,
    TEST_EXEC_CALLBACK_TO_PARENT,
    TEST_EXEC_CALLBACK_BY_CHILD_MULTITIMES,
    TEST_EXEC_CALLBACK_WITH_DELAY,
    TEST_EXEC_2012_12_30_0_55_42,
    
} testEnums;


/**
 class for exec-test
 */
#define TEST_CLASS_A    (@"TEST_CLASS_A")

typedef enum {
    TEST_EXEC_A_FROMA = 0,
    TEST_EXEC_A_FROMOTHER,
} classAEnum;

@interface ClassA : NSObject {
    KSMessenger * messenger;
}
@end

@implementation ClassA
- (id) initClassA {
    if (self = [super init]) {
        messenger = [[KSMessenger alloc]initWithBodyID:self withSelector:@selector(receiver:) withName:TEST_CLASS_A];
    }
    return self;
}


- (void) receiver:(NSNotification * )notif {
    switch ([messenger execFrom:TEST_CHILD_NAME_0 viaNotification:notif]) {
        case TEST_EXEC_2012_12_31_22_35_49:{
            NSLog(@"reached");
            break;
        }
            
        //if TEST_CHILD_NAME_1 call this messenger, must not be reached.
        case TEST_EXEC_2012_12_31_22_36_17:{
            NSAssert(false, @"not reachable");
            break;
        }
        
        default:
            break;
    }
}

@end

/**
 class for callback-test
 */

//callback
#define TEST_CLASS_B                (@"TEST_CLASS_B")
#define TEST_CLASS_B_AS_PARENT      (@"TEST_CLASS_B_AS_PARENT")
#define TEST_CLASS_B_AS_PARENT_2    (@"TEST_CLASS_B_AS_PARENT_2")
#define TEST_CLASS_B_AS_CHILD       (@"TEST_CLASS_B_AS_CHILD")

#define TEST_RET_RESULT             (@"TEST_RET_RESULT")

#define TEST_TAG_CALLBACK_0         (@"TEST_TAG_CALLBACK_0")
#define TEST_VALUE_CALLBACK_0       (@"TEST_VALUE_CALLBACK_0")

#define TEST_TAG_CALLBACK_1         (@"TEST_TAG_CALLBACK_1")
#define TEST_VALUE_CALLBACK_1       (@"TEST_VALUE_CALLBACK_1")

#define TEST_TAG_CALLBACK_2         (@"TEST_TAG_CALLBACK_2")
#define TEST_VALUE_CALLBACK_2       (@"TEST_VALUE_CALLBACK_2")

#define TEST_TAG_CALLBACK_RECURSIVE     (@"TEST_TAG_CALLBACK_RECURSIVE")
#define TEST_TAG_2012_12_30_0_56_04     (@"TEST_TAG_2012_12_30_0_56_04")

typedef enum {
    TEST_EXEC_CALLBACK = 0
} callbackEnum;

@interface ClassB : NSObject {
    KSMessenger * messenger;
}

- (id) initClassB;
- (id) initClassBAsParent;
- (id) initClassBAsParent2;

- (NSString * )mId;
- (KSMessenger * )messenger;

@end


@implementation ClassB

- (id) initClassB {
    if (self = [super init]) {
        messenger = [[KSMessenger alloc]initWithBodyID:self withSelector:@selector(bReceiver:) withName:TEST_CLASS_B];
        [messenger connectParent:TEST_PARENT_NAME];
    }
    return self;
}

- (id) initClassBAsParent {
    if (self = [super init]) {
        messenger = [[KSMessenger alloc]initWithBodyID:self withSelector:@selector(bReceiver:) withName:TEST_CLASS_B_AS_PARENT];
    }
    return self;
}

- (id) initClassBAsParent2 {
    if (self = [super init]) {
        messenger = [[KSMessenger alloc]initWithBodyID:self withSelector:@selector(bReceiver:) withName:TEST_CLASS_B_AS_PARENT_2];
    }
    return self;
}

- (id) initClassBWithReceiver:(SEL)rec {
    if (self = [super init]) {
        messenger = [[KSMessenger alloc]initWithBodyID:self withSelector:rec withName:TEST_CLASS_B_AS_CHILD];
    }
    return self;
}

- (void) bReceiver:(NSNotification * ) notif {
    switch ([messenger execFrom:TEST_PARENT_NAME viaNotification:notif]) {
 
        //返す相手が親のケース
        case TEST_EXEC_CALLBACK:{
            [messenger callback:notif,
             [messenger tag:TEST_TAG_CALLBACK_0 val:TEST_VALUE_CALLBACK_0],
             [messenger tag:@"id" val:[messenger myMID]],
             nil];
            break;
        }
            
        //返す相手が親のケース specifiedIdで送られてきたもの
        case TEST_EXEC_CALLBACK_1:{
            
            [messenger callback:notif,
             [messenger tag:TEST_TAG_CALLBACK_1 val:TEST_VALUE_CALLBACK_1],
             nil];
            break;
        }
            
        //返す相手が子供のケース
        case TEST_EXEC_CALLBACK_2:{
            [messenger callback:notif,
             [messenger tag:TEST_TAG_CALLBACK_2 val:TEST_VALUE_CALLBACK_2],
             nil];
            
            break;
        }
            
        //
        case TEST_EXEC_CALLBACK_BY_CHILD_MULTITIMES:{
            [messenger callback:notif,
             [messenger tag:@"tag1" val:@"val1"],
             nil];
            
            [messenger callback:notif,
             [messenger tag:@"tag2" val:@"val2"],
             nil];
            
            [messenger callback:notif,
             [messenger tag:@"tag3" val:@"val3"],
             nil];
            
            break;
        }
            
        case TEST_EXEC_CALLBACK_WITH_DELAY:{
            [messenger callback:notif,
             [messenger tag:@"tag1" val:@"val1"],
             nil];
            
            break;
        }
            
        default:
            break;
    }
}

- (void) callbackReceiver:(NSNotification * )notif {
    switch ([messenger execFrom:TEST_CLASS_B_AS_PARENT_2 viaNotification:notif]) {
        case TEST_EXEC_2012_12_30_0_55_42:{
            [messenger callback:notif,
             [messenger tag:TEST_TAG_2012_12_30_0_56_04 val:@"something"],
             nil];
            break;
        }
        default:
            break;
    }
}


- (NSString * )mId {
    return [messenger myMID];
}

- (KSMessenger * )messenger {
    return messenger;
}

@end



@implementation KSMessengerTests

KSMessenger * parent;
KSMessenger * child_persis;

- (void) setUp {
    [super setUp];
    
	parent = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(parentReceiver:) withName:TEST_PARENT_NAME];
	child_persis = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(child_persisReceiver:) withName:TEST_CHILDPERSIS_NAME];
    
}

- (void) tearDown {
    NSLog(@"teardown over");
    [super tearDown];
}




/*
 initialize -have name
 */
- (void) testMessengerName {
	STAssertEquals([parent myName],TEST_PARENT_NAME, @"自分で設定した名前がこの時点で異なる！");
}


/**
 messenger -dealloc
 */
- (void) testDealloc {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	
	[child_0 connectParent:TEST_PARENT_NAME];
	[child_0 removeFromParent];
}



//generate log

/**
 log -create
 */
- (void) testCreateLog {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	
	//ログファイルがもくろみ通り作成されているかのテスト
	[child_0 connectParent:TEST_PARENT_NAME];
	
	//この時点で、子供は親へと宣言を送った、さらに親がそれを受け止めて返した、というログを持っているはず。
	NSDictionary * m_logDict = [child_0 logStore];
	
	STAssertTrue([m_logDict count] == 2, [NSString stringWithFormat:@"内容が合致しません_%d", [m_logDict count]]);
}


//generate tag-value

/**
 tagValue -tag:val:
 */
- (void) testTagValue {
    NSDictionary * tagValueDict = [parent tag:@"theTag" val:@"theValue"];
    STAssertTrue([[[tagValueDict keyEnumerator] nextObject] isEqualToString:@"theTag"], @"theTag required");
}

/**
 tagValue -val:tag:
 */
- (void) testValueTag {
    NSDictionary * tagValueDict = [parent val:@"theValue" tag:@"theTag"];
    STAssertTrue([[[tagValueDict keyEnumerator] nextObject] isEqualToString:@"theTag"], @"theTag required");
}

/**
 tagValue -addDict:
 */
- (void) testAddTagValues {
    NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"theValue", @"theTag", nil];
    NSDictionary * tagValueDict = [parent addTagValues:dict];
    STAssertTrue([[[tagValueDict keyEnumerator] nextObject] isEqualToString:@"theTag"], @"theTag required");
}

/**
 tagValue -addTagValues: multi
 */
- (void) testAddTagValuesMulti {
    NSDictionary * dict = [[NSDictionary alloc]initWithObjectsAndKeys:
                           @"val1", @"tag1",
                           @"val2", @"tag2",
                           nil];
    
    NSDictionary * tagValueDict = [parent addTagValues:dict];
    STAssertTrue([tagValueDict count] == 2, @"not match");
}

- (void) testTagValueKitchenSink {
    [child_persis connectParent:TEST_PARENT_NAME];
    
    //tag-val
    [parent call:TEST_CHILDPERSIS_NAME withExec:TEST_EXEC_2013_01_24_15_09_19,
     [parent tag:@"2013/01/24 15:11:10" val:@"2013/01/24 15:11:12"],
     nil];
    
    
    //val-tag
    [parent call:TEST_CHILDPERSIS_NAME withExec:TEST_EXEC_2013_01_24_15_09_20,
     [parent val:@"2013/01/24 15:11:51" tag:@"2013/01/24 15:11:53"],
     nil];
    
    
    //addTagValues
    NSDictionary * dict1 = [[NSDictionary alloc]initWithObjectsAndKeys:
                           @"2013/01/24 15:12:20", @"2013/01/24 15:12:24",
                           @"2013/01/24 15:12:35", @"2013/01/24 15:12:45",
                           nil];
    [parent call:TEST_CHILDPERSIS_NAME withExec:TEST_EXEC_2013_01_24_15_09_21,
     [parent addTagValues:dict1],
     nil];
    
    
    //mix
    NSDictionary * dict2 = [[NSDictionary alloc]initWithObjectsAndKeys:
                            @"2013/01/24 15:14:16", @"2013/01/24 15:14:18",
                            @"2013/01/24 15:14:23", @"2013/01/24 15:14:26",
                            nil];
    [parent call:TEST_CHILDPERSIS_NAME withExec:TEST_EXEC_2013_01_24_15_09_22,
     [parent tag:@"2013/01/24 15:13:38" val:@"2013/01/24 15:13:40"],
     [parent val:@"2013/01/24 15:13:47" tag:@"2013/01/24 15:13:52"],
     [parent addTagValues:dict2],
     nil];
    
}


//generate exec

/**
 exec -check "exec" param from parent to child through messaging
 */
- (void) testExecFrom {
    [child_persis connectParent:TEST_PARENT_NAME];
    
    NSDictionary * childDict = [child_persis logStore];
    int childBefore = [childDict count];
    
    NSDictionary * parentDict = [parent logStore];
    int parentBefore = [parentDict count];
    
    
    [parent call:[child_persis myName] withExec:TEST_EXEC_2012_12_29_21_04_06, nil];
    //child called from parent, then call parent +2
    STAssertTrue([childDict count] == childBefore +2, @"not match, %d", [childDict count]);

    //parent call child, then received message from child
    STAssertTrue([parentDict count] == parentBefore +2, @"not match, %d", [parentDict count]);
}

/**
 exec -forbid that sending "exec = -1" param
 */
- (void) testExecSendingForbiddenParam {
    [child_persis connectParent:TEST_PARENT_NAME];
    
    //error will occur, by input TEST_FORBIDDEN_EXEC_PARAM as Exec.
    @try {
       [parent call:[child_persis myName] withExec:TEST_FORBIDDEN_EXEC_PARAM, nil];
        STFail(@"error must occured, because TEST_FORBIDDEN_EXEC_PARAM = -1 is forbidden for send as exec. the system uses it as NONE");
    }
    @catch (NSException * exception) {
        NSLog(@"success this test. %@", exception);
    }
    @finally {}
}

/**
 exec -forbid that receiving "exec = -1" param
 */
- (void) testExecReceivingForbiddenParam {
    //connect parent
    [child_persis connectParent:TEST_PARENT_NAME];
    
    //generate fake notification as "parent call:child_persis withExec:"
    NSNotification * notif = [NSNotification
                              notificationWithName:OBSERVER_ID
                              object:nil
                              userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                        @"MESSENGER_SYSTEM_COMMAND:CATEGOLY_CALL_CHILD", @"MESSENGER_SYSTEM_COMMAND",
                                        [child_persis myName], @"MESSENGER_SYSTEM_COMMAND:ADDRESS_NAME",
                                        [NSString stringWithFormat:@"%@%d", [parent myName], TEST_FORBIDDEN_EXEC_PARAM], @"MESSENGER_SYSTEM_COMMAND:EXECUTE",
                                        [NSDictionary dictionary],@"MESSENGER_SYSTEM_COMMAND:LOG",
                                        [parent myMID], @"MESSENGER_SYSTEM_COMMAND:LOGGED_SENDER_MID",
                                        [parent myName], @"MESSENGER_SYSTEM_COMMAND:LOGGED_SENDER_NAME",
                                        nil]];
    
    //evaluate fake-notification, error will occur, by input TEST_FORBIDDEN_EXEC_PARAM as Exec.
    @try {
        [child_persis execFrom:[parent myName] viaNotification:notif];
        STFail(@"error must be occured, because TEST_FORBIDDEN_EXEC_PARAM = -1 is forbidden for receive as exec. the system uses it as NONE");
    }
    @catch (NSException * exception) {
        NSLog(@"success this test. %@", exception);
    }
    @finally {}
}

/**
 exec -receive only specific exec as not NONE
    use relationship and exec-identification-information
 */
- (void) testExecReceivedSpecificFilter {
    ClassA * classA = [[ClassA alloc]initClassA];
    NSLog(@"classA %@", classA);
    
    KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(receiver:) withName:TEST_CHILD_NAME_0];
    [child_0 connectParent:TEST_CLASS_A];
    
    KSMessenger * child_1 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(receiver:) withName:TEST_CHILD_NAME_1];
    [child_1 connectParent:TEST_CLASS_A];
    
    
    //sender must match execFrom-filter
    
    //will reach
    [child_0 callParent:TEST_EXEC_2012_12_31_22_35_49, nil];
    
    //will not reach
    [child_1 callParent:TEST_EXEC_2012_12_31_22_36_17, nil];
}



//call
//      from myself to myself
//      from child to parent
//      from parent to child

/**
 call -myself
 */
- (void) testCallMyself {
	
	[parent callMyself:TEST_EXEC_CALLMYSELF,nil];
	
	//送信記録と受信記録が残る筈。
	NSDictionary * m_logDict = [parent logStore];
	//自分自身への通信なので、送信と受信が一件ずつ残る筈
	
	STAssertTrue([m_logDict count] == 2, @"発信記録、受信記録が含まれていない");
}

/**
 call -parent to not child
 */
- (void) testCallToNotChild {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	
	[child_0 connectParent:TEST_PARENT_NAME];//発信、親認定で+2件
	
	
	NSDictionary * parentLogDict = [parent logStore];//親の辞書には、子供Aからの通信で1件、存在しない子供Bへの最初の書き込みで0件 1
	STAssertTrue([parentLogDict count] == 1, [NSString stringWithFormat:@"testCallToNotChild_親の内容1_内容が合致しません_%d", [parentLogDict count]]);
}

/**
 call -parent from child
 */
- (void) testCallParent {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	
	[child_0 connectParent:TEST_PARENT_NAME];//2件
	NSDictionary * child_0Dict = [child_0 logStore];
	
	STAssertTrue([child_0Dict count] == 2, [NSString stringWithFormat:@"子の内容2_内容が合致しません_%d", [child_0Dict count]]);
	
	
	[parent call:TEST_CHILD_NAME_0 withExec:TEST_EXEC, nil];//子供からの受信ログ +1 親からの送信ログ +1 2件
	NSDictionary * parentDict = [parent logStore];
	STAssertTrue([parentDict count] == 2, [NSString stringWithFormat:@"親の内容2_内容が合致しません_%d", [parentDict count]]);
	STAssertTrue([child_0Dict count] == 3, [NSString stringWithFormat:@"子の内容3_内容が合致しません_%d", [child_0Dict count]]);
	
	
	[child_0 callParent:TEST_EXEC_1, nil];//作成+1 送信+1 4件
	
	STAssertTrue([child_0Dict count] == 4, [NSString stringWithFormat:@"子の内容4_内容が合致しません_%d", [child_0Dict count]]);
	
	KSMessenger * child_1 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild1:) withName:TEST_CHILD_NAME_0];
	//無関係な子供への登録件数は0件な筈
	NSDictionary * child_1Dict = [child_1 logStore];
	STAssertTrue([child_1Dict count] == 0, [NSString stringWithFormat:@"子の内容0_内容が合致しません_%d", [child_1Dict count]]);
	
	KSMessenger * parent2 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testParent:) withName:TEST_PARENT_NAME];
	//無関係な親への登録件数は0件な筈
	NSDictionary * parentDict1 = [parent2 logStore];
	STAssertTrue([parentDict1 count] == 0, [NSString stringWithFormat:@"親2の内容0_内容が合致しません_%d", [parentDict1 count]]);
	
	
	//親には子供からのメッセージが届いている筈+1 3件
	STAssertTrue([parentDict count] == 3, [NSString stringWithFormat:@"親の内容3_内容が合致しません_%d", [parentDict count]]);
}

/**
 call -child from child
 */
- (void) testCallToChild {
	
	[child_persis connectParent:TEST_PARENT_NAME];//発信、親認定で+2件
	
	NSDictionary * m_logDict = [child_persis logStore];
	STAssertTrue([m_logDict count] == 2, [NSString stringWithFormat:@"子供認定2 内容が合致しません_%d", [m_logDict count]]);
	
	
	NSDictionary * parentLogDict = [parent logStore];//親の辞書 子供からの親設定を受信、受付+1 1件
	STAssertTrue([parentLogDict count] == 1, [NSString stringWithFormat:@"親の辞書、内容が合致しません_%d", [parentLogDict count]]);
	
	KSMessenger * parent2 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testParent:) withName:TEST_PARENT_NAME];
	
	NSDictionary * parentLogDict2 = [parent2 logStore];//親の辞書
	STAssertTrue([parentLogDict2 count] == 0, [NSString stringWithFormat:@"親2の辞書、内容が合致しません_%d", [parentLogDict2 count]]);
	
	
	
	[parent call:[child_persis myName] withExec:TEST_EXEC, nil];//親からの送信で+1 ２件
	STAssertTrue([parentLogDict count] == 2, [NSString stringWithFormat:@"親の辞書、内容が合致しません_%d", [parentLogDict count]]);
	
	
	//子供の受け取り確認 受け取り+1 3件
	STAssertTrue([m_logDict count] == 3, [NSString stringWithFormat:@"親から子への送信3 内容が合致しません_%d", [m_logDict count]]);
	
	
	
	[parent call:[child_persis myName] withExec:TEST_EXEC_2, nil];//親の送信で+1 子供からの返信で+1 4件
	
	//子供の受け取りログ+1、発信ログ+1 5件
	STAssertTrue([m_logDict count] == 5, [NSString stringWithFormat:@"子供5 内容が合致しません_%d", [m_logDict count]]);
	
	
	
	NSLog(@"parentLogDict_%@", parentLogDict);
	STAssertTrue([parentLogDict count] == 4, [NSString stringWithFormat:@"親の辞書4、内容が合致しません_%d", [parentLogDict count]]);
	
	KSMessenger * child_1 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild1:) withName:TEST_CHILD_NAME_0];
	
	NSDictionary * child1Dict_1 = [child_1 logStore];//親登録していない子供は、受け取ってはいけないので、0件
	STAssertTrue([child1Dict_1 count] == 0, [NSString stringWithFormat:@"child1Dict_1_内容が合致しません_%d", [child1Dict_1 count]]);
	
	
	STAssertTrue([m_logDict count] == 5, [NSString stringWithFormat:@"親から子への送信5_内容が合致しません_%d", [m_logDict count]]);
}








//relationship  -generate relationship from child-candidate to parent-candidate, then connect them.
/**
 connect to parent
 */
- (void) testInputToParent {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	
	[child_0 connectParent:TEST_PARENT_NAME];
	STAssertEquals([child_0 myParentMID], [parent myMID], [NSString stringWithFormat:@"親のIDが想定と違う/child_0_%@, parent_%@", [child_0 myParentMID], [parent myMID]]);
}

/*
 connect to parent -check parent name of child
 */
- (void) testGetParentName {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	
	[child_0 connectParent:TEST_PARENT_NAME];
	STAssertEquals([child_0 myParentName], TEST_PARENT_NAME, @"親の名前が想定と違う");
	
	STAssertTrue([child_0 hasParent], @"親がセットされている筈なのに判定がおかしい");//child_0には親がセットされている筈
}

/**
 connect to parent -check parent logDict
 */
- (void) testGetChildDict {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	
	[child_0 connectParent:TEST_PARENT_NAME];
	
	NSMutableDictionary * dict = [parent childrenDict];
	STAssertEquals([dict valueForKey:[child_0 myMID]], [child_0 myName], [NSString stringWithFormat:@"多分なにやらまちがえたんかも_%@", dict]);
}

/**
 connect to parent -remove child
 */
- (void) testRemoveChild {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	
	[child_0 connectParent:TEST_PARENT_NAME];
	STAssertTrue([[child_0 myParentMID] isEqualToString:[parent myMID]], [NSString stringWithFormat:@"親のIDが想定と違う/child_0_%@, parent_%@", [child_0 myParentMID], [parent myMID]]);
	
	[parent removeAllChildren];
	
	STAssertTrue([[child_0 myParentMID] isEqualToString:MS_DEFAULT_PARENTMID], [NSString stringWithFormat:@"親のIDが想定と違う/child_0_%@, parent_%@", [child_0 myParentMID], [parent myMID]]);
}

/**
 connect to parent -same name some child
 */
- (void) testConnectParentWithSameNameChild {
	KSMessenger * child_00 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	KSMessenger * child_01 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	KSMessenger * child_02 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	KSMessenger * child_03 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	KSMessenger * child_04 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	
	
	[child_00 connectParent:[parent myName]];
	[child_01 connectParent:[parent myName]];
	[child_02 connectParent:[parent myName]];
	[child_03 connectParent:[parent myName]];
	[child_04 connectParent:[parent myName]];
	
	STAssertTrue([parent hasChild], @"子供がいない事になってる");
	STAssertTrue([[parent childrenDict] count] == 5, @"子供が足りない");
	
    NSDictionary * dict1 = [child_01 logStore];
    NSDictionary * dict2 = [child_02 logStore];
    NSDictionary * dict3 = [child_03 logStore];
    NSDictionary * dict4 = [child_04 logStore];
    
	[child_00 removeFromParent];
	
	
	//親から子供にコールすると、解消された物以外の全員に届く筈
	[parent call:[child_00 myName] withExec:TEST_PARENT_MULTICHILD,nil];

    STAssertTrue([dict1 count] == 3, @"not match %d", [dict1 count]);
    STAssertTrue([dict2 count] == 3, @"not match %d", [dict2 count]);
    STAssertTrue([dict3 count] == 3, @"not match %d", [dict3 count]);
    STAssertTrue([dict4 count] == 3, @"not match %d", [dict4 count]);
}

/**
 connect to parent -then release some children
 */
- (void) testConnectParent_multiChild_multiRelease {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	
	KSMessenger * child_2 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild2:) withName:TEST_CHILD_NAME_2];
	KSMessenger * child_3 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild3:) withName:TEST_CHILD_NAME_3];
	
	[child_0 connectParent:TEST_PARENT_NAME];//発信、親認定で+2件
	[child_2 connectParent:TEST_PARENT_NAME];//発信、親認定で+2件
	[child_3 connectParent:TEST_PARENT_NAME];//発信、親認定で+2件
	
	[parent call:TEST_CHILD_NAME_0 withExec:TEST_EXEC, nil];
	[parent call:TEST_CHILD_NAME_2 withExec:TEST_EXEC, nil];
	[parent call:TEST_CHILD_NAME_3 withExec:TEST_EXEC, nil];
}

/**
 connect to parent -remove from parent then re input to other parent
 */
- (void) testResetParent {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	KSMessenger * child_2 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild2:) withName:TEST_CHILD_NAME_2];
	
	
	
	[child_0 connectParent:[parent myName]];
	
	NSMutableDictionary * parentChildrenDict = [parent childrenDict];
	STAssertTrue([parentChildrenDict count] == 1, [NSString stringWithFormat:@"親の持っている子供辞書が1件になっていない_%d", [parentChildrenDict count]]);
	
	NSLog(@"child_0の親を抹消");
	[child_0 removeFromParent];//親情報をリセットする
	NSLog(@"child_0の親抹消済みの筈_親ID_%@", [child_0 myParentMID]);
	
	//parentの子供辞書を調べてみる、一件も無くなっている筈
	STAssertTrue([parentChildrenDict count] == 0, [NSString stringWithFormat:@"親の持っている子供辞書が0件になっていない_%d", [parentChildrenDict count]]);
	STAssertTrue(![child_0 hasParent], @"子供がまだ親情報を持っている");
	STAssertTrue(![parent hasChild], @"親がまだ子供情報を持っている");
	
	
	
	[child_0 connectParent:[child_2 myName]];//新規親情報
	
	
	
	
	STAssertTrue([child_0 hasParent], @"子供がまだ親情報を持っている");
	STAssertTrue(![parent hasChild], @"親がまだ子供情報を持っている");
	
	NSLog(@"child_0_Parent_%@ = %@", [child_0 myParentMID], [child_2 myMID]);
	NSLog(@"child_2_Child_%@ = %@", [child_2 childrenDict], [child_0 myMID]);
	
	STAssertTrue([child_2 hasChild], @"子供2が子供情報を持っていない");
	
	
	NSMutableDictionary * dict2 = [child_2 childrenDict];
	STAssertTrue([dict2 count] == 1, [NSString stringWithFormat:@"dict2の持っている子供辞書が1件になっていない_%d", [dict2 count]]);
	
	NSLog(@"dict2_%@", dict2);
	STAssertTrue([[dict2 valueForKey:[child_0 myMID]] isEqualToString:[child_0 myName]], @"child_2の親登録が違った");
}








//multi depth case

/**
 samename parentable messenger, choose and input parent by specific parent with specific MID
 */
- (void) testInputParentWithSpecifiedMID {
	KSMessenger * mes1 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"テスト１"];
	KSMessenger * mes2 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"テスト２"];
	KSMessenger * mes3 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"テスト２"];
	
	[mes1 connectParent:[mes2 myName] withSpecifiedMID:[mes2 myMID]];
	
	STAssertTrue([mes1 hasParent], @"親が存在している筈なのに、存在していない");
	STAssertTrue([[mes1 myParentMID] isEqualToString:[mes2 myMID]], @"親想定MIDが一致しない");
	
	STAssertTrue([mes2 hasChild], @"子供が存在する筈なのに、存在していない");
	
	STAssertTrue(![mes3 hasChild], @"子供が存在しない筈なのに、存在している");
}

/**
 samename child messenger, choose and send message to specific child with specific MID
 */
- (void) testCallChildWithSpecifiedMID {
	KSMessenger * mes1 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"テスト１"];
	KSMessenger * mes2 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"テスト１"];
	
	[mes1 connectParent:[parent myName]];
	[mes2 connectParent:[parent myName]];
	
	
	//一人にだけ届くメッセージを送ってみる
	[parent call:[mes1 myName] withSpecifiedMID:[mes1 myMID] withExec:TEST_EXEC_2012_12_27_20_23_44, nil];
	
	NSMutableDictionary * mes1Log = [mes1 logStore];
	STAssertTrue([mes1Log count] == 3, @"ログ件数が合致しない_%d", [mes1Log count]);
	
	
	
	
	//２人に届くメッセージを送ってみる
	[parent call:[mes1 myName] withExec:TEST_EXEC_2012_12_27_20_24_04, nil];
	
	
	STAssertTrue([mes1Log count] == 4, @"ログ件数が合致しない_%d", [mes1Log count]);
	
	NSMutableDictionary * mes2Log = [mes2 logStore];
	STAssertTrue([mes2Log count] == 3, @"ログ件数が合致しない_%d", [mes2Log count]);
}

/**
 親が複数いるケース
 */
- (void) testMultiParent {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	
	[child_0 connectParent:TEST_PARENT_NAME];//2件
	KSMessenger * parent2 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testParent:) withName:TEST_PARENT_NAME];
	
	
	NSDictionary * parentDict_0 = [parent logStore];
	NSDictionary * parentDict_1 = [parent2 logStore];//子供辞書が完成していない筈
	
	NSLog(@"parentDict_0_%@", parentDict_0);//真っ先に親に指定されている筈 +1 1件
	STAssertTrue([parentDict_0 count] == 1, @"親として認定");
	
 	NSLog(@"parentDict_1_%@", parentDict_1);//同名で先に設定されている親が既に居るので、無視されてしかるべき 0件
	STAssertTrue([parentDict_1 count] == 0, @"親として認定されてしまっている？");
}

/**
 二人目の子供
 2つのキャパシティがあり、それぞれキーがMID、バリューとして名前が各自のもの、という状態で入っているはず。
 */
- (void) testAddChild {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	KSMessenger * child_2 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild2:) withName:TEST_CHILD_NAME_2];
	
	[child_0 connectParent:TEST_PARENT_NAME];
	[child_2 connectParent:TEST_PARENT_NAME];
	
	
	NSMutableDictionary * dict = [parent childrenDict];//親の辞書をチェックする
	
	STAssertEquals([dict valueForKey:[child_0 myMID]], [child_0 myName], @"child_0の親登録が違った");
	STAssertEquals([dict valueForKey:[child_2 myMID]], [child_2 myName], @"child_2の親登録が違った");
}

/**
 一人目の子供の子供
 */
- (void) testChild_s_child {
	KSMessenger * child_2 = [[KSMessenger alloc]initWithBodyID:self withSelector:@selector(m_testChild2:) withName:TEST_CHILD_NAME_2];
	
	
	[child_persis connectParent:TEST_PARENT_NAME];
	
	[child_2 connectParent:[child_persis myName]];
	
	//child_0の子供としてchild_2をセットした際、child_0の名前がchild_2のmyParentにセットしてあるはず。
	NSMutableDictionary * dict1 = [child_persis childrenDict];
	STAssertTrue([[dict1 valueForKey:[child_2 myMID]] isEqualToString:[child_2 myName]], @"child_2の親登録が違った");
}

/**
 一人目の子供に同名の複数の子供
 */
- (void) testChild_s_child_sameName {
	KSMessenger * child_2 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild2:) withName:TEST_CHILD_NAME_2];
	KSMessenger * child_3 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild2:) withName:TEST_CHILD_NAME_2];
	
	
	[child_persis connectParent:TEST_PARENT_NAME];
	
	[child_2 connectParent:[child_persis myName]];
	[child_3 connectParent:[child_persis myName]];
	
	//child_0の子供としてchild_2をセットした際、child_0の名前がchild_2のmyParentにセットしてあるはず。
	NSMutableDictionary * dict1 = [child_persis childrenDict];
	STAssertTrue([[dict1 valueForKey:[child_2 myMID]] isEqualToString:[child_2 myName]], @"child_2の親登録が違った");
}

/**
 複数の子供を設定し、順に削除する
 */
- (void) testMultiChild {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
	KSMessenger * child_2 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild2:) withName:TEST_CHILD_NAME_2];
	
	[child_0 connectParent:[parent myName]];
	[child_2 connectParent:[parent myName]];
	
	
	[child_0 removeFromParent];//親情報をリセットする
	//親には子供がいる　_2
	//子供２には親がいる
	STAssertTrue(![child_0 hasParent], @"親設定があります_0");
	STAssertTrue([child_2 hasParent], @"親設定がありません_2");
	STAssertTrue([parent hasChild], @"子供がいません");
	
	[child_2 removeFromParent];//親情報をリセットする
	//親には子供がいない
	//子供２には親がいない
	STAssertTrue(![child_0 hasParent], @"親設定があります_0　その２");
	STAssertTrue(![child_2 hasParent], @"親設定があります_2　その２");
	STAssertTrue(![parent hasChild], @"子供がいます　その２");
}







//delay

/**
 send with delay
 */
- (void) testCallWithDelay {
	
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_NAME_2012_12_27_20_51_04];
	
	NSMutableDictionary * logD = [child_0 logStore];
	
	[child_0 callMyself:TEST_EXEC_2012_12_27_20_25_46,
	 [child_0 withDelay:0.3],
	 nil];
	
	STAssertTrue([logD count] == 1, @"送信できてない1");
	//ログのカウントが２になったら終了
	
	while ([logD count] != 2) {
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
	}
	
	
	NSLog(@"無事に非同期で抜けた");
	
	STAssertTrue([logD count] == 2, @"送信できてない2");
}

/**
 send with delay -child call parent then parent kill relationship bewtween children before the delay-message reachs, will not error
 */
- (void) testDelayCallFromChildToParent_Death {
	
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_NAME_2012_12_27_20_51_04];
	[child_0 connectParent:[parent myName]];
	
	
	NSMutableDictionary * logD = [child_0 logStore];
	
	[child_0 callParent:TEST_EXEC_2012_12_27_20_26_22,
	 [child_0 withDelay:0.3],
	 nil];
	
	[child_0 callMyself:TEST_EXEC_2012_12_27_20_26_32,
	 [child_0 withDelay:0.3],
	 nil];
	
	
	STAssertTrue([logD count] == 4, @"not match, %d", [logD count]);
	
    //parent remove children
    [parent removeAllChildren];
    
    //wait 1sec
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    
    //send was done, nothing happen.
    STAssertTrue([logD count] == 6, @"not match, %d", [logD count]);
}

/**
 send with delay -child call parent then parent remove childs before the message reachs not fail
 */
- (void) testDelayCallFromChildToParent_Removed {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_NAME_2012_12_27_20_51_04];
	[child_0 connectParent:[parent myName]];
	
	NSMutableDictionary * logDP = [parent logStore];
	STAssertTrue([logDP count] == 1, @"親のログ件数が増えている、受け取ってしまっている1？_%d", [logDP count]);
	
	
	
	NSMutableDictionary * logD = [child_0 logStore];
	
	[child_0 callParent:TEST_EXEC_2012_12_27_20_49_31,
	 [child_0 withDelay:0.3],
	 nil];
	
	
	[child_0 callMyself:TEST_EXEC_2012_12_27_20_49_56,
	 [child_0 withDelay:0.3],
	 nil];
	
	[parent removeAllChildren];
	
	STAssertTrue([logDP count] == 2, @"親のログ件数が増えている、受け取ってしまっている3？_%d", [logDP count]);
	NSLog(@"logDP_before_%@", logDP);
	
	
	STAssertTrue([logD count] == 5, @"送信できてない1");
	
	while ([logD count] != 6) {//受け取りはするんだけれど、何もしない、というのを観測したい。。。 ここでは、子供が親への送信直後に自分で自分宛に送った物を受け取ったとする。
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
	}
	NSLog(@"logDP_after_%@", logDP);
	STAssertTrue([logDP count] == 2, @"親のログ件数が増えている、受け取ってしまっている4？_%d", [logDP count]);
}

/**
 send with delay -parent call child then kill child before the message reachs not fail
 */
//- (void) testDelayCallFromParentToChild_Death {
//    STFail(@"このテスト、release無しで試さないといけない");
//	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_NAME_2012_12_27_20_51_04];
//	[child_0 inputParent:[parent myName]];
//	
//	
//	NSMutableDictionary * logD = [child_0 logStore];
//	NSMutableDictionary * logDP = [parent logStore];
//	
//	STAssertTrue([logD count] == 2, @"送信できてない0_%d", [logD count]);
//	
//	
//	[parent call:[child_0 myName] withExec:TEST_EXEC_2012_12_27_20_52_33,
//	 [parent withDelay:0.3],
//	 nil];
//	
//	[parent callMyself:TEST_EXEC_2012_12_27_20_52_47,//+2
//	 [child_0 withDelay:0.3],
//	 nil];
//	
//	STAssertTrue([logDP count] == 3, @"送信できてない1_%d", [logDP count]);
//	
//	STAssertTrue([logD count] == 2, @"送信できてない1_%d", [logD count]);
//		
//	STAssertTrue([logDP count] == 4, @"送信できてない1_%d", [logD count]);
//	
//	
//	while ([logDP count] != 5) {
//		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
//	}
//}

/**
 send with delay -parent call child then child removes from parent before the message reachs not fail
 */
- (void) testDelayCallFromParentToChild_Removed {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_NAME_2012_12_27_20_51_04];
	[child_0 connectParent:[parent myName]];
	
	NSMutableDictionary * logDP = [parent logStore];
	STAssertTrue([logDP count] == 1, @"親のログ件数が増えている、受け取ってしまっている1？_%d", [logDP count]);
	
	NSMutableDictionary * logD = [child_0 logStore];
	STAssertTrue([logD count] == 2, @"送信できてない1");
	
	
	[parent call:[child_0 myName] withExec:TEST_EXEC_2012_12_27_22_06_53,
	 [parent withDelay:0.3],
	 nil];
	
	
	[parent callMyself:TEST_EXEC_2012_12_27_22_06_53,
	 [parent withDelay:0.3],
	 nil];
	
	[child_0 removeFromParent];//ここで親から消える、送信記録１件
	
	STAssertTrue([logDP count] == 4, @"親のログ件数が増えている、受け取ってしまっている3？_%d", [logDP count]);
	STAssertTrue([logD count] == 3, @"送信できてない3_%d", [logD count]);
	
	
	while ([logDP count] != 5) {//受け取りはするんだけれど、何もしない、というのを観測したい。。。 ここでは、子供が親への送信直後に自分で自分宛に送った物を受け取ったとする。
		[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
	}
}

/**
 send with delay -parent call child then kill parentself before the message reachs not fail
 */
- (void) testDelayCallFromParentToChild_DeathBeforeReach {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_NAME_2012_12_27_20_51_04];
	[child_0 connectParent:[parent myName]];
	
	
	NSMutableDictionary * logD = [child_0 logStore];
	NSMutableDictionary * logDP = [parent logStore];
	
	STAssertTrue([logD count] == 2, @"送信できてない0_%d", [logD count]);
	
	
	[parent call:[child_0 myName] withExec:TEST_EXEC_2012_12_27_22_11_16,
	 [parent withDelay:0.3],
	 nil];
	
	[child_0 callMyself:TEST_EXEC_2012_12_27_22_11_16,//+2
	 [child_0 withDelay:0.3],
	 nil];
	
	
    //child remove from parent
    [child_0 removeFromParent];
	
	
    //wait 1sec
	[[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];

    STAssertTrue([logDP count] == 3, @"送信できてない1_%d", [logDP count]);
}

/**
 send with delay -parent call child then remove childs before the message reachs will be no error
 */
- (void) testDelayCallFromParentToChild_RemoveBeforeReach {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_NAME_2012_12_27_20_51_04];
	[child_0 connectParent:[parent myName]];
	
	NSMutableDictionary * logDP = [parent logStore];
	STAssertTrue([logDP count] == 1, @"親のログ件数が増えている、受け取ってしまっている1？_%d", [logDP count]);
	
	NSMutableDictionary * logD = [child_0 logStore];
	STAssertTrue([logD count] == 2, @"送信できてない1");
	
	
	[parent call:[child_0 myName] withExec:TEST_EXEC_2012_12_27_22_13_00,
	 [parent withDelay:0.3],
	 nil];
	
	
	[parent callMyself:TEST_EXEC_2012_12_27_22_13_00,
	 [parent withDelay:0.3],
	 nil];
	
	[parent removeAllChildren];
	
    //wait 1sec
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    
	
	STAssertTrue([logD count] == 3, @"not match, %d", [logD count]);
}

/**
 send with delay -then kill sender himself
 */
- (void) testDelayCallFromChildToHimself_Death {
	KSMessenger * child_0 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_NAME_2012_12_27_20_51_04];
	
	[child_0 connectParent:[parent myName]];
    
	NSMutableDictionary * logDP = [parent logStore];
    

    STAssertTrue([logDP count] == 1, @"not match, %d", [logDP count]);
	
	[child_0 callMyself:TEST_EXEC_2012_12_27_22_14_13,
	 [child_0 withDelay:0.3],
	 nil];
	
	
	[child_0 callParent:TEST_EXEC_2012_12_27_22_14_13,
	 [child_0 withDelay:0.3],
	 nil];
	
    STAssertTrue([logDP count] == 1, @"not match, %d", [logDP count]);
	
    //remove
	[child_0 removeFromParent];
    
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    
    //parent received message from child.
    STAssertTrue([logDP count] == 2, @"not match, %d", [logDP count]);
}

/**
 send with delay -cancel by cancelPerform
 */
- (void) testDelayCallMyselfNeverError_useCancelPerform {
	KSMessenger * child_00 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"適当"];
    
	NSDictionary * logD = [child_00 logStore];
    
	[child_00 callMyself:TEST_EXEC_2012_12_27_22_53_30,
	 [child_00 withDelay:0.1],
	 nil];
    
	STAssertTrue([logD count] == 1, @"not match, %d", [logD count]);
    
    //cancel
    [child_00 cancelPerform];
	
    //wait 1sec
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    
    //never receive, because of cancelled
	STAssertTrue([logD count] == 1, @"not match, %d", [logD count]);
}


/**
 send with delay -cancel by closeConnection
 */
- (void) testDelayCallMyselfNeverError_useCloseConnection {
	KSMessenger * child_00 = [[KSMessenger alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"適当"];
    
	NSDictionary * logD = [child_00 logStore];
    
	[child_00 callMyself:TEST_EXEC_2012_12_27_22_53_30,
	 [child_00 withDelay:0.1],
	 nil];
    
	STAssertTrue([logD count] == 1, @"not match, %d", [logD count]);
    
    //closeConnection
    [child_00 closeConnection];
	
    //wait 1sec
    [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1.0]];
    
    //never receive, because of close
	STAssertTrue([logD count] == 1, @"not match, %d", [logD count]);
}







//callback -get responce immediately there.

/**
 callback -from child to parent
 */
- (void) testCallbackFromChildToParent {
    ClassB * b = [[ClassB alloc]initClassB];
    NSLog(@"b is %@", b);
    
    NSDictionary * currentCallbackDict = [parent call:TEST_CLASS_B withExec:TEST_EXEC_CALLBACK, nil];
    
    STAssertNotNil(currentCallbackDict, @"callbackParam is nil ", currentCallbackDict);
    NSLog(@"callback is   %@", currentCallbackDict);
    
    STAssertNotNil([currentCallbackDict valueForKey:TEST_TAG_CALLBACK_0], @"not contained. %@", currentCallbackDict);
    
    STAssertTrue([[currentCallbackDict valueForKey:TEST_TAG_CALLBACK_0] isEqualToString:TEST_VALUE_CALLBACK_0],
                 @"not match. %@", [currentCallbackDict valueForKey:TEST_TAG_CALLBACK_0]);
}

/**
 callback -from specified child to parent
 */
- (void) testCallbackFromChildToParentWithSpecifiedId {
    ClassB * b = [[ClassB alloc]initClassB];
    NSDictionary * currentCallbackDict = [parent call:TEST_CLASS_B withSpecifiedMID:[b mId] withExec:TEST_EXEC_CALLBACK_1, nil];
    
    STAssertNotNil(currentCallbackDict, @"callbackParam is nil ", currentCallbackDict);
    NSLog(@"callback is   %@", currentCallbackDict);
    
    STAssertNotNil([currentCallbackDict valueForKey:TEST_TAG_CALLBACK_1], @"not contained. %@", currentCallbackDict);
    
    STAssertTrue([[currentCallbackDict valueForKey:TEST_TAG_CALLBACK_1] isEqualToString:TEST_VALUE_CALLBACK_1],
                 @"not match. %@", [currentCallbackDict valueForKey:TEST_TAG_CALLBACK_1]);
}

/**
 callback -child send message to parent then parent callback to child
 */
- (void) testCallbackFromParentToChild {
    ClassB * b = [[ClassB alloc]initClassBAsParent];
    NSLog(@"b is %@", b);
    
    [parent connectParent:TEST_CLASS_B_AS_PARENT];
    
    NSDictionary * currentCallbackDict = [parent callParent:TEST_EXEC_CALLBACK_2, nil];
    
    STAssertNotNil(currentCallbackDict, @"callbackParam is nil ", currentCallbackDict);
    NSLog(@"callback is   %@", currentCallbackDict);
    
    STAssertNotNil([currentCallbackDict valueForKey:TEST_TAG_CALLBACK_2], @"not contained. %@", currentCallbackDict);
    
    STAssertTrue([[currentCallbackDict valueForKey:TEST_TAG_CALLBACK_2] isEqualToString:TEST_VALUE_CALLBACK_2],
                 @"not match. %@", [currentCallbackDict valueForKey:TEST_TAG_CALLBACK_2]);
}

/**
 callback -get value
 */
- (void) testCallbackGetValue {
    ClassB * b = [[ClassB alloc]initClassB];
    NSLog(@"b is %@", b);
    
    NSDictionary * currentCallbackDict = [parent call:TEST_CLASS_B withExec:TEST_EXEC_CALLBACK, nil];
    
    NSString * value = [currentCallbackDict valueForKey:TEST_TAG_CALLBACK_0];
    
    //evaluate
    @try {
        if ([value isEqualToString:@"something"]) {
            NSLog(@"has problem! must not be equal");
        }
        
        if ([value isEqualToString:TEST_TAG_CALLBACK_0]) {
            NSLog(@"match");
        }
    }
    @catch (NSException *exception) {
        STFail(@"error occured %@", exception);
    }
    @finally {}
    
    
    //shallow copy
    @try {
        NSString * str = [NSString stringWithString:value];
        NSLog(@"str %@", str);
    }
    @catch (NSException *exception) {
        STFail(@"error occured2 %@", exception);
    }
    @finally {}
    
    
    //deep copy
    @try {
        NSString * str2 = [[NSString alloc]initWithString:value];
        NSLog(@"str2    %@", str2);
    }
    @catch (NSException *exception) {
        STFail(@"error occured2 %@", exception);
    }
    @finally {}
}


/**
 callback -same messenger returns values multitimes.
 */
- (void) testCallbackMulti {
    ClassB * b = [[ClassB alloc]initClassB];
    NSLog(@"b is %@", b);
    
    //1
    NSDictionary * currentCallbackDict = [parent call:TEST_CLASS_B withExec:TEST_EXEC_CALLBACK, nil];
    STAssertTrue([[currentCallbackDict valueForKey:TEST_TAG_CALLBACK_0] isEqualToString:TEST_VALUE_CALLBACK_0],
                 @"not match. %@", [currentCallbackDict valueForKey:TEST_TAG_CALLBACK_0]);
    
    //2
    NSDictionary * currentCallbackDict_1 = [parent call:TEST_CLASS_B withExec:TEST_EXEC_CALLBACK_1, nil];
    STAssertTrue([[currentCallbackDict_1 valueForKey:TEST_TAG_CALLBACK_1] isEqualToString:TEST_VALUE_CALLBACK_1],
                 @"not match. %@", [currentCallbackDict_1 valueForKey:TEST_TAG_CALLBACK_1]);

    //3
    NSDictionary * currentCallbackDict_2 = [parent call:TEST_CLASS_B withExec:TEST_EXEC_CALLBACK, nil];
    STAssertTrue([[currentCallbackDict_2 valueForKey:TEST_TAG_CALLBACK_0] isEqualToString:TEST_VALUE_CALLBACK_0],
                 @"not match. %@", [currentCallbackDict_2 valueForKey:TEST_TAG_CALLBACK_0]);
}

/**
 callback -multi chidren will callback value, the last value is overridden by last callback.
 */
- (void) testCallbackFromMultiChild {
    //same name 2 children
    ClassB * b = [[ClassB alloc]initClassB];
    NSLog(@"b is %@", b);
    
    ClassB * b2 = [[ClassB alloc]initClassB];
    NSLog(@"b2 is %@", b2);
    
    /*
     1st "b" callback value,
     then
     2nd "b2" callback value.
     */
    NSDictionary * currentCallbackDict = [parent call:TEST_CLASS_B withExec:TEST_EXEC_CALLBACK, nil];
    
    //value is, from "b2". order is depends on the order of "connectParent" method.
    STAssertTrue([[currentCallbackDict valueForKey:@"id"] isEqualToString:[b2 mId]], @"not match,  %@", currentCallbackDict);
}

/**
 多層的なcallback
 のテスト中に発覚した、名前が違うクラスMessengerで特定Messengerを挟むとメッセージが送れるにも関わらずhasChildが0を返すバグ
 */
- (void) testCallbackRecursive {
    
    //top
    ClassB * bParent = [[ClassB alloc]initClassBAsParent2];
    
    //middle
    [parent connectParent:TEST_CLASS_B_AS_PARENT_2];

    //bottom
    ClassB * b = [[ClassB alloc]initClassBWithReceiver:@selector(callbackReceiver:)];
    [[b messenger]connectParent:TEST_PARENT_NAME];

    
    //この時点で、bParent > parent > b
    STAssertTrue([[bParent messenger] hasChild], @"no child");
}

/**
 複数回callbackされる場合の挙動
 */
- (void) testCallbackByMultiTimes {
    ClassB * b = [[ClassB alloc]initClassB];
    NSLog(@"b is %@", b);
    NSDictionary * callbackDict = [parent call:TEST_CLASS_B withExec:TEST_EXEC_CALLBACK_BY_CHILD_MULTITIMES  , nil];
    
    STAssertNotNil([callbackDict valueForKey:@"tag3"], @"not contained   callbackDict    %@", callbackDict);
    
    STAssertTrue([[callbackDict valueForKey:@"tag3"] isEqualToString:@"val3"], @"not match... tag3   is  %@", [callbackDict valueForKey:@"tag3"]);
}







//------------------receivers for tests--------------------
/**
 receiver for parent
 */
- (void) parentReceiver:(NSNotification * )notification {}

/**
 receiver for child_persis
 */
- (void) child_persisReceiver:(NSNotification * )notification {
    
    NSDictionary * dict = [child_persis tagValueDictionaryFromNotification:notification];
	
    switch ([child_persis execFrom:TEST_CHILDPERSIS_NAME viaNotification:notification]) {
        case NONE:{
            break;
        }
        default:{
            STFail(@"not scheduled any call,  from myself %d", [child_persis execFrom:TEST_PARENT_NAME viaNotification:notification]);
            break;
        }
    }
    
    switch ([child_persis execFrom:TEST_PARENT_NAME viaNotification:notification]) {
        case TEST_EXEC:{
            break;
        }
        case TEST_EXEC_2:{
            [child_persis callParent:TEST_EXEC_2REPLY, nil];
            break;
        }
        case TEST_EXEC_2012_12_29_21_04_06:{
            [child_persis callParent:TEST_EXEC_2012_12_29_21_05_40, nil];
            break;
        }
        
        /*
         tagValue
         */
        case TEST_EXEC_2013_01_24_15_09_19:{
            STAssertNotNil([dict valueForKey:@"2013/01/24 15:11:10"], @"not match");
            STAssertTrue([[dict valueForKey:@"2013/01/24 15:11:10"] isEqualToString:@"2013/01/24 15:11:12"], @"not match");
            break;
        }
        case TEST_EXEC_2013_01_24_15_09_20:{
            STAssertNotNil([dict valueForKey:@"2013/01/24 15:11:53"], @"not match");
            STAssertTrue([[dict valueForKey:@"2013/01/24 15:11:53"] isEqualToString:@"2013/01/24 15:11:51"], @"not match");
            break;
        }
            
        case TEST_EXEC_2013_01_24_15_09_21:{
            STAssertNotNil([dict valueForKey:@"2013/01/24 15:12:24"], @"not match");
            STAssertTrue([[dict valueForKey:@"2013/01/24 15:12:24"] isEqualToString:@"2013/01/24 15:12:20"], @"not match");
            
            STAssertNotNil([dict valueForKey:@"2013/01/24 15:12:45"], @"not match");
            STAssertTrue([[dict valueForKey:@"2013/01/24 15:12:45"] isEqualToString:@"2013/01/24 15:12:35"], @"not match");            
            break;
        }
        case TEST_EXEC_2013_01_24_15_09_22:{
            STAssertNotNil([dict valueForKey:@"2013/01/24 15:14:18"], @"not match");
            STAssertTrue([[dict valueForKey:@"2013/01/24 15:14:18"] isEqualToString:@"2013/01/24 15:14:16"], @"not match");
            
            STAssertNotNil([dict valueForKey:@"2013/01/24 15:14:26"], @"not match");
            STAssertTrue([[dict valueForKey:@"2013/01/24 15:14:26"] isEqualToString:@"2013/01/24 15:14:23"], @"not match");
   
            
            STAssertNotNil([dict valueForKey:@"2013/01/24 15:13:38"], @"not match");
            STAssertTrue([[dict valueForKey:@"2013/01/24 15:13:38"] isEqualToString:@"2013/01/24 15:13:40"], @"not match");
            
            STAssertNotNil([dict valueForKey:@"2013/01/24 15:13:52"], @"not match");
            STAssertTrue([[dict valueForKey:@"2013/01/24 15:13:52"] isEqualToString:@"2013/01/24 15:13:47"], @"not match");
            break;
        }
            
            
        case NONE:{
            break;
        }
        default:
            STFail(@"not scheduled any call, from parent %d", [child_persis execFrom:TEST_PARENT_NAME viaNotification:notification]);
            break;
    }
}

/**
 receiver for local-instance child_0
 */
- (void) m_testChild0:(NSNotification * )notification {}

/**
 receiver for local-instance child_1
 */
- (void) m_testChild1:(NSNotification * )notification {}

/**
  receiver for local-instance child_2
 */
- (void) m_testChild2:(NSNotification * )notification {}

/**
  receiver for local-instance child_3 
 */
- (void) m_testChild3:(NSNotification * )notification {}


////view
//
///**
// add child
// */
//- (void) testMessengerViewAddChild {
//	MessengerViewController * mView = [[MessengerViewController alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//	
//	MessengerSystem * child_0 = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
//	[child_0 inputParent:TEST_PARENT_NAME];//一件成立している親子関係がある筈
//	
//	
//	//view側で受け取れており、Dictに情報がたまっていればOK
//	NSMutableDictionary * mViewDict = [mView getMessengerList];
//	STAssertTrue([mViewDict count] == 2, [NSString stringWithFormat:@"ViewDict件数が合っていない_%d", [mViewDict count]]);
//	
//	NSMutableDictionary * mButtonDict = [mView getButtonList];
//	STAssertTrue([mButtonDict count] == 2, [NSString stringWithFormat:@"m_buttonList件数が合っていない_%d", [mButtonDict count]]);
//	
//	[mView release];
//	[child_0 release];
//}
//
///**
// remove from parent by child
// */
//- (void) testViewRemoveChild {
//	MessengerViewController * mView = [[MessengerViewController alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//	//ビューを作った時点で、既にPARENTが存在している。が、認識されていない。
//	
//	NSMutableDictionary * mMessengerList = [mView getMessengerList];
//	NSMutableDictionary * mButtonList = [mView getButtonList];
//	
//	MessengerSystem * child_0 = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
//	[child_0 inputParent:TEST_PARENT_NAME];//親子関係を成立、この時点で線が引かれる筈
//	
//	STAssertTrue([mView getNumberOfRelationship] == 1, @"関係性の本数が1本ではない");
//	
//	[child_0 removeFromParent];
//	
//	STAssertTrue([mView getNumberOfRelationship] == 0, @"関係性の本数が0本ではない");
//	
//	
//	STAssertTrue([mMessengerList count] == 2, [NSString stringWithFormat:@"ViewDict件数が合っていない_%d", [mMessengerList count]]);
//	STAssertTrue([mButtonList count] == 2, [NSString stringWithFormat:@"m_buttonList件数が合っていない_%d", [mButtonList count]]);
//	
//	
//	[mView release];
//}
//
///**
// release child by child-death
// */
//- (void) testViewEraseChild {
//	MessengerViewController * mView = [[MessengerViewController alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//	//ビューを作った時点で、既にPARENTが存在している。が、認識されていない。
//	
//	NSMutableDictionary * mMessengerList = [mView getMessengerList];
//	NSMutableDictionary * mButtonList = [mView getButtonList];
//	
//	MessengerSystem * child_0 = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
//	[child_0 inputParent:TEST_PARENT_NAME];//親子関係を成立、この時点で線が引かれる筈
//	
//	STAssertTrue([mView getNumberOfRelationship] == 1, @"関係性の本数が1本ではない");
//	
//	[child_0 release];
//	
//	STAssertTrue([mMessengerList count] == 1, [NSString stringWithFormat:@"ViewDict件数が合っていない_%d", [mMessengerList count]]);
//	STAssertTrue([mButtonList count] == 1, [NSString stringWithFormat:@"m_buttonList件数が合っていない_%d", [mButtonList count]]);
//	
//	
//	[mView release];
//}
//
///**
// release some childs
// */
//- (void) testViewParentKillChild {
//	MessengerViewController * mView = [[MessengerViewController alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//	//ビューを作った時点で、既にPARENTが存在している。が、認識されていない。
//	
//	NSMutableDictionary * mMessengerList = [mView getMessengerList];
//	NSMutableDictionary * mButtonList = [mView getButtonList];
//	
//	MessengerSystem * child_0 = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
//	[child_0 inputParent:TEST_PARENT_NAME];//親子関係を成立、この時点で線が引かれる筈
//	[parent removeAllChild];
//	
//	STAssertTrue([mView getNumberOfRelationship] == 0, @"関係性の本数が0本ではない");
//	
//	STAssertTrue([mMessengerList count] == 2, [NSString stringWithFormat:@"ViewDict件数が合っていない_%d", [mMessengerList count]]);
//	STAssertTrue([mButtonList count] == 2, [NSString stringWithFormat:@"m_buttonList件数が合っていない_%d", [mButtonList count]]);
//	
//	
//	[mView release];
//}
//
///**
// release by parent-death
// */
//- (void) testViewParentDeath {
//	MessengerViewController * mView = [[MessengerViewController alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//	//ビューを作った時点で、既にPARENTが存在している。が、認識されていない。
//	
//	NSMutableDictionary * mMessengerList = [mView getMessengerList];
//	NSMutableDictionary * mButtonList = [mView getButtonList];
//	
//	MessengerSystem * child_0 = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:TEST_CHILD_NAME_0];
//	[child_0 inputParent:TEST_PARENT_NAME];//親子関係を成立、この時点で線が引かれる筈
//	[parent release];
//	
//	STAssertTrue([mView getNumberOfRelationship] == 0, @"関係性の本数が0本ではない");
//	
//	STAssertTrue([mMessengerList count] == 1, [NSString stringWithFormat:@"ViewDict件数が合っていない_%d", [mMessengerList count]]);
//	STAssertTrue([mButtonList count] == 1, [NSString stringWithFormat:@"m_buttonList件数が合っていない_%d", [mButtonList count]]);
//	
//	parent = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(m_testParent:) withName:TEST_PARENT_NAME];
//	
//	[mView release];
//}
//
///**
// name collection with X-index
// */
//- (void) testSortNameIndex {
//	MessengerViewController * mView = [[MessengerViewController alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//	
//	MessengerSystem * mes1 = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"テスト１"];
//	MessengerSystem * mes2 = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"テスト１"];
//	MessengerSystem * mes3 = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"テスト２"];
//	MessengerSystem * mes4 = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"テスト３"];
//	
//	//件数が3件ならOK
//	STAssertTrue([[mView getNameIndexDictionary] count] == 3, @"件数が一致しない");
//	
//	
//	[mes1 release];
//	[mes2 release];
//	[mes3 release];
//	[mes4 release];
//	
//	[mView release];
//}
//
///**
// correct X-position redefinition
// */
//- (void) testSortNameIndex_X {
//	MessengerViewController * mView = [[MessengerViewController alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
//	
//	MessengerSystem * mes1 = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"テスト１"];
//	MessengerSystem * mes2 = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"テスト１"];
//	MessengerSystem * mes3 = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"テスト２"];
//	MessengerSystem * mes4 = [[MessengerSystem alloc] initWithBodyID:self withSelector:@selector(m_testChild0:) withName:@"テスト３"];
//	
//	[mes1 inputParent:[parent getMyName]];
//	
//	
//	//parentが出現し、件数が４件に
//	STAssertTrue([[mView getNameIndexDictionary] count] == 4, @"件数が一致しない");
//	
//	//かつ、parentのインデックスがmes1よりも小さい＝左に来ていればOK
//	
//	int index = [[[mView getNameIndexDictionary] valueForKey:[parent getMyName]] intValue];
//	int index2 = [[[mView getNameIndexDictionary] valueForKey:[mes1 getMyName]] intValue];
//	STAssertTrue(index < index2, @"名称が一致しない0_%d", index);
//	
//	
//	[mes3 inputParent:[parent getMyName]];
//	[mes4 inputParent:[mes3 getMyName]];
//	
//	
//	index = [[[mView getNameIndexDictionary] valueForKey:[parent getMyName]] intValue];
//	index2 = [[[mView getNameIndexDictionary] valueForKey:[mes1 getMyName]] intValue];
//	int index3 = [[[mView getNameIndexDictionary] valueForKey:[mes3 getMyName]] intValue];
//	int index4 = [[[mView getNameIndexDictionary] valueForKey:[mes4 getMyName]] intValue];
//	//多元順序付け、、並べかえのロジック、、に、見直しが必要。合ってない。
//	STAssertTrue(index < index2, @"インデックスが想定通りではない1_%d", index);
//	STAssertTrue(index < index3, @"インデックスが想定通りではない2_%d", index);
//	STAssertTrue(index3 < index4, @"インデックスが想定通りではない3_%d", index);
//	
//	
//	[mes1 release];
//	[mes2 release];
//	[mes3 release];
//	[mes4 release];
//	
//	[mView release];
//}


@end
