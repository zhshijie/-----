//
//  SkinViewController.h
//  Musci2
//
//  Created by sky on 14/7/26.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeManager.h"

@interface SkinViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
