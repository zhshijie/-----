//
//  LocationViewController.h
//  MusicPlay
//
//  Created by sky on 14/7/22.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongPlayView.h"
#import "BaseNavigationViewController.h"
#import "BaseViewController.h"

@interface LocationViewController : UIViewController

@property(nonatomic,retain)UIScrollView *scrollView;
@property(nonatomic,retain)SongPlayView *toolView;

@end
