//
//  ThemeManager.h
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kThemeDidChangeNotification @"kThemeDidChangeNotification"
#define kThemeName @"kThemeName"

@interface ThemeManager : NSObject

//主题配置信息
@property (nonatomic,retain)NSDictionary *themesConfig;

//当前使用的主题名称
@property(nonatomic,copy)NSString *themeName;

//字体的配置信息
@property(nonatomic,retain)NSDictionary *fontConfig;

+ (ThemeManager *)shareInstance;

//获得当前主题下的照片
- (UIImage *)getThemeImage:(NSString *)imageName;

//返回当前主题字体的颜色
- (UIColor *)getColorWithName:(NSString *)name;
@end
