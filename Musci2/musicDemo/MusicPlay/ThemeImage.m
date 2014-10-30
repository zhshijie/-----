//
//  ThemeImage.m
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "ThemeImage.h"

@implementation ThemeImage

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
 
    }
    return self;
}

-(id)initWIthImageName:(NSString *)imageName
{
    self = [self initWithFrame:CGRectZero];
    if(self != nil)
    {
        self.imageName = imageName;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
        [self loadThtmeImage];
    }
    return self;
}

-(void)loadThtmeImage
{
    ThemeManager *themeManager = [ThemeManager shareInstance];
    UIImage *image = [themeManager getThemeImage:self.imageName];
    self.image = image;
}

#pragma mark - NSNotification action
//当主题切换时会调用
-(void)themeNotification:(NSNotification *)notification
{
    [self loadThtmeImage];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    [super dealloc];
}

@end
