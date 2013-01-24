//
//  AppDelegate.h
//  KSMessenger
//
//  Created by sassembla on 2012/12/27.
//  Copyright (c) 2012年 KISSAKI Inc,. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KSMessenger.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    KSMessenger * messenger;
}

@property (strong, nonatomic) UIWindow *window;

@end
