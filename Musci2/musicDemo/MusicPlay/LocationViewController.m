//
//  LocationViewController.m
//  MusicPlay
//
//  Created by sky on 14/7/22.
//  Copyright (c) 2014年 sky. All rights reserved.
//


#import "LocationViewController.h"
#import "SingerViewController.h"
#import "SongViewController.h"
#import "SongPlayView.h"

#define kNumberOfPage  2

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface LocationViewController ()
{
    SongViewController *_songView;
}
@end

@implementation LocationViewController

@synthesize scrollView;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置view的背景
    [self setViewBackground];
    
    UILabel *titleLabel = [self setLabelTitle:@"我的音乐"];
    self.navigationItem.titleView = titleLabel;
    
//    [self.navigationItem.titleView addSubview:titleLabel];
    
   //初始化scrollView
    self.scrollView = [[[UIScrollView alloc]init] autorelease];
    scrollView.frame = [UIScreen mainScreen].bounds;
    scrollView.contentSize = CGSizeMake(320*kNumberOfPage,self.view.frame.size.height);
    scrollView.scrollEnabled = YES;
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor clearColor];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:scrollView];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _songView= [[SongViewController alloc]init];
    SingerViewController *singerView = [[SingerViewController alloc]init]  ;
    
    NSArray *viewControllers = @[_songView,singerView];
    
    //初始化歌曲列表
    int i=0;
    for (UIViewController *viewController in viewControllers) {
        viewController.view.frame = CGRectMake(i*320,0,320, ScreenHeight);
        [self.scrollView addSubview:viewController.view];
        i++;
    }
    
    // 初始化自定义toolBar工具栏
    self.toolView= [[[SongPlayView alloc]init] autorelease];
    _toolView.frame = CGRectMake(0, ScreenHeight-59, 320, 59);
    _toolView.backgroundColor = [UIColor clearColor];
    _toolView.tag = INT16_MAX;
    [self.view addSubview:self.toolView];
    
    _songView.toolView = self.toolView;
    
    [self.toolView updateSongPlayView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    _songView.songPlayController.block = ^(int a){
        [_songView.toolView updateSongPlayView];
    };
    [self.toolView updateSongPlayView];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [scrollView release];
    [_toolView release];
    [super dealloc];
}

@end
