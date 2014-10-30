//
//  AppDelegate.m
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "BaseNavigationViewController.h"
#import "RightViewController.h"

@implementation AppDelegate


@synthesize managedObjectContext = _managedObjectContext;
@synthesize persistentSotreCoordinator = _persistentSotreCoordinator;
@synthesize managedObjectModel = _managedObjectModel;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    MainViewController *main = [[MainViewController alloc]init];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    BaseNavigationViewController *nav = [[BaseNavigationViewController alloc]initWithRootViewController:main];
    self.ppRevealSideViewController = [[PPRevealSideViewController alloc]initWithRootViewController:nav];
    _ppRevealSideViewController.delegate = self;
    self.window.rootViewController = _ppRevealSideViewController;
    
    PP_RELEASE(main);
    PP_RELEASE(nav);
    
    [self initWithMusic];
    
    //后台支持播放音频事件
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setActive:YES error:nil];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];

    
    
    //core data
    
    
    return YES;
}


-(void)applicationWillTerminate:(UIApplication *)application
{
    [self saveContext];
}

//保存数据
-(void)saveContext{
    NSError *error = nil;
    NSManagedObjectContext *managedObjcetContext  = self.managedObjectContext;
    if (managedObjcetContext != nil) {
        if ([managedObjcetContext hasChanges]&&![managedObjcetContext save:&error]) {
            NSLog(@"Unresovled error %@,%@",error,[error userInfo]);
            abort();
        }
    }
}

//初始化播放器
-(void)initWithMusic
{
    NSString  *themeName = [[NSUserDefaults standardUserDefaults]objectForKey:kThemeName];
    if (themeName.length == 0) {
        return;
    }
    [ThemeManager shareInstance].themeName = themeName;
}

/*
//实现后台播放
-(void)applicationDidEnterBackground:(UIApplication *)application
{
    //开启一个后台任务
    
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    [[[NSOperationQueue alloc]init]addOperationWithBlock:^{
        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction) userInfo:self repeats:YES];
        [[NSRunLoop currentRunLoop]run];
    }];
}

//当时间是500的倍数时，重新开启后退播放
-(void)timerAction
{
    _count++;
    if (_count%500==0) {
        UIApplication *application = [UIApplication sharedApplication];
        bgTask = [application beginBackgroundTaskWithExpirationHandler:^
                  {
                      [application endBackgroundTask:bgTask];
                      bgTask = UIBackgroundTaskInvalid;
                  }];
    }
}
*/


- (void)timerAction:(NSTimer *)timer {
    _count++;
    
    if (_count % 500 == 0) {
        UIApplication *application = [UIApplication sharedApplication];
        //结束旧的后台任务
        [application endBackgroundTask:bgTask];
        
        //开启一个新的后台
        bgTask = [application beginBackgroundTaskWithExpirationHandler:NULL];
    }
    NSLog(@"%d",_count);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    //开启一个后台任务
    bgTask = [application beginBackgroundTaskWithExpirationHandler:^{
        //结束指定的任务
        [application endBackgroundTask:bgTask];
    }];
    
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}


#pragma mark - core data


-(NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator * coordinator = [self persistentSotreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc]init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}


-(NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Musci2" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc]initWithContentsOfURL:modelURL];
    return _managedObjectModel;
    
}


-(NSPersistentStoreCoordinator *)persistentSotreCoordinator
{
    if (_persistentSotreCoordinator != nil) {
        return _persistentSotreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"MusciSongCoreData.sqlite"];
    
    NSError *error = nil;
    _persistentSotreCoordinator = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:self.managedObjectModel];
    if (![_persistentSotreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@,%@",error,[error userInfo]);
        abort();
    }
    return _persistentSotreCoordinator;
}


-(NSURL*)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
