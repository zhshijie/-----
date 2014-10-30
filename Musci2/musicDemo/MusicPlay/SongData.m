//
//  SongData.m
//  MusicPlay
//
//  Created by sky on 14/7/22.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "SongData.h"

#define kAllSong @"allSong"
#define kIsLikeSong @"isLikeSong"
#define kNowSong @"nowSong"
#define kPlaySongMenu @"playSongMenu"

#define kIsLikeSongNotification @"kIsLikeSongNotification"
static SongData *songdata = nil;

@implementation SongData


@synthesize allSong;
@synthesize isLikeSong;
@synthesize currentSong;
@synthesize nowSong;
@synthesize playSongMenu;


#pragma mark 单例模式与限制

-(id)init
{
    if (self = [super init]) {
        id catchDelegate = [[UIApplication sharedApplication] delegate];
        self.managedObjectContext = [catchDelegate managedObjectContext];
        self.fetchedResultsController  = nil;
//        [self addSong];
        self.nowSong.songName = [[NSUserDefaults standardUserDefaults]objectForKey:@"songName"];
        self.nowSong.singerName = [[NSUserDefaults standardUserDefaults]objectForKey:@"singerName"];
        self.nowSong.songType = [[NSUserDefaults standardUserDefaults]objectForKey:@"songType"];
        self.nowSong.singerImage = [[NSUserDefaults standardUserDefaults]objectForKey:@"singerImage"];
        self.nowSong.songIdentifier = [[NSUserDefaults standardUserDefaults]objectForKey:@"songIdentifier"];
    }
    return self;
}

+(id)shareSingleton
{
    if (songdata==nil) {
        @synchronized(self){
        songdata = [[SongData alloc]init];
        }
    }
    return songdata;
}

+(id)allocWithZone:(struct _NSZone *)zone
{
    if (songdata==nil) {
        @synchronized(self){
            songdata = [super allocWithZone:zone];
        }
    }
    return songdata;
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

#pragma mark 对数据进行操作
/*
//向总歌曲列表中添加歌曲
-(BOOL)addSongInAllSong:(Song*)song
{
    if (song) {
        for (Song *obj in allSong) {
            //判断总歌曲列表中是否有相同的歌曲
            if (![obj.singerName isEqual:song.singerName]||![obj.songName isEqual:song.songName]) {
                [allSong addObject:song];
                [self encodeWithCoder];
                return YES;
            }
        }
    }
    return NO;
}

//从总歌曲列表中删除歌曲
-(BOOL)removeSongInAllSong:(Song*)song
{
    if (song) {
        for (Song *obj in allSong) {
            //判断总歌曲列表中是否有要删除的歌曲
            if ([obj.singerName isEqual:song.singerName]||[obj.songName isEqual:song.songName]) {
                [allSong removeObject:song];
                [self encodeWithCoder];
                return YES;
            }
        }
    }
    return NO;
}

//向收藏歌曲列表中添加歌曲
-(BOOL)addSongInLikeSong:(Song*)song
{
    if (song) {
        for (Song *obj in isLikeSong) {
            //判断收藏的歌曲列表中是否有相同的歌曲
            if (![obj.singerName isEqual:song.singerName]||![obj.songName isEqual:song.songName]) {
                [isLikeSong addObject:song];
                song.isLike = YES;
                [self encodeWithCoder];
                return YES;
            }
        }
        if (isLikeSong.count==0) {
            [isLikeSong addObject:song];
            song.isLike = YES;
            [self encodeWithCoder];
            return YES;
        }
    }
    return NO;
}

//从收藏歌曲列表中删除歌曲
-(BOOL)removeSongInLikeSong:(Song*)song
{
    if (song) {
        for (Song *obj in isLikeSong) {
            //判断收藏的歌曲列表中是否有要删除的歌曲
            if ([obj.singerName isEqual:song.singerName]&&[obj.songName isEqual:song.songName]) {
                [isLikeSong removeObject:song];
                song.isLike = NO;
                [self encodeWithCoder];
                return YES;
            }
        }
    }
    return NO;
}

*/
-(void)dealloc
{
    [nowSong release];
    [currentSong release];
    [playSongMenu release];
    [allSong release];
    [isLikeSong release];
    [super dealloc];
}

#pragma mark 将数据归档和解档
/*
-(void)encodeWithCoder{
    NSOperationQueue *threaQueue = [[[NSOperationQueue alloc]init] autorelease];
    
    //建立多线程
    [threaQueue addOperationWithBlock:^{

    NSString *home = NSHomeDirectory();
    NSString *filePath = [home stringByAppendingPathComponent:@"Documents/music.archive"];
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    [archiver encodeObject:self.allSong forKey:kAllSong];
    [archiver encodeObject:self.isLikeSong forKey:kIsLikeSong];
    [archiver encodeObject:self.nowSong forKey:kNowSong];
    [archiver encodeObject:self.playSongMenu forKey:kPlaySongMenu];
    NSLog(@"likeSongData----%@",self.isLikeSong);
    [archiver finishEncoding];
    [data writeToFile:filePath atomically:YES];
    }];
    
}


-(void)initWithCode
{
    NSString *home = NSHomeDirectory();
    NSString *filePath = [home stringByAppendingPathComponent:@"Documents/music.archive"];
    NSData  *content = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:content];
    self.allSong = [unarchiver decodeObjectForKey:kAllSong];
    self.isLikeSong = [unarchiver decodeObjectForKey:kIsLikeSong];
    self.nowSong = [unarchiver decodeObjectForKey:kNowSong];
    self.playSongMenu = [unarchiver decodeObjectForKey:kPlaySongMenu];
    NSLog(@"self.songData----%@",self.allSong);
    NSLog(@"self.likeSongData----%@",self.isLikeSong);

}

*/
#pragma mark - Fetch Request
 -(NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchrequest = [[NSFetchRequest alloc]init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"MuicSong" inManagedObjectContext:self.managedObjectContext];
    [fetchrequest setEntity:entity];
    
    [fetchrequest setFetchBatchSize:20];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"songName" ascending:YES];
    [fetchrequest setSortDescriptors:@[sortDescriptor]];
    
    NSFetchedResultsController *aFetcedResultsController = [[NSFetchedResultsController alloc]initWithFetchRequest:fetchrequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
    aFetcedResultsController.delegate = self;
    self.fetchedResultsController = aFetcedResultsController;
    [aFetcedResultsController release];
   
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unrsorlved error %@ ,%@",error,[error userInfo]);
    }
    
    return _fetchedResultsController;
}

