//
//  CalendarEvent.h
//  Calendar
//
//  Created by jay canty on 1/20/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarRepresentation.h"

#import <EventKit/EventKit.h>
@interface CalendarEvent : NSObject
    


- (CalendarEvent *) init;
- (CalendarEvent *) initWithEKEvent:(EKEvent *)ekEvent;
- (EKEvent *) getEkEvent;
- (CalendarRepresentation *)getCalendar;

- (NSDate *) getStartDate;
- (NSDate *) getEndDate;




@end
