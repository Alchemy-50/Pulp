//
//  CalendarMonthView.h
//  AlphaRow
//
//  Created by Josh Klobe on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDayView.h"
#import "CalendarDoubleDayView.h"

@class ContentContainerViewController, CalendarMonthScrollViewController;

@interface CalendarMonthView : UIView {
}

-(BOOL) drawCalendar;
-(void) loadEvents;
-(void) cleanUp;


@property (nonatomic, retain) NSMutableDictionary *calendarDayViewDictionary;
@property (nonatomic, retain) NSDictionary *dateStringForEventDictionary;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, assign) BOOL presented;

@end
