//
//  ThemeLabel.h
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"
#define kNavigationBarTitleLabel @"kNavigationBarTitleLabel"
#define kTableVIewCellText  @"kTableVIewCellText"

@interface ThemeLabel : UILabel

@property(nonatomic,copy)NSString *colorName;

-(id)initWithColorName:(NSString *)colorName;
@end
