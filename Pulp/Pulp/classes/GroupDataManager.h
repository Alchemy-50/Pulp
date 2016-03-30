//
//  GroupCalendarManager.h
//  AlphaRow
//
//  Created by Josh Klobe on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "CalendarDayView.h"
#import "CalendarEvent.h"

#define FRAME_SIZE_CHANGED 1
#define FRAME_MOVED 2


@interface GroupDataManager : NSObject
{
}

+ (GroupDataManager *) sharedManager;
- (NSArray *) getSelectedCalendars;
- (NSMutableDictionary *)fetchEventsWithStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate withSelectedCalendars:(NSArray *)selectedCals;


@property (nonatomic, retain) NSArray *colours;
@property (nonatomic, retain) NSMutableArray *contactsArray;
@property (nonatomic, retain) NSMutableDictionary *fbContactsDictionary;;
@property (nonatomic, retain) NSString *fbEventsCalendarID;


@end



