//
//  SingerViewController.h
//  MusicPlay
//
//  Created by sky on 14/7/23.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongPlayController.h"
#import "BaseView.h"

@interface SingerViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (copy,nonatomic)    NSMutableArray *dataSoure;
@property(retain,nonatomic)   SongPlayController *songPlayController;

@end
