//
//  CalendarEvent.m
//  Calendar
//
//  Created by jay canty on 1/20/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "CalendarEvent.h"
#import "DateFormatManager.h"

@interface CalendarEvent ()
@property (nonatomic, retain) id ekObject;
@end

@implementation CalendarEvent



- (CalendarEvent *) init
{
    self = [self initWithEKEvent:nil];
    return self;
}


- (CalendarEvent *) initWithEKEvent:(id)theEKEvent
{
    self = [super init];
    return self;
}




- (id) getTheEKEvent
{

        return nil;
}


- (CalendarRepresentation *)getCalendar
{
    CalendarRepresentation *calendarRepresentation = [[CalendarRepresentation alloc] initWithEventObject:self.ekObject];
    
    return calendarRepresentation;
}



- (NSDate *) getStartDate
{    
    return nil;
    
}

- (NSDate *) getEndDate
{
    return nil;
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
    
    return retAr;
}

- (NSString *)getTheEventIdentifier
{
    NSString *retString = @"";
    
    
    return retString;
}

-(NSString *)getTheTitle
{
    NSString *retString = @"";
    
    
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
