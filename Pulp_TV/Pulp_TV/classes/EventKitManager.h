//
//  EventKitManager.h
//  Calendar
//
//  Created by Jay Canty on 4/25/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarEvent.h"

#define STORED_CALENDARS_SHOWING_DICTIONARY_KEY @"STORED_CALEfNDARS_SHOWING_DICTIONARY_KEY"


@interface EventKitManager : NSObject {
}

+(EventKitManager *)sharedManager;
- (id) getNewEKCalendar;
- (id) getEKCalendarWithIdentifier:(NSString *)calId;
- (NSArray *) getEKCalendars:(BOOL)supressHiddenCalendars;
- (CalendarEvent *) getNewEKEvent;
- (id) getEKEventWithIdentifier:(NSString *)eventId;
- (id) getTheEventStore;
- (BOOL) saveCalendar:(id)calendar;
- (void) deleteCalendar:(id)calendar;
- (BOOL) createAndSaveCalendar:(id)calendar;
- (void) saveCalendarEvent:(id)calendarEvent;
- (void) deleteCalendarEvent:(id)event spanFutureEvents:(BOOL)span;
- (void) commit;
- (void) remoteRefresh;
- (NSMutableArray *) getEventsForStartDate:(NSDate *)startDate forEndDate:(NSDate *)endDate withCalendars:(NSArray *)calendars;
- (NSMutableDictionary *)fetchEventsWithStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate withSelectedCalendars:(NSArray *)selectedCals;

- (void)loadEvents:(NSArray *)theEvents;
- (void)loadCalendars:(NSDictionary *)theCalendars;
-(NSDictionary *)getCalendarWithIdentifier:(NSString *)theIdentifier;


@property (nonatomic, assign) BOOL queueSet;

@end
