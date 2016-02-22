//
//  AppDelegate.m
//  Pulp
//
//  Created by Josh Klobe on 2/15/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "GroupDataManager.h"
#import "GroupDiskManager.h"
#import "EventKitManager.h"
#import "EventStoreChangeThread.h"
#import "PositionUpdatedRespondeeProtocol.h"
#import "ContentContainerViewController.h"
#import "AlarmNotificationHandler.h"
#import "Utils.h"
#import <Contacts/Contacts.h>


#define USER_LAST_ENTERED_APP @"USEfR_LASfT_ENTEfRED_APP2"

@interface AppDelegate ()

@end

@implementation AppDelegate

@synthesize window = _window, storeNotificationObserver;
@synthesize currentSelectedCalendar;
@synthesize locationManager;
@synthesize latestLocation;
@synthesize locationDelegateRespondeesArray;
@synthesize locationHasSucceeded;


+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    application.statusBarHidden = YES;
    
    self.locationDelegateRespondeesArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    
    self.mainViewController = [[MainViewController alloc] initWithNibName:nil bundle:nil];
    self.mainViewController.view.frame = CGRectMake(0, 0, [Utils getScreenWidth], [Utils getScreenHeight]);
    
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window setRootViewController:self.mainViewController];
    [self.window makeKeyAndVisible];
    
    
    [self beginLocationManager];
    [self runBackgroundTasks];
    
    [Fabric with:@[[Crashlytics class]]];
    
    
    
    
    return YES;
}



- (void)applicationWillResignActive:(UIApplication *)application
{
    
}


-(void)appDidEnterForeground
{
    NSLog(@"do implement appDidEnterForeground");
    [[ContentContainerViewController sharedContainerViewController] setDailyBorderWithDate:[NSDate date]];
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
    if (storeNotificationObserver == nil)
    {
        storeNotificationObserver = [[EventStoreChangeThread alloc] init];
        [storeNotificationObserver start];
    }
    
    
    NSDate *now = [NSDate date];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:USER_LAST_ENTERED_APP] != nil)
    {
        NSDate *then = [defaults objectForKey:USER_LAST_ENTERED_APP];
        NSTimeInterval difference = [now timeIntervalSinceDate:then];
        
        long seconds = lroundf(difference); // Modulo (%) operator below needs int or long
        int hour = floor(seconds / 3600);
        
        if (hour >= 5)
        {
            NSLog(@"deal with active here");
        }
        
    }
    
    [defaults setObject:now forKey:USER_LAST_ENTERED_APP];
    [defaults synchronize];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"didReceiveLocalNotification, handle implementation");
    
    /*
     NSLog(@"notification!: %@", notification);
     NSLog(@"notification.userInfo: %@", notification.userInfo);
     
     NSString *eventIdentifier = [notification.userInfo objectForKey:@"eventIdentifier"];
     NSLog(@"eventIdentifier!: %@", eventIdentifier);
     if (eventIdentifier)
     {
     EKEvent *referenceEvent = [[EventKitManager sharedManager] getEKEventWithIdentifier:eventIdentifier];
     NSLog(@"referenceEvent: %@", referenceEvent);
     if (referenceEvent != nil)
     [[FlowControlHandler sharedFlowControlHandler] dailyEventSelected:referenceEvent];
     }
     */
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
    if (self.locationManager == nil)
    {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate=self;
        self.locationManager.desiredAccuracy=kCLLocationAccuracyBest;
        self.locationManager.distanceFilter=kCLDistanceFilterNone;
        //        [self.locationManager startUpdatingLocation];
        
    }
    
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            
            [self.locationManager requestAlwaysAuthorization];
            break;
            
        case kCLAuthorizationStatusRestricted:
            break;
            
        case kCLAuthorizationStatusDenied:
            break;
            
        default:
            [self.locationManager startUpdatingLocation];
            break;
    }
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
        
        
        NSArray *allEvents = [[EventKitManager sharedManager] getEventsForStartDate:startDate forEndDate:endDate withCalendars:[[GroupDataManager sharedManager] getSelectedCalendars]];
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


- (void)application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void(^)(NSDictionary *replyInfo))reply
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    UIImage *theImage = [self imageFromUIView:[self getViewWithDictionary:userInfo]];
    NSData *theImageData = UIImagePNGRepresentation(theImage);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:theImageData forKey:@"theImageData"];
    [dict setObject:@"labelText4" forKey:@"theLabelKey"];
    
    
    reply(dict);
    
}


- (UIImage *) imageFromUIView:(UIView*)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




@end
