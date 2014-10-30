//
//  SongPlayController.m
//  MusicPlay
//
//  Created by sky on 14/7/22.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "SongPlayController.h"

static SongPlayController *songPlayController = nil;
@implementation SongPlayController

@synthesize isRandom;
@synthesize block;

-(id)init
{
    if (self=[super init]) {
        isRandom = NO;
        self.songdata = [SongData shareSingleton];
        self.avAudio = [self getNowAVaudioPlayer];
        self.songPlayState = kSongOrderPlay;
    }
    
    return self;
}

+(id)shareSongPlayController
{
    if (songPlayController==nil) {
        @synchronized(self){

        songPlayController = [[SongPlayController alloc]init];
        }
    }
    return songPlayController ;
}

+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (songPlayController==nil) {
        @synchronized(self){
            
            songPlayController = [super allocWithZone:zone];
        }
    }
    return songPlayController ;
}

+(id)copyWithZone:(struct _NSZone *)zone{
    return self;
}

- (id)autorelease
{
    return self;
}

-(id)retain
{
    return self;
}

- (NSUInteger)retainCount
{
    return UINT16_MAX;
}

- (oneway void)release{
}

-(void)updataSongMenu
{
    if (self.songPlayState==kSongOrderPlay) {
        return;
    }
    if (self.songPlayState ==kSongRandomPlay) {
        isRandom = YES;
    }
}


//获得音乐播放器
-(AVAudioPlayer *)getNowAVaudioPlayer
{
    NSError *error;
    NSURL *musicURl =[self getNowSongURL];
    AVAudioPlayer *audio = [[[AVAudioPlayer alloc]initWithContentsOfURL:musicURl error:&error]autorelease];
    audio.delegate = self;
    return audio;
}

//得到当前播放歌曲的URL地址
-(NSURL*)getNowSongURL
{
    NSURL *musicURl = [[[NSURL alloc]init] autorelease];
    NSString *musicPath = [[[NSString alloc]init]autorelease];

    if (_songdata.nowSong.songName)
    {
        musicPath= [[NSBundle mainBundle] pathForResource:_songdata.nowSong.songName  ofType:_songdata.nowSong.songType];
        musicURl= [NSURL fileURLWithPath:musicPath];
    }
    return musicURl;
}

//更新播放歌曲
-(void)upDataNowSong
{
    if (self.avAudio!=nil) {
        self.avAudio = nil;
    }
    self.avAudio = [self getNowAVaudioPlayer];
}

#pragma mark - 歌曲操作

-(void)nextSong
{
    [self updataSongMenu];
    
    if (self.avAudio==nil) {
        self.avAudio = [self getNowAVaudioPlayer];
    }
    NSInteger index;
    
    //判断是否为随机播放
    if (self.isRandom) {
        index= random()%_songdata.playSongMenu.count;
        if (index>=_songdata.playSongMenu.count) {
            index--;
        }
    }
    else{
        index = [_songdata.nowSong.songIdentifier intValue];
        if (index<_songdata.playSongMenu.count-1) {
            index++;
        }
        else
        {
            index = 0;
        }
    
    }
    MuicSong *_realSong = [_songdata.playSongMenu objectAtIndex:index];
    self.songdata.nowSong = _realSong;
    [self upDataNowSong];
    [self.songdata saveNowSong];
}

-(void)beforeSong
{
    [self updataSongMenu];
    AVAudioPlayer *avaudio = [self getNowAVaudioPlayer];
    if (avaudio==nil) {
        return;
    }
    NSInteger index;
    //判断是否为随机播放
    if (self.isRandom) {
         index= random()%_songdata.playSongMenu.count-1;
    }
    else{
     index = [_songdata.nowSong.songIdentifier intValue];
         if (index>0) {
      index--;
         }
         else
          {
        index = _songdata.playSongMenu.count-1;
         }
    }
    MuicSong *_realSong = [_songdata.allSong objectAtIndex:index];
    self.songdata.nowSong = _realSong;
    [self upDataNowSong];
    [self.songdata saveNowSong];

}

-(void)playSong
{
       [self.avAudio play];
    [self.songdata saveNowSong];
}

-(void)pauseSong
{
    if (self.avAudio.isPlaying) {
        [self.avAudio pause];
    }
}

-(void)stopSong
{
    if (self.avAudio.isPlaying) {
        [self.avAudio stop];
    }
}

-(void)dealloc
{
    [_songdata release];
    [_avAudio release];
    [super dealloc];
}

-(NSString*)description
{
    NSString *str = [NSString stringWithFormat:@"songdata:%@\n avAudio:%@",self.songdata,self.avAudio];
    return str;
}

#pragma mark  - AVAudioPlayerDelegate

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    //判断是否为单曲循环
    if (self.songPlayState!=kSongRepeatPlay) {
        [self nextSong];
        [self playSong];
    }
    else
    {
        [self playSong];
    }
    
    self.block(10);
}

@end
