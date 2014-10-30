//
//  SongPlayController.h
//  MusicPlay
//
//  Created by sky on 14/7/22.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "SongData.h"
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//音乐播放的状态
typedef enum : NSUInteger {
    kSongRandomPlay = 0,//随机播放
    kSongRepeatPlay = 1,//单曲循环
    kSongOrderPlay = 2,//顺序播放
} SongPlayState;


typedef void(^SongPlayBlock)(int a);

@interface SongPlayController : NSObject<AVAudioPlayerDelegate>

//获得音乐数据
@property(nonatomic,retain)SongData *songdata;
@property(nonatomic,retain)AVAudioPlayer *avAudio;

//是否随机播放
@property(nonatomic,assign)BOOL isRandom;
@property(nonatomic,assign)SongPlayState songPlayState;
@property(nonatomic,copy)SongPlayBlock block;

//获得当前的音乐播放器
-(AVAudioPlayer*)getNowAVaudioPlayer;

+(id)shareSongPlayController;

//歌曲操作
-(void)nextSong;
-(void)beforeSong;
-(void)playSong;
-(void)pauseSong;
-(void)stopSong;

-(void)upDataNowSong;

@end
