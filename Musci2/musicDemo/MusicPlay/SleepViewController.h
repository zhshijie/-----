//
//  SleepViewController.h
//  Musci2
//
//  Created by sky on 14/7/26.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "BaseView.h"
#import "MyFactory.h"
#import "SongPlayController.h"
#import "DLDataPicker.h"

@interface SleepViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,DLDataPickerDataSource,DLDataPickerDelegate>
{
    SongPlayController *_songPlayController;
    int _count;
}
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,assign)NSInteger sleepTimer;
@property(nonatomic,assign)BOOL sleepTimerStart;


+ (id)shareInstance;
@end
