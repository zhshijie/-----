//
//  SingerSongsViewController.m
//  musicDemo
//
//  Created by sky on 14/7/24.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "SingerSongsViewController.h"

@interface SingerSongsViewController ()

{
    NSMutableArray *_playMenuSong;
    NSString *_name;
}
@end

@implementation SingerSongsViewController


-(id)initwithSong:(NSMutableArray*)songs singerName:(NSString *)name;
{
    if (self=[super init]) {
        _playMenuSong = [songs copy];
        _name = [name copy];
        
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView =[self setLabelTitle:_name] ;
    
    self.dataSoure = [_playMenuSong copy];
    
    //对数据源进行排序
    [self randDataSoure:self.dataSoure];
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MuicSong *song= [[self.dataSoure objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    self.songPlayController.songdata.nowSong = song;
    
    [self.songPlayController stopSong];
    [self.songPlayController upDataNowSong];
    
    //播放按钮显示为播放
    [self.songPlayController playSong];
    [self.toolView updateSongPlayView];
    self.songPlayController.songdata.playSongMenu = _playMenuSong;
    
}



-(void)selectLike:(UIButton*)button
{
    //    NSLog(@"----------------------selectLike");
    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:button.tag%1000 inSection:button.tag/1000-1];
    MuicSong *song = [[self.dataSoure objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
    //    NSLog(@"self.Song---------%@",song);
    if(button.selected==NO)
    {
        if([self.songPlayController.songdata addSongtoIsLikeSong:song])
        {
            button.selected = YES;
        }
        
    }else{
        NSString *alertMessage = [NSString stringWithFormat:@"不在收藏歌曲:%@",song.songName];
        BlockUIAlertView *alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message: alertMessage cancelButtonTitle:@"取消" otherButtonTitles:@"好" buttonBlock:^(NSInteger index){
            if (index==0) {
                NSLog(@"继续收藏歌曲");
            }if (index==1) {
                NSLog(@"%@",alertMessage);
                if ( [self.songPlayController.songdata removeSongFromIsLikeSong:song])
                    button.selected = NO;
            }
        }];
        [alert show];
        //        [alert release];
    }
}

- (void)dealloc
{
    [_playMenuSong release];
    [_name release];
    [super dealloc];
}


@end