#pragma mark - core data
-(NSArray *)getAllSongData
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest]entity];
    
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entity];
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"songName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    error = nil;
    NSArray *fetchResult = [context executeFetchRequest:fetchRequest error:&error];
    if (error==nil) {
        return fetchResult;
    }
    return nil;
}


-(NSArray *)getIsLikeSongData
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest]entity];
    
    NSError *error = nil;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]initWithKey:@"songName" ascending:YES];
    [fetchRequest setSortDescriptors:@[sort]];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLike = YES"];
    [fetchRequest setPredicate:predicate];
    
    
    error = nil;
    NSArray *fetchResult = [context executeFetchRequest:fetchRequest error:&error];
    if (error==nil) {
        return fetchResult;
    }
    return nil;
}

-(BOOL)addSongtoIsLikeSong:(MuicSong *)song
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    song.isLike = [NSNumber numberWithBool:YES];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unrsorlved error %@ ,%@",error,[error userInfo]);
        abort();
    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:kIsLikeSongNotification object:nil];
    return YES;
}

-(BOOL)removeSongFromIsLikeSong:(MuicSong *)song
{
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    song.isLike = [NSNumber numberWithBool:NO];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Unrsorlved error %@ ,%@",error,[error userInfo]);
        abort();
    }
//    [[NSNotificationCenter defaultCenter]postNotificationName:kIsLikeSongNotification object:nil];
    return YES;
}


-(void)addSong
{
    MuicSong *song = (MuicSong *)[NSEntityDescription insertNewObjectForEntityForName:@"MuicSong" inManagedObjectContext:self.managedObjectContext];
    song.singerName = @"陈奕讯";
    song.songName = @"爱情转移";
    song.songType = @"mp3";
    song.isLike = [NSNumber numberWithBool:YES];
    song.songIdentifier =[NSNumber numberWithInt:0];
    song.singerImage = @"陈奕迅.jpg";
    
    
    MuicSong *song1 = (MuicSong *)[NSEntityDescription insertNewObjectForEntityForName:@"MuicSong" inManagedObjectContext:self.managedObjectContext];
    song1.singerName = @"勤珂吴";
    song1.songName = @"半壶纱";
    song1.songType = @"mp3";
    song1.isLike = NO;
    song1.singerImage = @"勤珂吴.jpg";
    song1.songIdentifier = [NSNumber numberWithInt:1];
    
    MuicSong *song2 = (MuicSong *)[NSEntityDescription insertNewObjectForEntityForName:@"MuicSong" inManagedObjectContext:self.managedObjectContext];
    song2.singerName = @"陈学东";
    song2.songName = @"不再见";
    song2.songType = @"mp3";
    song2.singerImage = @"陈学东.jpg";
    song2.isLike = [NSNumber numberWithBool:NO];
    song2.songIdentifier = [NSNumber numberWithInt:2];
    
    MuicSong *song3 = (MuicSong *)[NSEntityDescription insertNewObjectForEntityForName:@"MuicSong" inManagedObjectContext:self.managedObjectContext];
    song3.singerName = @"孙宇";
    song3.songName = @"江南烟雨时";
    song3.songType = @"mp3";
    song3.singerImage = @"孙宇.jpg";
    song3.isLike = [NSNumber numberWithBool:NO];
    song3.songIdentifier = [NSNumber numberWithInt:3];
    
    MuicSong *song4 = (MuicSong *)[NSEntityDescription insertNewObjectForEntityForName:@"MuicSong" inManagedObjectContext:self.managedObjectContext];
    song4.singerName = @"夫人";
    song4.songName = @"第一夫人";
    song4.songType = @"mp3";
    song4.singerImage = @"夫人.jpg";
    song4.isLike = [NSNumber numberWithBool:NO];
    song4.songIdentifier = [NSNumber numberWithInt:4];
    
}


-(void)saveNowSong
{
    //将播放的音乐    缓存到本地
    [[NSUserDefaults standardUserDefaults]setObject:self.nowSong.songName forKey:@"songName"];
    [NSUserDefaults standardUserDefaults];

    [[NSUserDefaults standardUserDefaults]setObject:self.nowSong.singerName forKey:@"singerName"];
    [NSUserDefaults standardUserDefaults];

    [[NSUserDefaults standardUserDefaults]setObject:self.nowSong.songType forKey:@"songType"];
    [NSUserDefaults standardUserDefaults];

    [[NSUserDefaults standardUserDefaults]setObject:self.nowSong.singerImage forKey:@"singerImage"];
    [NSUserDefaults standardUserDefaults];

    [[NSUserDefaults standardUserDefaults]setObject:self.nowSong.songIdentifier forKey:@"songIdentifier"];
    [NSUserDefaults standardUserDefaults];
}
@end
