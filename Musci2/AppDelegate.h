//
//  AppDelegate.h
//  Musci2
//
//  Created by sky on 14/7/25.
//  Copyright (c) 2014年 sky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPRevealSideViewController.h"
#import "ThemeManager.h"
#import "SongViewController.h"
#import <CoreData/CoreData.h>


@interface AppDelegate : UIResponder <UIApplicationDelegate,PPRevealSideViewControllerDelegate,NSFetchedResultsControllerDelegate>
{
    int _count;
    UIBackgroundTaskIdentifier bgTask;
}
@property (strong, nonatomic) UIWindow *window;
@property(retain,nonatomic) PPRevealSideViewController *ppRevealSideViewController;


@property(strong,nonatomic)NSManagedObjectContext *managedObjectContext;
@property(strong,nonatomic)NSPersistentStoreCoordinator *persistentSotreCoordinator;
@property(strong,nonatomic)NSManagedObjectModel *managedObjectModel;

@end
