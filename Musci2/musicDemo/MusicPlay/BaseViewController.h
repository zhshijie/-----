//
//  BaseViewController.h
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyFactory.h"

@interface UIViewController (BaseViewAciton)

//设置视图的标题
-(UILabel*)setLabelTitle:(NSString*)title;

//设置视图的背景
-(void)setViewBackground;

- (void)loadBackgroun;
@end
