//
//  SampleMainViewController.h
//  KSMessenger
//
//  Created by sassembla on 2013/01/23.
//  Copyright (c) 2013年 KISSAKI Inc,. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSMessenger.h"


#define SAMPLEAPP_MAINVIEWCONT  (@"SAMPLEAPP_MAINVIEWCONT")
typedef enum {
    SAMPLEAPP_MAINVIEWCONT_EXEC_HIDE = 0,
    SAMPLEAPP_MAINVIEWCONT_EXEC_SHOW
} MainViewCont ;


@interface SampleMainViewController : UIViewController {
    KSMessenger * messenger;
}
- (id) initSampleMainViewControllerWithMasterName:(NSString * )masterName;
@end
