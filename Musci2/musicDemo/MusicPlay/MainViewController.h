//
//  MainViewController.h
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongPlayController.h"
#import "BaseView.h"
#import "SongPlayView.h"
#import "SongData.h"
#import "LocationViewController.h"
#import "MyLikeViewController.h"
#import "RightViewController.h"
#import "PPRevealSideViewController.h"


@interface MainViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    CGFloat _offset;
    RightViewController *_rightView;
}

@property(nonatomic,retain)    NSArray *dataSoure;
@property(nonatomic,retain)SongPlayController *songPlayController;
@property(nonatomic,retain)SongPlayView *toolBar;
@property(nonatomic,retain)UITableView *tableView;

@end
