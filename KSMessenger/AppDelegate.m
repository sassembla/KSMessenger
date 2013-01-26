//
//  AppDelegate.m
//  KSMessenger
//
//  Created by sassembla on 2012/12/27.
//  Copyright (c) 2012年 KISSAKI Inc,. All rights reserved.
//

#import "AppDelegate.h"
#import "SampleMainViewController.h"

#define SAMPLEAPP_MASTER    (@"SAMPLEAPP_MASTER")


typedef enum {
    EXEC_SHOW = 0,
    EXEC_HIDE
} SampleAppExecEnum ;


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    messenger = [[KSMessenger alloc]initWithBodyID:self withSelector:@selector(receiver:) withName:SAMPLEAPP_MASTER];
    
    SampleMainViewController * sampleMainView = [[SampleMainViewController alloc]initSampleMainViewControllerWithMasterName:[messenger myName]];
    
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    [self.window addSubview:sampleMainView.view];
    
    
    
    [messenger callMyself:EXEC_SHOW, nil];
    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}
- (void) receiver:(NSNotification * )notif {
    switch ([messenger execFrom:[messenger myName] viaNotification:notif]) {
        case EXEC_SHOW:{
            [messenger call:SAMPLEAPP_MAINVIEWCONT withExec:SAMPLEAPP_MAINVIEWCONT_EXEC_SHOW, nil];
            
            [messenger callMyself:EXEC_HIDE,
             [messenger withDelay:1.0],
             nil];
            break;
        }
        case EXEC_HIDE:{
            [messenger call:SAMPLEAPP_MAINVIEWCONT withExec:SAMPLEAPP_MAINVIEWCONT_EXEC_HIDE, nil];
            
            [messenger callMyself:EXEC_SHOW,
             [messenger withDelay:1.0],
             nil];
            
            break;
        }
            
            
        default:
            break;
    }
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
