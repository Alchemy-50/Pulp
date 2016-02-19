//
//  EventsDigester.m
//  Pulp
//
//  Created by Josh Klobe on 2/19/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "EventsDigester.h"
#import "EventKitManager.h"
#import "GroupDataManager.h"
#import "EventConverter.h"

@implementation EventsDigester


+(void)run
{
    
    unsigned flags = NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitMonth;
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    

    NSDateComponents *startDateTimeComponents = [calendar components:flags fromDate:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * 365 * -1]];
    NSDateComponents *endDateTimeComponents = [calendar components:flags fromDate:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * 365 * 1]];
    
    
    NSDateComponents *startDateComponents = [[NSDateComponents alloc] init];
    [startDateComponents setDay:[startDateTimeComponents day] + 0];
    [startDateComponents setMonth:[startDateTimeComponents month]];
    [startDateComponents setYear:[startDateTimeComponents year]];
    [startDateComponents setHour:0];
    [startDateComponents setMinute:1];
    NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:startDateComponents];
    
    NSDateComponents *endDateComponents = [[NSDateComponents alloc] init];
    [endDateComponents setDay:[endDateTimeComponents day] + 0+ 1];
    [endDateComponents setMonth:[endDateTimeComponents month]];
    [endDateComponents setYear:[endDateTimeComponents year]];
    [endDateComponents setHour:0];
    [endDateComponents setMinute:1];
    NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endDateComponents];
    
    
    
    NSArray *allEvents = [[EventKitManager sharedManager] getEventsForStartDate:startDate forEndDate:endDate withCalendars:[[GroupDataManager sharedManager] getSelectedCalendars]];

    NSLog(@"allEvents: %@", allEvents);
    
    
//    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    for (int i = 0; i < [allEvents count]; i++)
    {
            if (i == 0)
            {
                NSDictionary *dict = [EventConverter getEventDictionaryFromEvent:[allEvents objectAtIndex:i]];
                NSLog(@"dict: %@", dict);
            }
    }
    
}
@end
