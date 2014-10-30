//
//  SongPlayView.m
//  MusicPlay
//    //初始化自定义toolBar工具栏  播放器控件类
//  Created by sky on 14/7/22.
//  Copyright (c) 2014年 sky. All rights reserved.
//
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#import "SongPlayView.h"


@implementation SongPlayView;

@synthesize timeMessage;
@synthesize soundMessage;
@synthesize songPlayController;
@synthesize songNameLabel;
@synthesize singerView;
@synthesize playButton;
@synthesize nextButton;
@synthesize currentTime;
@synthesize singerNameLaber;

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.songPlayController = [SongPlayController shareSongPlayController] ;
    }
    return self;
}


-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    //初始化自定义toolBar工具栏
    [self initWithToolBar];
}

//初始化自定义toolBar工具栏
-(void)initWithToolBar
{
    BaseView *toolBar = [[BaseView alloc]init];
    toolBar.frame = self.bounds;
    toolBar.backgroundColor = [UIColor colorWithWhite:0.8 alpha:0.5];
    [self addSubview:toolBar];
    
    
    //显示歌曲名
    self.songNameLabel = [[[UILabel alloc]initWithFrame:CGRectMake(50,10,160, 22)] autorelease];
    songNameLabel.text = self.songPlayController.songdata.nowSong.songName;
    [toolBar addSubview:songNameLabel];
    
    //显示演唱者的姓名
    self.singerNameLaber = [[[UILabel alloc]initWithFrame:CGRectMake(50,34,160, 10)] autorelease];
    singerNameLaber.text = self.songPlayController.songdata.nowSong.singerName;
    singerNameLaber.font = [UIFont systemFontOfSize:10];
    [toolBar addSubview:singerNameLaber];
    
    //时间轴
    self.currentTime = [[[UILabel alloc]init] autorelease];
    currentTime.frame = CGRectMake(50, 44, 120, 14);
    currentTime.font =[UIFont systemFontOfSize:8];
    currentTime.text = @"0:00-0:00";
    [toolBar addSubview:currentTime];
    
    
    //播放按钮
//    self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.playButton = [MyFactory creatButton:@"playButton.png" highlighted:@"stopButton.png"];
    [playButton addTarget:self action:@selector(playMusciAction) forControlEvents:UIControlEventTouchUpInside];
//    UIImage *playImage = [UIImage imageNamed:@"playButton.png"];
//    UIImage *stopImage = [UIImage imageNamed:@"stopButton.png"];
    playButton.tag = 1000;
//    [playButton setImage:stopImage forState:UIControlStateSelected];
//    [playButton setImage:playImage forState:UIControlStateNormal];
        if (self.songPlayController.avAudio.isPlaying) {
            playButton.selected = YES;
        }
    playButton.frame = CGRectMake(160+20, (49.0-40.0)/2+10, 40, 40);
    [toolBar addSubview:playButton];
    
    //下一首按钮
//    nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.nextButton = [MyFactory creatButton:@"nextButton.png" highlighted:nil];
    [nextButton addTarget:self action:@selector(nextMusicAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIImage *nextImage = [UIImage imageNamed:@"nextButton.png"];
//    [nextButton setImage:nextImage forState:UIControlStateNormal];
    
    nextButton.frame = CGRectMake(160+70, (49.0-40.0)/2+10, 40, 40);
    [toolBar addSubview:nextButton];
    
    
    //播放界面进入按钮
    UIButton *musciViewbutton = [MyFactory creatButton:nil highlighted:nil];
    musciViewbutton.frame = CGRectMake(0, 10, 49, 49);
    [musciViewbutton addTarget:self action:@selector(musicViewDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:musciViewbutton];
    
//    UIButton *playMenuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *playMenuButton = [MyFactory creatButton:@"playMenuButton" highlighted:nil];
    playMenuButton.frame = CGRectMake(160+120, (49.0-40.0)/2, 49, 49);
//    [playMenuButton setImage:[UIImage imageNamed:@"playMenuButton"] forState:UIControlStateNormal];
    [playMenuButton addTarget:self action:@selector(playMenuDidPush:) forControlEvents:UIControlEventTouchUpInside];
    [toolBar addSubview:playMenuButton];
    
    //歌曲图标
    self.singerView  =  [MyFactory creatImageView:self.songPlayController.songdata.nowSong.singerImage];
    singerView.frame = CGRectMake(0, 10, 49, 49);
    [toolBar addSubview:singerView];
    
    
    self.timeMessage = [[[UISlider alloc]init] autorelease];
    self.timeMessage.frame = CGRectMake(0, 0, 320, 10);
    [self.timeMessage setThumbImage:[UIImage imageNamed:@"timeThumb.jpg"] forState:UIControlStateNormal];
    [self.timeMessage setMaximumTrackImage:[UIImage imageNamed:@"mumTrackImage.jpg"] forState:UIControlStateNormal];
    [self.timeMessage setMinimumTrackImage:[UIImage imageNamed:@"mumTrackImage.jpg"] forState:UIControlStateNormal];
    [self.timeMessage addTarget:self action:@selector(TimeDidChange:) forControlEvents:UIControlEventValueChanged];
    
    self.timeMessage.minimumValue = 0;
    self.timeMessage.maximumValue = self.songPlayController.avAudio.duration;
    self.timeMessage.value = self.songPlayController.avAudio.currentTime;
    [toolBar addSubview:self.timeMessage];
    
    [toolBar release];
}

-(void)updateSongPlayView
{
    self.singerNameLaber.text = self.songPlayController.songdata.nowSong.singerName;
    self.timeMessage.maximumValue = self.songPlayController.avAudio.duration;
    self.songNameLabel.text = self.songPlayController.songdata.nowSong.songName;
    self.singerView.image = [UIImage imageNamed:self.songPlayController.songdata.nowSong.singerImage];
    if (self.songPlayController.avAudio.isPlaying) {
        self.playButton.selected = YES;
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimeisChange:) userInfo:nil repeats:YES];
    }else{
        self.playButton.selected = NO;
    }
}

#pragma mark buttonAction
//播放歌曲
-(void)playMusciAction
{
    
    if (self.playButton.selected) {
        [self.songPlayController pauseSong];
        self.playButton.selected = NO;
        [NSTimer initialize];
    }
    else{
        [self.songPlayController playSong];
        self.playButton.selected = YES;
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(TimeisChange:) userInfo:nil repeats:YES];
    }
}

