//
//  SkinViewController.m
//  Musci2
//
//  Created by sky on 14/7/26.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "SkinViewController.h"
#import "BaseViewController.h"

@interface SkinViewController ()
{
    NSArray *_dataSource;
    NSIndexPath *beforePath;
}
@end

@implementation SkinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.titleView = [self setLabelTitle:@"皮肤管理"];
    
    //获得当前所有主题的名称
    _dataSource = [[ThemeManager shareInstance].themesConfig allKeys];
    [_dataSource retain];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
    self.navigationItem.leftBarButtonItem = backButton;
    [backButton release];
    
}

-(void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *indetifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indetifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indetifier];
        [cell autorelease];
    }
    cell.textLabel.text = _dataSource[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if ([_dataSource[indexPath.row] isEqualToString:[ThemeManager shareInstance].themeName]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        beforePath = [indexPath copy];
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;

    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //取消之前的选择标志
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UITableViewCell *beforeCell = [tableView cellForRowAtIndexPath:beforePath];
    beforeCell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    beforePath = [indexPath copy];
    
    //获得选中的主题
    NSString *skinName = [_dataSource objectAtIndex:indexPath.row];
    [ThemeManager shareInstance].themeName = skinName;
    //发送主题通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeDidChangeNotification object:skinName];
    //讲但前主题缓存到本地
    [[NSUserDefaults standardUserDefaults]setObject:skinName forKey:kThemeName];
    [NSUserDefaults standardUserDefaults];
}

- (void)dealloc {
    [_dataSource release];
    [beforePath release];
    [_tableView release];
    [super dealloc];
}
@end
