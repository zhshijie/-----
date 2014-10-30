//
//  SongPlayView.h
//  MusicPlay
//
//  Created by sky on 14/7/22.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SongPlayController.h"
#import "BaseView.h"
#import "MyFactory.h"

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface SongPlayView : UIView

@property(nonatomic,retain)    UILabel *currentTime;
@property(nonatomic,retain)    UIButton *nextButton;
@property(nonatomic,retain)    UILabel *singerNameLaber;
@property(nonatomic,retain)    UILabel *songNameLabel;
@property(nonatomic,retain)    UIImageView *singerView;

//时间轴
@property (nonatomic,retain)UISlider *timeMessage;
//声音轴
@property(nonatomic,retain)UISlider *soundMessage;
@property(nonatomic,retain)UIButton *playButton;
@property(nonatomic,retain) SongPlayController *songPlayController;

//音乐播放按钮
-(void)playMusciAction;

//更新播放器
-(void)updateSongPlayView;
@end
