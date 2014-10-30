//
//  MainViewController.m
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "MainViewController.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface MainViewController ()

{
    NSIndexPath *_select;
}
@end

@implementation MainViewController

-(void)viewDidAppear:(BOOL)animated
{
    _offset = 100;
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setLabelTitle:@"我的"];
    _rightView = [[RightViewController alloc]init];
    self.tableView = [[[UITableView alloc]init]autorelease];
    self.tableView.frame = self.view.frame;
    self.tableView.backgroundColor = [UIColor clearColor];

    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.songPlayController =[SongPlayController shareSongPlayController];
    self.songPlayController.songdata.playSongMenu = [[self.songPlayController.songdata getAllSongData] copy];
    
    [self tableViewForHeader];
    
    //设置tableView代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //禁止tableView的滑动
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //初始化自定义toolBar工具栏
    self.toolBar = [[SongPlayView alloc]init] ;
    self.toolBar.frame = CGRectMake(0, ScreenHeight-59, 320, 59);
    self.toolBar.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.toolBar];
    

    //设置view的背景
    [self setViewBackground];
    
    //加载数据源
    [self getDataSource];
    
    //添加手势
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightViewDidPush)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    
    [self.tableView addGestureRecognizer:leftSwipe];
    [leftSwipe release];
    
    //在navigation上添加按钮
    UIImageView *rightButtonImage = [MyFactory creatImageView:@"navigationBar_rightButton.png"];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]initWithImage:rightButtonImage.image style:UIBarButtonItemStylePlain target:self action:@selector(rightViewDidPush)];
    self.navigationItem.rightBarButtonItem  =rightButton;
    [rightButton release];
}

-(void)rightViewDidPush
{
    [self.revealSideViewController pushViewController:_rightView onDirection:PPRevealSideDirectionRight withOffset:_offset animated:YES completion:^{
        self.navigationController.navigationBar.tintColor = nil;

    }];
}


-(void)viewWillAppear:(BOOL)animated
{
    
    self.songPlayController.block = ^(int a){
        NSLog(@"%d",a);
        [self.toolBar updateSongPlayView];
    };
    [self.tableView reloadData];
    [self.toolBar updateSongPlayView];
    [self.tableView deselectRowAtIndexPath:_select animated:YES];

}


//设置头视图
-(void)tableViewForHeader
{
    BaseView *headView = [[BaseView alloc]init];
    headView.frame = CGRectMake(0, 0, 320, 320);
    headView.backgroundColor = [UIColor clearColor];
    [self.tableView setTableHeaderView:headView];
    [headView release];
}


#pragma mark - Table view data source

//加载数据源
-(void)getDataSource
{
    self.dataSoure = @[@"我的音乐",@"我的最爱",@"我的歌单",@"我的下载"];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    cell.textLabel.text = _dataSoure[indexPath.row];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.row==0) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)[self.songPlayController.songdata getAllSongData].count];
    }if (indexPath.row==1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld",(unsigned long)[self.songPlayController.songdata getIsLikeSongData].count];
    }
    //设置单元格选择背景颜色
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    cell.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    return [cell autorelease];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0) {
        
        _select = indexPath;
        LocationViewController *location = [[[LocationViewController alloc]init]autorelease];
        [self.navigationController pushViewController:location animated:YES];
    }
    if (indexPath.row==1) {
        MyLikeViewController *mylike = [[MyLikeViewController alloc]init];
        [self.navigationController pushViewController:mylike animated:YES];
        [mylike release];
    }
    
}

-(void)dealloc
{
    [_dataSoure release];
    [_songPlayController release];
    [_toolBar release];
    [_tableView release];
    [_select release];
    [_rightView release];
    [super dealloc];
}
@end
