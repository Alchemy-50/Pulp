//
//  AppDelegate.m
//  PulpTV
//
//  Created by Josh Klobe on 2/26/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "AppDelegate.h"
#import "GroupDiskManager.h"
#import "EventKitManager.h"
#import "EventStoreChangeThread.h"
#import "PositionUpdatedRespondeeProtocol.h"
#import "AlarmNotificationHandler.h"
#import "Utils.h"
#import "FullCalendarViewController.h"
#import <CloudKit/CloudKit.h>



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
    
    
    [self beginLocationManager];
    [self runBackgroundTasks];
    

    
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
    
    NSLog(@"applicationWillEnterForeground");
    [self performSelector:@selector(appDidEnterForeground) withObject:nil afterDelay:1.5];
    [self runBackgroundTasks];
    
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


-(void)beginLocationManager
{
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    }



- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    self.locationHasSucceeded = YES;
    
    self.latestLocation = newLocation;
    
    for (int i = 0; i < [self.locationDelegateRespondeesArray count]; i++)
    {
        id respondee = [self.locationDelegateRespondeesArray objectAtIndex:i];
        if ([respondee conformsToProtocol:@protocol(PositionUpdatedRespondeeProtocol)])
            [respondee positionUpdatedWithLocation:self.latestLocation];
    }
    
}


-(void)registerAsLocationUpdateRespondee:(id)theRespondee
{
    [self.locationDelegateRespondeesArray addObject:theRespondee];
    if (self.locationHasSucceeded)
        if ([theRespondee conformsToProtocol:@protocol(PositionUpdatedRespondeeProtocol)])
            [theRespondee positionUpdatedWithLocation:self.latestLocation];
}

-(void)unregisterAsLocationUpdateRespondee:(id)theRespondee
{
    [self.locationDelegateRespondeesArray removeObject:theRespondee];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
}

-(void)launchExternalURLString:(NSString *)theURLString
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theURLString]];
}

-(void)runBackgroundTasks
{
    
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [AlarmNotificationHandler runScheduler];
        
        dispatch_async( dispatch_get_main_queue(), ^{
            // Add code here to update the UI/send notifications based on the
            // results of the background processing
        });
    });
}




- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    /*
     UIImage *theImage = [self imageFromUIView:[self getViewWithDictionary:userInfo]];
     NSData *theImageData = UIImagePNGRepresentation(theImage);
     
     NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
     [dict setObject:theImageData forKey:@"theImageData"];
     [dict setObject:@"labelText4" forKey:@"theLabelKey"];
     
     
     reply(dict);
     */
    
}


- (UIImage *) imageFromUIView:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/*
 -(UIView *)getViewWithDictionary:(NSDictionary *)dict
 {
 UIView *retView = [[UIView alloc] initWithFrame:CGRectMake(0,0,136, 141)];
 retView.backgroundColor = [UIColor whiteColor];
 
 NSDateFormatter *df = [[NSDateFormatter alloc] init];
 [df setDateFormat:@"EEEE"];
 
 int numDays = 7;
 
 if (dict != nil)
 if ([[dict objectForKey:@"requestType"] compare:@"glanceCall"] == NSOrderedSame)
 numDays = 1;
 
 
 for (int i = 0; i < numDays; i++)
 {
 
 unsigned flags = NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitMonth;
 NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
 [calendar setTimeZone:[NSTimeZone localTimeZone]];
 NSDateComponents* todayDateTimeComponents = [calendar components:flags fromDate:[NSDate date]];
 
 NSDateComponents *startDateComponents = [[NSDateComponents alloc] init];
 [startDateComponents setDay:[todayDateTimeComponents day] + i];
 [startDateComponents setMonth:[todayDateTimeComponents month]];
 [startDateComponents setYear:[todayDateTimeComponents year]];
 [startDateComponents setHour:0];
 [startDateComponents setMinute:1];
 NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:startDateComponents];
 
 NSDateComponents *endDateComponents = [[NSDateComponents alloc] init];
 [endDateComponents setDay:[todayDateTimeComponents day] + i + 1];
 [endDateComponents setMonth:[todayDateTimeComponents month]];
 [endDateComponents setYear:[todayDateTimeComponents year]];
 [endDateComponents setHour:0];
 [endDateComponents setMinute:1];
 NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endDateComponents];
 
 
 float width = retView.frame.size.width / numDays;
 UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(width * i, 0, width, 15)];
 theLabel.backgroundColor = [UIColor clearColor];
 if (numDays == 1)
 theLabel.text = [df stringFromDate:startDate];
 else
 theLabel.text = [[df stringFromDate:startDate] substringToIndex:1];
 
 theLabel.font = [UIFont systemFontOfSize:theLabel.frame.size.height - 1];
 theLabel.textAlignment = NSTextAlignmentCenter;
 [retView addSubview:theLabel];
 
 
 NSArray *allEvents = [[EventKitManager sharedManager] getEventsForStartDate:startDate forEndDate:endDate withCalendars:[[EventKitManager sharedManager] getEKCalendars:YES]];
 for (int j = 0; j < [allEvents count]; j++)
 {
 EKEvent *calendarEKEvent = [allEvents objectAtIndex:j];
 EKCalendar *calendarEKEventCalendar = calendarEKEvent.calendar;
 
 UIColor *eventColor = [UIColor colorWithCGColor:calendarEKEventCalendar.CGColor];
 UIView *eventRepresentationView = [[UIView alloc] initWithFrame:CGRectMake(theLabel.frame.origin.x, theLabel.frame.size.height + j * 10, width, 9)];
 eventRepresentationView.backgroundColor = eventColor;
 [retView addSubview:eventRepresentationView];
 }
 
 
 }
 return retView;
 }
 
 */


@end
