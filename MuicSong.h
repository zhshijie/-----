//
//  MuicSong.h
//  Musci2
//
//  Created by sky on 14/7/28.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MuicSong : NSManagedObject

@property (nonatomic, retain) NSString * songName;
@property (nonatomic, retain) NSString * singerName;
@property (nonatomic, retain) NSString * songType;
@property (nonatomic, retain) NSString * singerImage;
@property (nonatomic, retain) NSNumber * isLike;
@property (nonatomic, retain) NSNumber * songIdentifier;

@end
