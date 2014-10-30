//
//  ThemeImage.h
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"

@interface ThemeImage : UIImageView

//图片名称
@property(nonatomic,copy)NSString *imageName;

-(id)initWIthImageName:(NSString *)imageName;

@end
