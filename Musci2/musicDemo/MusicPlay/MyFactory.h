//
//  MyFactory.h
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ThemeButton.h"
#import "ThemeImage.h"
#import "ThemeLabel.h"

@interface MyFactory : NSObject


+ (UIButton *)creatButton:(NSString *)imageName highlighted :(NSString *)highlightImage;

+ (UIImageView *)creatImageView:(NSString *)imageName;

+(UILabel *)creatLabel:(NSString *)textColor;
@end
