//
//  EventKitManager.h
//  Calendar
//
//  Created by Jay Canty on 4/25/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

#define STORED_CALENDARS_SHOWING_DICTIONARY_KEY @"STORED_CALEfNDARS_SHOWING_DICTIONARY_KEY"


@interface EventKitManager : NSObject {
}

+(EventKitManager *)sharedManager;
- (NSString *) getNewCommonEventID;
- (EKSource *)getStandardEKSource;
- (EKCalendar *) getNewEKCalendar;
- (EKCalendar *) getEKCalendarWithIdentifier:(NSString *)calId;
- (NSArray *) getEKCalendars:(BOOL)supressHiddenCalendars;
- (EKEvent *) getNewEKEvent;
- (EKEvent *) getEKEventWithIdentifier:(NSString *)eventId;
- (BOOL) saveCalendar:(EKCalendar *)calendar;
- (BOOL) saveCalendarWaitForResult:(EKCalendar *)calendar;
- (void) deleteCalendar:(EKCalendar *)calendar;
- (BOOL) createAndSaveCalendar:(EKCalendar *)calendar;
- (void) saveCalendarEvent:(EKEvent *)calendarEvent;
- (void) deleteCalendarEvent:(EKEvent *)event spanFutureEvents:(BOOL)span;
- (NSMutableArray *) getEventsForStartDate:(NSDate *)startDate forEndDate:(NSDate *)endDate withCalendars:(NSArray *)calendars;
- (void) commit;
- (void) remoteRefresh;

@property (nonatomic, retain) EKEventStore *eventStore;


@property (nonatomic, assign) BOOL queueSet;

@end