//下一首歌曲
-(void)nextMusicAction:(UIButton*)button
{
    [self.songPlayController nextSong];
    [self.songPlayController playSong];
    [self updateSongPlayView];
}

//弹出音乐播放界面
-(void)musicViewDidPush:(UIButton*)button
{
    
}


//弹出播放列表
-(void)playMenuDidPush:(UIButton*)button
{
    
}

- (void)SoundDidChange:(UISlider *)sender {
    self.songPlayController.avAudio.volume = sender.value;
}

- (void)TimeDidChange:(UISlider *)sender {
    self.songPlayController.avAudio.currentTime = sender.value;
}




-(void)TimeisChange:(NSTimer *)timer
{

    
    if (self.songPlayController.avAudio.playing) {
        NSString *current = [NSString stringWithFormat:@"%d:%d - %d:%d",(int)self.songPlayController.avAudio.currentTime/60,(int)self.songPlayController.avAudio.currentTime%60,(int)self.songPlayController.avAudio.duration/60,(int)self.songPlayController.avAudio.duration%60];
        currentTime.text = current;
        self.timeMessage.value = self.songPlayController.avAudio.currentTime;
        self.soundMessage.value = self.songPlayController.avAudio.volume;
    }
}

-(void)dealloc
{
    [currentTime release];
    [nextButton release];
    [singerNameLaber release];
    [songPlayController release];
    [songNameLabel release];
    [singerView release];
    [timeMessage release];
    [soundMessage release];
    [playButton release];
    
    [super dealloc];

}
@end
