//
//  BaseViewController.m
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "BaseViewController.h"

@implementation UIViewController (BaseViewAciton)

-(UILabel *)setLabelTitle:(NSString *)title
{
    UILabel *label = [MyFactory creatLabel:kNavigationBarTitleLabel];
    label.text = title;
    label.frame = CGRectMake(0 ,0, 100, 44);
    label.font = [UIFont boldSystemFontOfSize:20];
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

-(void)setViewBackground
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationAction) name:kThemeDidChangeNotification object:nil];
    [self loadBackgroun];
}

-(void)notificationAction
{
    [self loadBackgroun];
}
-(void)loadBackgroun
{
    UIImageView *backgroundView = [MyFactory creatImageView:@"allViewBaceground.jpg"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundView.image];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}
@end
