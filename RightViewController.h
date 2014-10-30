//
//  RightViewController.h
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFactory.h"
#import "SongPlayController.h"
#import "SleepViewController.h"
#import "BaseNavigationViewController.h"
#import "SkinViewController.h"
#import "BaseViewController.h"

@interface RightViewController : UIViewController

@property (retain, nonatomic) IBOutlet UIButton *playState;

@property (retain, nonatomic) IBOutlet UIButton *sleepButton;
@property (retain, nonatomic) IBOutlet UIButton *skinButton;
@property (retain, nonatomic) IBOutlet UIButton *preference;
@property (retain, nonatomic) IBOutlet UILabel *playStateLabel;


- (IBAction)playStateAction:(UIButton *)sender;
- (IBAction)sleepAction:(UIButton *)sender;
- (IBAction)skinAction:(UIButton *)sender;
- (IBAction)preferenceAction:(UIButton *)sender;

@end
