//
//  ThemeLabel.m
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "ThemeLabel.h"

@implementation ThemeLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setColor];
    }
    return self;
}

-(void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
    [self setColor];
}

-(id)initWithColorName:(NSString *)colorName
{
    self = [super init];
    if (self != nil) {
        
        self.colorName = colorName;
        
          [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeNotification:) name:kThemeDidChangeNotification object:nil];
        [self setColor];
    }
    return self;
}

-(void)setColor{
    UIColor *color = [[ThemeManager shareInstance]getColorWithName:self.colorName];
    self.textColor = color;
}

-(void)themeNotification:(NSNotification *)notification
{
    [self setColor];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
