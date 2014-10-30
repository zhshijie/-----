//
//  ThemeButton.m
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "ThemeButton.h"

@implementation ThemeButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    }
    return self;
}

- (id)initwithImage:(NSString *)imageName highlighted:(NSString *)highlightImage
{
    self = [super init];
    if (self!=nil) {
        self.imageName = imageName;
        self.highlightImage = highlightImage;
        
        //窃听切换的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
        [self loadThtmeImage];
    }
    return self;
}

 - (void)loadThtmeImage
{
    ThemeManager *themeManger = [ThemeManager shareInstance];
    //获得当前主题normal状态下的图片
    UIImage *image = [themeManger getThemeImage:self.imageName];
    UIImage *highlightImage  = [themeManger getThemeImage:self.highlightImage];
    
    //设置图片
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:highlightImage forState:UIControlStateSelected];
    
}


#pragma mark - NSNotification action
//当主题切换时会调用
-(void)themeNotification:(NSNotification *)notification
{
    [self loadThtmeImage];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
