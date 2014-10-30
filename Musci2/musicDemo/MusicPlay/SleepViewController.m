//
//  SleepViewController.m
//  Musci2
//
//  Created by sky on 14/7/26.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "SleepViewController.h"

static SleepViewController *sleepView = nil;

@interface SleepViewController ()

{
    NSArray *_dataSource;
    NSIndexPath *beforPath;
    NSTimer *_timer;
}
@end


//建立单例
@implementation SleepViewController

@synthesize sleepTimer;
+ (id)shareInstance
{
    if (sleepView==nil) {
        @synchronized(self){
        sleepView = [[SleepViewController alloc]init];
        }
    }
    return sleepView;
}


+ (id)allocWithZone:(struct _NSZone *)zone
{
    if (sleepView==nil) {
        @synchronized(self){
            
            sleepView = [super allocWithZone:zone];
        }
    }
    return sleepView ;
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



- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获得音乐控制器
    _songPlayController = [SongPlayController shareSongPlayController];
    
    sleepTimer = INT16_MAX;
    self.sleepTimerStart = NO;
    _count = 0;
    self.navigationItem.titleView  = [self setLabelTitle:@"睡眠时间"];
    _dataSource =@[@"关闭",@"10分钟",@"20分钟",@"30分钟",@"60分钟",@"90分钟",@"自定义"];
    
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipAciton)];
    swipeGesture.direction = UISwipeGestureRecognizerDirectionDown;
    [self.tableView addGestureRecognizer:swipeGesture];
    [swipeGesture release];
    
    //设置头视图
    [self setTabelViewHead];
}

//设置头视图
-(void)setTabelViewHead
{
    UILabel *head = [MyFactory creatLabel:kTableVIewCellText];
    head.text = @"记时结束后，将暂停播放歌曲";
    head.frame =CGRectMake(0, 0, 320, 44);
    head.textAlignment = NSTextAlignmentCenter;
    head.backgroundColor = [UIColor clearColor];
    head.font = [UIFont systemFontOfSize:15];
    head.tag = 1000;
    [self.tableView setTableHeaderView:head];
    
}


//向下轻扫退出睡眠时间界面
-(void)swipAciton
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indefiert = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indefiert];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indefiert];
        [cell autorelease];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    if (indexPath.row==0) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        beforPath = [indexPath copy];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *beforCell = [tableView cellForRowAtIndexPath:beforPath];
    beforCell.accessoryType = UITableViewCellAccessoryNone;
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    beforPath = [indexPath copy];
    int a[6] = {INT16_MAX,10,20,30,60,90};
    if (indexPath.row<6&&indexPath.row>0) {
        self.sleepTimer = a[indexPath.row];
        if (self.sleepTimerStart) {
            [self stopSleepTimer];
        }
          [self beginSleepTimer];
    }
    if (indexPath.row==0) {
        if (self.sleepTimerStart) {
            [self stopSleepTimer];
            UILabel *label = (UILabel*)[self.tableView viewWithTag:1000];
            label.text =  @"记时结束后，将暂停播放歌曲";
        }
    }
    
    if (indexPath.row==6) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        DLDataPicker *pickView = [[DLDataPicker alloc]initWithDelegate:self dataSource:self];
        [pickView setOringinY:self.view.frame.size.height - pickView.frame.size.height];
        [pickView showInView:self.view animated:YES];
        [pickView release];
    }
}




#pragma --DLDataPickerDatasource
- (NSInteger)numberOfComponentsInDLDataPicker:(DLDataPicker *)dLDataPicker
{
    return 2;
}

- (NSInteger)dLDataPicker:(DLDataPicker *)dLDataPicker numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return 24;
    }else return 60;
}

- (NSString *)dLDataPicker:(DLDataPicker *)dLDataPicker titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component==0) {
        return [NSString stringWithFormat:@"%ld小时",(long)row];
    }
    else return [NSString stringWithFormat:@"%ld分钟",(long)row];
}

- (void)dLDataPicker:(DLDataPicker *)dLDataPicker didFinishWithResult:(NSArray *)resultArray
{
    int a[2];
    int i=0;
    for (NSIndexPath *indexPath in resultArray) {
        a[i++] = indexPath.rowIndex;
    }
    self.sleepTimer = a[0]*60+a[1];
    if (self.sleepTimerStart) {
        [self stopSleepTimer];
    }
    [self beginSleepTimer];
}

- (void)dLDataPickerDidCancel:(DLDataPicker *)dLDataPicker
{
    
}


//开启睡眠计时器
-(void)beginSleepTimer
{
    self.sleepTimerStart = YES;
    if (_timer==nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(SongTimerAction:) userInfo:self repeats:YES];
    }
    else{
        [_timer setFireDate:[NSDate distantPast]];
    }
}



-(void)SongTimerAction:(NSTimer*)timer
{
    _count++;
    if(_count>self.sleepTimer*60)
    {
        [_songPlayController stopSong];
        [_timer invalidate];
    }
    
    NSInteger time = self.sleepTimer*60-_count;
    NSString *timeString = [NSString stringWithFormat:@"%ld分%d秒后,将暂停播放歌曲",(long)time/60,time%60];
    
    UILabel *label = (UILabel *)[self.tableView viewWithTag:1000];
    label.text = timeString;
}

-(void)stopSleepTimer
{
    _count = 0;
    [_timer setFireDate:[NSDate distantFuture]];
    self.sleepTimerStart = NO;
}



- (void)dealloc {
    [_timer invalidate];
    _timer = nil;
    [_timer release];
    [beforPath release];
    [_songPlayController release];
    [_tableView release];
    [super dealloc];
}
@end
