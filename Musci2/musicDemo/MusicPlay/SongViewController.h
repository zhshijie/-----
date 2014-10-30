//
//  SongViewController.h
//  MusicPlay
//
//  Created by sky on 14/7/23.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongPlayController.h"
#import "SongPlayView.h"

@interface SongViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,retain)    NSMutableArray *dataSoure;
@property (retain, nonatomic)  UITableView *tableView;
@property(retain,nonatomic)    SongPlayController *songPlayController;
@property(retain,nonatomic)    SongPlayView *toolView;

//获得数据源
-(NSMutableArray*)_getDataSource:(NSInteger )capacity;

//设置头部视图
-(void)tableViewForHeader;
@end
