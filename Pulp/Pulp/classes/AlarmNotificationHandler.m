//
//  AlarmNotificationHandler.m
//  Calendar
//
//  Created by Josh Klobe on 7/12/14.
//
//

#import "AlarmNotificationHandler.h"
#import "EventKitManager.h"
#import "SettingsManager.h"
#import <UIKit/UIKit.h>

@implementation AlarmNotificationHandler


+(void)runScheduler
{    
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    NSDate *startDate = [NSDate date];
    NSDate *endDate = [startDate dateByAddingTimeInterval:60*60*24*30];
    
    NSArray *allEvents = [[EventKitManager sharedManager] getEventsForStartDate:startDate forEndDate:endDate withCalendars:[[EventKitManager sharedManager] getEKCalendars:NO]];
    
    for (int i = 0; i < [allEvents count]; i++)
    {
        EKEvent *calEvent = [allEvents objectAtIndex:i];
        [self processEventWithCalEvent:calEvent];
        
        
        
    }
}

+(void)processEventWithCalEvent:(EKEvent *)calEvent
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([calEvent hasAlarms])
    {
        NSMutableArray *scheduledLocalNotificationsArray = [NSMutableArray arrayWithCapacity:0];
                
        NSDateFormatter *timeFormat = [[NSDateFormatter alloc] init];
        
        if ([[SettingsManager getSharedSettingsManager] startTimeInTwentyFour])
            [timeFormat setDateFormat:@"HH:mm"];
        else
            [timeFormat setDateFormat:@"h:mm a"];
        
        for (int i = 0; i < [calEvent.alarms count]; i++)
        {
            EKAlarm *theAlarm = [calEvent.alarms objectAtIndex:i];
            
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
            [dict setObject:calEvent.calendar.calendarIdentifier forKey:@"calendarIdentifier"];
            [dict setObject:calEvent.eventIdentifier forKey:@"eventIdentifier"];
            
            UILocalNotification *localNotification = [[UILocalNotification alloc] init];
            localNotification.fireDate = [calEvent.startDate dateByAddingTimeInterval:theAlarm.relativeOffset];
            localNotification.alertBody = [NSString stringWithFormat:@"%@ @ %@", calEvent.title, [timeFormat stringFromDate:calEvent.startDate]];
            
            localNotification.userInfo = [NSDictionary dictionaryWithDictionary:dict];
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
            
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:localNotification];
            [scheduledLocalNotificationsArray addObject:data];
        }
        
        
        [defaults setObject:scheduledLocalNotificationsArray forKey:calEvent.eventIdentifier];
        [defaults synchronize];
        
    }
}
@end
