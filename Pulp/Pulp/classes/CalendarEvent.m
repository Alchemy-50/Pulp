//
//  CalendarEvent.m
//  Calendar
//
//  Created by jay canty on 1/20/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "CalendarEvent.h"
#import <EventKit/EventKit.h>
#import "DateFormatManager.h"

@interface CalendarEvent ()
@property (nonatomic, retain) EKEvent *ekObject;
@end

@implementation CalendarEvent



- (CalendarEvent *) init
{
    [self initWithEKEvent:nil];
    return self;
}


- (CalendarEvent *) initWithEKEvent:(EKEvent *)event
{
    self = [super init];
    self.ekObject = event;
    return self;
}




- (EKEvent *) getEkEvent
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


@end
