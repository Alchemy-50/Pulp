//
//  CalendarEvent.m
//  Calendar
//
//  Created by jay canty on 1/20/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "CalendarEvent.h"
#import "DateFormatManager.h"
#import "EventKitManager.h"

@interface CalendarEvent ()
@property (nonatomic, retain) NSDictionary *eventDictionary;

@end

@implementation CalendarEvent


- (CalendarEvent *) init
{
    self = [self init];
    return self;
}



-(CalendarEvent *)initWithDictionary:(id)theEventDictionary
{
    self = [super init];
    self.eventDictionary = [[NSDictionary alloc] initWithDictionary:theEventDictionary];
    return self;
}



- (CalendarRepresentation *)getCalendar
{
    
    NSDictionary *dict = [[EventKitManager sharedManager] getCalendarWithIdentifier:[self getEventCalendarIdentifier]];
 
    CalendarRepresentation *calendarRepresentation = [[CalendarRepresentation alloc] initWithDictionary:dict];
    return calendarRepresentation;
    
}

/*
allDay = 0;
calendarItemExternalIdentifier = "6052D158-DC8D-469F-9B19-76B427664410";
calendarItemIdentifier = "2E53ED3D-E096-43EF-9630-A4773C1374D9";
location = "";
*/




-(NSString *)getEventCalendarIdentifier
{
    return [self.eventDictionary objectForKey:@"eventCalendarIdentifier"];
}


- (NSDate *) getStartDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss ZZZ"];
    NSDate *theDate = [dateFormatter dateFromString:[self.eventDictionary objectForKey:@"startDate"]];
    return theDate;
}


- (NSDate *) getEndDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss ZZZ"];
    NSDate *theDate = [dateFormatter dateFromString:[self.eventDictionary objectForKey:@"endDate"]];
    return theDate;
}


- (BOOL) hasAlarms
{
    BOOL retVal = NO;
    
    
    return retVal;
}

- (NSArray *)getTheAlarms
{
    NSArray *retAr = nil;
    
    return retAr;
}

- (NSString *)getTheEventIdentifier
{
    NSString *retString = [self.eventDictionary objectForKey:@"eventIdentifier"];
    return retString;
}

-(NSString *)getTheTitle
{
    NSString *retString = [self.eventDictionary objectForKey:@"title"];
    
    
    return retString;
}

- (BOOL)isAllDay
{
    BOOL ret = NO;

    return ret;
}

- (NSString *)getTheLocation
{
    NSString *location = @"";
        
    return location;
}

@end
