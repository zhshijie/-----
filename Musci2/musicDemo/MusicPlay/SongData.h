//
//  SongData.h
//  MusicPlay
//
//  Created by sky on 14/7/22.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "BaseDB.h"
#import "MuicSong.h"
#import <CoreData/CoreData.h>

@interface SongData : NSObject<NSFetchedResultsControllerDelegate>

@property(nonatomic,retain)NSMutableArray *allSong;
@property(nonatomic,retain)NSMutableArray *isLikeSong;
@property(nonatomic,retain)MuicSong *nowSong;
@property(nonatomic,retain)MuicSong *currentSong;
@property(nonatomic,retain)NSMutableArray *playSongMenu;

@property(strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property(strong,nonatomic)NSFetchedResultsController *fetchedResultsController;

//获得单例
+(id)shareSingleton;

////－－删除或增加歌曲
//-(BOOL)addSongInAllSong:(Song*)song;
//-(BOOL)removeSongInAllSong:(Song*)song;
//-(BOOL)addSongInLikeSong:(Song*)song;
//-(BOOL)removeSongInLikeSong:(Song*)song;
//
////对数据进行归档和存档
//-(void)initWithCode;
//-(void)encodeWithCoder;
//

//使用coredata
-(NSArray *)getAllSongData;
-(NSArray *)getIsLikeSongData;
-(BOOL)addSongtoIsLikeSong:(MuicSong *)song;
-(BOOL)removeSongFromIsLikeSong:(MuicSong *)song;

-(void)saveNowSong;

@end
