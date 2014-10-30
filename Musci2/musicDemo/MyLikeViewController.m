//
//  MyLikeViewController.m
//  musicDemo
//
//  Created by sky on 14/7/24.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "MyLikeViewController.h"
#import "BlockUIAlertView.h"
#import "SongPlayView.h"
#import "LocationViewController.h"
#import "SongData.h"

@interface MyLikeViewController ()

{
    SongData *_songData;
}
@end

@implementation MyLikeViewController

@synthesize songPlayController;
@synthesize toolView;


-(id)init{
    if (self = [super init]) {
            }
    return self;
}


-(void)setDataSoure:(NSMutableArray *)dataSoure
{
    if (_dataSoure!=nil) {
        _dataSoure = nil;
    }
    _dataSoure = [dataSoure mutableCopy];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.toolView updateSongPlayView];
    self.songPlayController.block = ^(int a)
    {
        [self.toolView updateSongPlayView];
    };
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.title = @"我的最爱";
    [self setViewBackground];
    
    self.navigationItem.titleView = [self setLabelTitle:@"我的最爱"];
    
    
    self.tableView = [[[UITableView alloc]initWithFrame:self.view.frame] autorelease];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:self.tableView];
    
    self.songPlayController = [SongPlayController shareSongPlayController];
    
    
    //获得数据源
    _songData = [SongData shareSingleton];
    self.dataSoure = [[_songData getIsLikeSongData] copy];

    //对数据源进行排序
    [self randDataSoure:_dataSoure];
    
    self.toolView= [[[SongPlayView alloc]init] autorelease];
    toolView.frame = CGRectMake(0, ScreenHeight-59, 320, 59);
    toolView.backgroundColor = [UIColor clearColor];
    toolView.tag = INT16_MAX;
    [self.view addSubview:self.toolView];

    // Do any additional setup after loading the view from its nib.
    
//    [self tableViewForHeader];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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



////设置头视图
//-(void)tableViewForHeader
//{
//    BaseView *headView = [[BaseView alloc]init];
//    headView.frame = CGRectMake(0, 0, 320, 64);
//    headView.backgroundColor = [UIColor clearColor];
//    [self.tableView setTableHeaderView:headView];
//    [headView release];
//}

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
    //    NSLog(@"%@",self.dataSoure);
    MuicSong *charater= [[self.dataSoure objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    //        NSLog(@"charater--%@",charater);
//    cell.textLabel.text = charater.songName;
    UILabel *cellLabel =(UILabel *)[cell.contentView viewWithTag:2013];
    cellLabel.text = charater.songName;
    cell.detailTextLabel.text = charater.singerName;
    
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
    
    cell.imageView.frame = CGRectMake(0, 0, 44, 44);
    cell.imageView.image = [UIImage imageNamed:@"unlike.png"];
    //    NSLog(@"cell.imageView.image----%@",cell.imageView.image);
    
//    UIButton *likebutton  =[UIButton buttonWithType:UIButtonTypeCustom];
//    [likebutton setImage:[UIImage imageNamed:@"likeIcon.png"] forState:UIControlStateSelected];
    UIButton *likebutton = [MyFactory creatButton:nil highlighted:@"likeIcon.png"];
    [likebutton addTarget:self action:@selector(selectLike:) forControlEvents:UIControlEventTouchUpInside];
    likebutton.frame = CGRectMake(8, 0, 34,44);
    [cell.contentView addSubview:likebutton];
    cell.contentMode =UIViewContentModeCenter;
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

    NSIndexPath *indexPath =[NSIndexPath indexPathForRow:button.tag%1000 inSection:button.tag/1000-1];
    MuicSong *song = [[self.dataSoure objectAtIndex:indexPath.section]objectAtIndex:indexPath.row];

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
                self.dataSoure = [self.songPlayController.songdata.isLikeSong copy];
                [self randDataSoure:self.dataSoure];
                [self.tableView reloadData];
            }
        }];
        [alert show];
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
    self.songPlayController.songdata.playSongMenu = [[self.songPlayController.songdata getIsLikeSongData] copy];
    
}

-(void)dealloc
{
    [_dataSoure release];
    [toolView release];
    [_tableView release];
    [_songData release];
    [songPlayController release];
    [super dealloc];
}


@end
