//
//  MyFactory.m
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "MyFactory.h"

@implementation MyFactory

//创建按钮
+ (UIButton *)creatButton:(NSString *)imageName highlighted:(NSString *)highlightImage
{
    ThemeButton *button = [[ThemeButton alloc]initwithImage:imageName highlighted:highlightImage];
    return [button autorelease];
}

//创建图片视图
+(UIImageView *)creatImageView:(NSString *)imageName
{
    ThemeImage *imageView = [[ThemeImage alloc]initWIthImageName:imageName];
    return [imageView autorelease];
}

+(UILabel *)creatLabel:(NSString *)textColor
{
    ThemeLabel *laber = [[ThemeLabel alloc]initWithColorName:textColor];
    return [laber autorelease];
}

@end
