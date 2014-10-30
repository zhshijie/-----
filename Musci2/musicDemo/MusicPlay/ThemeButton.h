//
//  ThemeButton.h
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"

@interface ThemeButton : UIButton

//normal状态下的图片名称
@property(nonatomic,copy)NSString *imageName;
//高亮状态下的图片名称
@property(nonatomic,copy)NSString *highlightImage;


- (id) initwithImage:(NSString *)imageName highlighted :(NSString *)highlightImage;

@end
