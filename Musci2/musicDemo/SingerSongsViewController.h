//
//  SingerSongsViewController.h
//  musicDemo
//
//  Created by sky on 14/7/24.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "MyLikeViewController.h"
#import "BaseViewController.h"
#import "BlockUIAlertView.h"

@interface SingerSongsViewController : MyLikeViewController


-(id)initwithSong:(NSMutableArray*)songs singerName:(NSString *)name;

@end
