//
//  SampleMainViewController.m
//  KSMessenger
//
//  Created by sassembla on 2013/01/23.
//  Copyright (c) 2013年 KISSAKI Inc,. All rights reserved.
//

#import "SampleMainViewController.h"


@interface SampleMainViewController ()

@end

@implementation SampleMainViewController

- (id) initSampleMainViewControllerWithMasterName:(NSString * )masterName {
    if (self = [super init]) {
        messenger = [[KSMessenger alloc]initWithBodyID:self withSelector:@selector(receiver:) withName:SAMPLEAPP_MAINVIEWCONT];
        [messenger connectParent:masterName];
    }
    return self;
}

- (void) receiver:(NSNotification * )notif {
    NSLog(@"here");
    
    switch ([messenger execFrom:[messenger myParentName] viaNotification:notif]) {
        case SAMPLEAPP_MAINVIEWCONT_EXEC_HIDE:{
            [self.view setHidden:YES];
            break;
        }
        case SAMPLEAPP_MAINVIEWCONT_EXEC_SHOW:{
            [self.view setHidden:NO];
            break;
        }
            
        default:
            NSAssert(false, @"not valid");
            break;
    }
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
