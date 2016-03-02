//
//  AppDelegate.m
//  Pulp_TV
//
//  Created by Josh Klobe on 3/2/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "AppDelegate.h"
#import "Utils.h"
#import "FullCalendarViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.locationDelegateRespondeesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    self.mainViewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    self.mainViewController.view.frame = CGRectMake(0, 0, [Utils getScreenWidth], [Utils getScreenHeight]);
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:self.mainViewController];
    [self.window makeKeyAndVisible];
    
   
    return YES;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"!!!!!");
    /*
     CKNotification *ckNotification = [CKNotification notificationFromRemoteNotificationDictionary:userInfo];
     if (ckNotification.notificationType == CKNotificationTypeQuery) {
     CKQueryNotification *queryNotification = ckNotification;
     CKRecordID *recordID = [queryNotification recordID];
     NSLog(@"recordID: %@", recordID);
     // ...
     }
     */
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    
}


-(void)appDidEnterForeground
{
    NSLog(@"do implement appDidEnterForeground");
    [[FullCalendarViewController sharedContainerViewController] setDailyBorderWithDate:[NSDate date]];
    [[MainViewController sharedMainViewController] dataChanged];
    //    self.appController.dailyViewController.hasRunWeather = NO;
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
}


-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}




@end
