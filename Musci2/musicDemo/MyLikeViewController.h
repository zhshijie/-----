//
//  MyLikeViewController.h
//  musicDemo
//
//  Created by sky on 14/7/24.
//  Copyright (c) 2014年 sky. All rights reserved.
//



#import <UIKit/UIKit.h>
#import "SongPlayController.h"
#import "SongPlayView.h"

@interface MyLikeViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)    NSMutableArray *dataSoure;
@property (retain, nonatomic)  UITableView *tableView;
@property(retain,nonatomic)    SongPlayController *songPlayController;
@property(retain,nonatomic)   SongPlayView *toolView;


-(void)randDataSoure:(NSMutableArray *)dataSourceTemp;
@end
