//
//  CalendarEvent.m
//  Calendar
//
//  Created by jay canty on 1/20/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "CalendarEvent.h"
#import "DateFormatManager.h"
#import <EventKit/EventKit.h>

@interface CalendarEvent ()
@property (nonatomic, retain) EKEvent *ekObject;
@end

@implementation CalendarEvent



- (CalendarEvent *) init
{
    [self initWithEKEvent:nil];
    return self;
}


- (CalendarEvent *) initWithEKEvent:(id)theEKEvent
{
    self = [super init];
    self.ekObject = (EKEvent *)theEKEvent;
    return self;
}




- (id) getTheEKEvent
{
    if ([self.ekObject isKindOfClass:[EKEvent class]])       
         return (EKEvent *)self.ekObject;
    else if ([self.ekObject isKindOfClass:[NSArray class]])
        return [((NSMutableArray *)self.ekObject) objectAtIndex:0];
    else
        return nil;
}


- (CalendarRepresentation *)getCalendar
{
    CalendarRepresentation *calendarRepresentation = [[CalendarRepresentation alloc] initWithEventObject:self.ekObject];
    
    return calendarRepresentation;
}



- (NSDate *) getStartDate
{    
    return self.ekObject.startDate;
}

- (NSDate *) getEndDate
{
    return self.ekObject.endDate;
}

- (BOOL) hasAlarms
{
    BOOL retVal = NO;
    
    if (self.ekObject != nil)
        retVal = [self.ekObject hasAlarms];
    
    return retVal;
}

- (NSArray *)getTheAlarms
{
    NSArray *retAr = nil;
    
    if (self.ekObject != nil)
        retAr = [[NSArray alloc] initWithArray:self.ekObject.alarms];
    
    return retAr;
}

- (NSString *)getTheEventIdentifier
{
    NSString *retString = @"";
    
    if (self.ekObject != nil)
        retString = self.ekObject.eventIdentifier;
    
    return retString;
}

-(NSString *)getTheTitle
{
    NSString *retString = @"";
    
    if (self.ekObject != nil)
        retString = self.ekObject.title;

    return retString;
}

- (BOOL)isAllDay
{
    BOOL ret = NO;
    
    if (self.ekObject != nil)
        ret = self.ekObject.allDay;
    
    return ret;
}

- (NSString *)getTheLocation
{
    NSString *location = @"";
    
    if (self.ekObject != nil)
        location = self.ekObject.location;
    
    return location;
}

@end
