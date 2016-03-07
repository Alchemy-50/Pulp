//
//  CalendarEvent.h
//  Calendar
//
//  Created by jay canty on 1/20/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarRepresentation.h"


@interface CalendarEvent : NSObject
    


- (CalendarEvent *) init;
- (CalendarEvent *) initWithDictionary:(id)theEventDictionary;
- (CalendarRepresentation *)getCalendar;

- (NSDate *) getStartDate;
- (NSDate *) getEndDate;
- (BOOL) hasAlarms;
- (NSArray *) getTheAlarms;
- (NSString *) getTheEventIdentifier;
- (NSString *) getTheTitle;
- (BOOL) isAllDay;
- (NSString *) getTheLocation;
@end
