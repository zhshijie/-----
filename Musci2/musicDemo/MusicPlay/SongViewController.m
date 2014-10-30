//
//  SongViewController.m
//  MusicPlay
//
//  Created by sky on 14/7/23.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "SongViewController.h"
#import "BlockUIAlertView.h"
#import "SongPlayView.h"
#import "LocationViewController.h"
#import "SongData.h"

@interface SongViewController ()

@end

@implementation SongViewController

-(id)init{
    if (self = [super init]) {
        
        //初始化toolView
        self.toolView = [[[SongPlayView alloc]init] autorelease];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.songPlayController.block = ^(int a)
    {
        [self.toolView updateSongPlayView];
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //设置view的背景
    [self setViewBackground];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.frame =self.view.frame;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = nil;
    
    [self.view addSubview:self.tableView];
    
    self.dataSoure = [[NSMutableArray alloc]initWithCapacity:10];
    self.songPlayController = [SongPlayController shareSongPlayController];

   
    //获得数据源
    self.dataSoure = [[self _getDataSource:10] copy];
    
    //对数据源进行排序
        [self randDataSoure:_dataSoure];

    //设置头部视图
    [self tableViewForHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//获得数据源
-(NSMutableArray*)_getDataSource:(NSInteger )capacity
{
    NSLog(@"_getDataSource");
    NSMutableArray *dataSourceTemp = [NSMutableArray arrayWithCapacity:capacity];
//    dataSourceTemp = self.songPlayController.songdata.allSong;
    
    dataSourceTemp = [[SongData shareSingleton] getAllSongData];
    return  dataSourceTemp;
}


//对数据进行排列
/*
 *参数：dataSourceTemp
 *需要进行排列的数据源
 */
-(void)randDataSoure:(NSMutableArray *)dataSourceTemp
{
    NSLog(@"randDataSoure");
    UILocalizedIndexedCollation *theCollation = [UILocalizedIndexedCollation currentCollation];
    //创建于Section数目相同的空数组
    NSInteger sectionCount = [[theCollation sectionTitles]count];
    NSMutableArray *sectionArrays =[NSMutableArray arrayWithCapacity:sectionCount];
//    NSLog(@"%ld",(long)sectionCount);
    for (int i=0; i<sectionCount; i++) {
        [sectionArrays addObject:[NSMutableArray arrayWithCapacity:1]];
    }
    
    
    //将数据放入上面的数组中
    for(MuicSong * song in dataSourceTemp){
        NSInteger sect = [theCollation sectionForObject:song collationStringSelector:@selector(songName)];
        [[sectionArrays objectAtIndex:sect] addObject:song];
    }
    //将section中的数据追加到表格用数组中
    self.dataSoure = [NSMutableArray arrayWithCapacity:sectionCount];
    for (NSMutableArray *sectionArray in sectionArrays) {
        NSArray *sortedSection = [theCollation sortedArrayFromArray:sectionArray collationStringSelector:@selector(songName)];
        [self.dataSoure addObject:sortedSection];
    }
}

-(NSArray*)sectionIndexTitlesForTableView:(UITableView *)tableView
{
//    NSLog(@"sectionIndexTitlesForTableView");
    return [[UILocalizedIndexedCollation currentCollation]sectionTitles];
}



-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
//    NSLog(@"sectionForSectionIndexTitle");
    return [[UILocalizedIndexedCollation currentCollation]sectionForSectionIndexTitleAtIndex:index];
}



//设置头视图
-(void)tableViewForHeader
{
    BaseView *headView = [[BaseView alloc]init];
    headView.frame = CGRectMake(0, 0, 320, 64);
    headView.backgroundColor = [UIColor clearColor];
    [self.tableView setTableHeaderView:headView];
    [headView release];
}

#pragma mark - deleagate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    NSLog(@"numberOfSectionsInTableView");
        return [_dataSoure count];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return [[_dataSoure objectAtIndex:section]count];
//    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath----%@",indexPath);
    
    NSString *identifier = @"cellidentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        UILabel *label = [MyFactory creatLabel:kTableVIewCellText];
        label.tag = 2013;
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont boldSystemFontOfSize:18];
        label.frame = CGRectMake(50, 10, 200, 30);
        [cell.contentView addSubview:label];
        

        [cell autorelease];
    }
    
    //设置单元格选择背景颜色
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    MuicSong *charater= [[self.dataSoure objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];

    UILabel *cellLabel =(UILabel *)[cell.contentView viewWithTag:2013];
    cellLabel.text = charater.songName;
    
    cell.detailTextLabel.text = charater.singerName;
    cell.detailTextLabel.textColor = [UIColor blackColor];
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.3];
    
    cell.imageView.frame = CGRectMake(0, 0, 44, 44);
    cell.imageView.image = [UIImage imageNamed:@"unlike.png"];
    
//    UIButton *likebutton  =[UIButton buttonWithType:UIButtonTypeCustom];
//    [likebutton setImage:[UIImage imageNamed:@"likeIcon.png"] forState:UIControlStateSelected];
    UIButton *likebutton = [MyFactory creatButton:nil highlighted:@"likeIcon.png"];
    [likebutton addTarget:self action:@selector(selectLike:) forControlEvents:UIControlEventTouchUpInside];
    likebutton.frame = CGRectMake(8, 0, 34,44);
    [cell.contentView addSubview:likebutton];

    likebutton.tag =  (indexPath.section+1)*1000+indexPath.row;
    if([charater.isLike boolValue])
    {
        likebutton.selected = YES;
    }
    [charater release];
    return cell;
}



-(void)selectLike:(UIButton*)button
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:button.tag%1000 inSection:button.tag/1000-1];
//    Song *song = [[self.dataSoure objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

    MuicSong *song = [[self.dataSoure objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];
//
//    if(button.selected==NO)
//    {
//        if([self.songPlayController.songdata addSongInLikeSong:song])
//        {
//            button.selected = YES;
//        }
//        
//    }else{
//        NSString *alertMessage = [NSString stringWithFormat:@"不在收藏歌曲:%@",song.songName];
//        BlockUIAlertView *alert = [[BlockUIAlertView alloc]initWithTitle:@"提示" message: alertMessage cancelButtonTitle:@"取消" otherButtonTitles:@"好" buttonBlock:^(NSInteger index){
//            if (index==0) {
//                NSLog(@"继续收藏歌曲");
//            }if (index==1) {
//                if ( [self.songPlayController.songdata removeSongInLikeSong:song])
//                button.selected = NO;
//            }
//        }];
//        [alert show];
////        [alert release];
//    }
    
    
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
                if ( [self.songPlayController.songdata removeSongFromIsLikeSong:song])
                    button.selected = NO;
            }
        }];
        [alert show];
        //        [alert release];
    }

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
    self.songPlayController.songdata.playSongMenu = [[self.songPlayController.songdata getAllSongData] copy];

}

-(void)dealloc
{
    [_songPlayController release];
    [_dataSoure release];
    [_tableView release];
    [_toolView release];
    [super dealloc];
}
@end
