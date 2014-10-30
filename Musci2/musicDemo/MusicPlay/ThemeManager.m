//
//  ThemeManager.m
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//



#import "ThemeManager.h"
#define Color(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]

static ThemeManager *sigleton = nil;

@implementation ThemeManager



- (void)setThemeName:(NSString *)themeName
{
    if (_themeName!=nil) {
        _themeName=nil;
    }
    _themeName = [themeName copy];
    
    //获得主题包的目录
    NSString *themePath = [self getThemePaht];
    NSString *filePath = [themePath stringByAppendingPathComponent:@"fontColor.plist"];
    
    if (_fontConfig!=nil) {
        _fontConfig = nil;
    }
    _fontConfig = [[NSDictionary dictionaryWithContentsOfFile:filePath] retain];
}

 - (id)init
{
    if (self!= nil) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"];
        self.themesConfig = [NSDictionary dictionaryWithContentsOfFile:filePath];
    
        NSString *fontFilePath = [[NSBundle mainBundle] pathForResource:@"fontColor" ofType:@"plist"];
        self.fontConfig = [NSDictionary dictionaryWithContentsOfFile:fontFilePath];
        
//        self.themeName = @"第一种";
        self.themeName = @"默认";
        
    }
    return self;
}


//限制当前对象创建多个实例
#pragma mark - sengleton setting
+(ThemeManager *)shareInstance
{
    if (sigleton == nil) {
        @synchronized(self){
        sigleton = [[ThemeManager alloc] init];
        }
    }
    return sigleton;
}


+(id)allocWithZone:(struct _NSZone *)zone
{
    if (sigleton==nil) {
        @synchronized(self)
        {
            sigleton = [super allocWithZone:zone];
        }
    }
    return sigleton;
}

-(oneway void)release
{
}

-(NSUInteger)retainCount
{
    return UINT16_MAX;
}

-(id)autorelease
{
    return self;
}

-(id)retain
{
    return self;
}

//获得当前主题包的目录
-(NSString *)getThemePaht
{
    NSString *resourcePath = [[NSBundle mainBundle]resourcePath];

    if ([self.themeName isEqualToString:@"默认"]) {
        
        //项目包的根目录
        return resourcePath;
    }
    
    //获得当前主题的子路径
    NSString *subPath = [_themesConfig objectForKey:self.themeName];
    
    //主题的完整路径
    NSString *path = [resourcePath stringByAppendingPathComponent:subPath];
    return path;

}

//获得当前主题下的图片
- (UIImage *)getThemeImage:(NSString *)imageName
{
    if (imageName.length == 0) {
        return nil;
    }
    //获得当前主题包目录
    NSString *path = [self getThemePaht];
    
    //imageName在当前主题包的路径
    NSString *imagePath = [path stringByAppendingPathComponent:imageName];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

- (UIColor *)getColorWithName:(NSString *)name
{
    
    if (name.length == 0) {
        return nil;
    }
    NSString * rgb = [self.fontConfig objectForKey:name];
    
    NSArray *rgbs = [rgb componentsSeparatedByString:@","];
    
    if (rgbs.count ==3) {
        
        float r = [rgbs[0] floatValue];
        float g = [rgbs[1] floatValue];
        float b = [rgbs[2] floatValue];
//        UIColor *color = [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
        UIColor *color  = Color(r, g, b, 1);
        return color;

    }
    return nil;
}


@end
