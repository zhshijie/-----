//
//  SingerViewController.m
//  MusicPlay
//
//  Created by sky on 14/7/23.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "SingerViewController.h"
#import "SingerSongsViewController.h"
#import "LocationViewController.h"

@interface SingerViewController ()
{
    NSIndexPath *_select;
}
@end

@implementation SingerViewController


-(void)setDataSoure:(NSMutableArray *)dataSoure
{
    if (_dataSoure!=nil) {
        _dataSoure = nil;
    }
    _dataSoure = [dataSoure mutableCopy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置view的背景
    [self setViewBackground];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.dataSoure = [[[NSMutableArray alloc]initWithCapacity:1] autorelease];
    self.songPlayController = [SongPlayController shareSongPlayController];

    
    //获得数据源
    self.dataSoure = [self _getDataSource:3] ;
    [self.dataSoure retain];
    //对数据源进行排序
    [self randDataSoure:self.dataSoure];
    
    [self tableViewForHeader];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.tableView deselectRowAtIndexPath:_select animated:NO];
}

//获得数据源
-(NSMutableArray*)_getDataSource:(NSInteger )capacity
{
    NSLog(@"_getDataSource");
    NSMutableArray *dataSourceTemp = [NSMutableArray arrayWithCapacity:capacity];
    dataSourceTemp = [_songPlayController.songdata getAllSongData];
    
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
    NSLog(@"%ld",(long)sectionCount);
    
    for (int i=0; i<sectionCount; i++) {
        [sectionArrays addObject:[NSMutableArray arrayWithCapacity:0]];
    }
    
    NSLog(@"%@",dataSourceTemp);
    
    for (int i=0;dataSourceTemp.count; ) {
         MuicSong  *song = dataSourceTemp[i];
        NSInteger sect = [theCollation sectionForObject:song collationStringSelector:@selector(singerName)];
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:1];
        for (int j=0; j<dataSourceTemp.count;) {
            MuicSong *nextSong = dataSourceTemp[j];
            NSLog(@"%@",nextSong);
            if ([nextSong.singerName isEqualToString: song.singerName]) {
                [array addObject:nextSong];
                [dataSourceTemp removeObjectAtIndex:j];
                j=0;
            }
            else{
                j++;
            }
        }
        [[sectionArrays objectAtIndex:sect] addObject:array];
    }
    
    
    
    //将section中的数据追加到表格用数组中
    self.dataSoure = [NSMutableArray arrayWithCapacity:sectionCount];
    for (NSMutableArray *sectionArray in sectionArrays) {
        [self.dataSoure addObject:sectionArray];
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
//    NSLog(@"numberOfSectionsInTableView");
    return [self.dataSoure count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    NSLog(@"numberOfRowsInSection==%d",[[_dataSoure objectAtIndex:section]count]);
    return [[self.dataSoure objectAtIndex:section]count];
    //    return [_dataSoure count];
}
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([[self.dataSoure objectAtIndex:section] count]) {
        return [[[UILocalizedIndexedCollation currentCollation]sectionTitles]objectAtIndex:section];;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"cellForRowAtIndexPath");
    
    NSString *identifier = @"cellForRowAtIndexPath";
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
    
    NSArray *array= [[self.dataSoure objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    MuicSong *charater = [array objectAtIndex:0];
//    cell.textLabel.text = charater.singerName;
    UILabel *cellLabel =(UILabel *)[cell.contentView viewWithTag:2013];
    cellLabel.text = charater.singerName;
    
    NSString *numOfSongs = [NSString stringWithFormat:@"%lu",(unsigned long)[[[self.dataSoure objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] count]];
    cell.detailTextLabel.text = numOfSongs;
    cell.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.7];
    
    NSString *imageName = nil;
    if (charater.singerImage) {
        imageName = charater.singerImage;
    }
    else imageName = @"default.png";
    UIImageView *singerPhoto = [MyFactory creatImageView:imageName];
    cell.imageView.image = singerPhoto.image;
                            
    [charater release];
    return cell;
}

- (UIViewController *)viewController
{
    for (UIView* next = self.view.superview; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
//

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _select = indexPath;
    
    //获得该歌手的所有歌曲
    NSMutableArray *array = [[self.dataSoure objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    [array retain];
    //获得该歌手的姓名
    UILabel * label = (UILabel *)[[tableView cellForRowAtIndexPath:indexPath].contentView viewWithTag:2013];
    NSString *Name = label.text;
    [Name retain];
    SingerSongsViewController *singerSong = [[SingerSongsViewController alloc]initwithSong:array singerName:Name];
    
    [[self viewController].navigationController pushViewController:singerSong animated:YES];
    [array release];
    [singerSong release];
    [Name release];
}


- (void)dealloc {
    [_songPlayController release];
    [_dataSoure release];
    [_tableView release];
    [_select release];
    [super dealloc];
}
@end
