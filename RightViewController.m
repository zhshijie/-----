//
//  RightViewController.m
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "RightViewController.h"

@interface RightViewController ()

{
    SongPlayController *_songPlayController;
}
@end

@implementation RightViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = nil;
    [self setViewBackground];
    
    _songPlayController = [SongPlayController shareSongPlayController];
    
    //加载播放顺序按钮图片
    [self loadSongPlayImage];
    
    UIImageView *sleepImage = [MyFactory creatImageView:@"sleepButtonImage.png"];
    [self.sleepButton setImage:sleepImage.image forState:UIControlStateNormal];
}

//加载播放顺序按钮图片
-(void)loadSongPlayImage
{
    NSArray *songPlayImageName = @[@"kSongRandomPlay.png",@"kSongRepeatPlay.png",@"kSongOrderPlay.png"];
    NSArray *songPlayStateLabel = @[@"随机播放",@"单曲循环",@"顺序播放"];
    NSUInteger index =(NSUInteger) _songPlayController.songPlayState;
    UIImageView *PlayImage = [MyFactory creatImageView:[songPlayImageName objectAtIndex:index]];
    [self.playState setImage:PlayImage.image forState:UIControlStateNormal];
    self.playStateLabel.text = songPlayStateLabel[index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_songPlayController release];
    [_sleepButton release];
    [_skinButton release];
    [_preference release];
    [_playState release];
    [_playStateLabel release];
    [super dealloc];
}

- (IBAction)playStateAction:(UIButton *)sender {
    if (_songPlayController.songPlayState < kSongOrderPlay) {
        _songPlayController.songPlayState++;
    }else
    {
        _songPlayController.songPlayState = kSongRandomPlay;
    }
    [self loadSongPlayImage];
}

- (IBAction)sleepAction:(UIButton *)sender {
    
    SleepViewController *sleepView = [SleepViewController shareInstance];
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:sleepView];
    
    [self presentViewController:nav animated:YES completion:^{
    }];
}

- (IBAction)skinAction:(UIButton *)sender {
    SkinViewController *skinView = [[[SkinViewController alloc]init]autorelease];
    BaseNavigationViewController *nav = [[[BaseNavigationViewController alloc]initWithRootViewController:skinView] autorelease];
    
    [self presentViewController:nav animated:YES completion:^{
    }];
}

- (IBAction)preferenceAction:(UIButton *)sender {
}



-(void)loadBackgroun
{
    UIImageView *backgroundView = [MyFactory creatImageView:@"rightViewController_background@2x.png"];
    self.view.backgroundColor = [UIColor colorWithPatternImage:backgroundView.image];
}

@end
