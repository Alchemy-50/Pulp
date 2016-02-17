//
//  CalendarViewController.h
//  Calendar
//
//  Created by jay canty on 2/2/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarMonthView.h"
#import <EventKit/EventKit.h>
#import "EventKitManager.h"
#import <EventKitUI/EventKitUI.h>
#import "CalendarDayView.h"


@class MainViewController;

@interface ContentContainerViewController : UIViewController <UIScrollViewDelegate>
{
    
}

+(ContentContainerViewController *)sharedContainerViewController;

- (void) reloadViews;
- (void) doLoadViews;
- (void) calendarShouldScrollToDate:(NSDate *)theDate;
- (void) calendarDataChanged;
- (CalendarMonthView *) setDailyBorderWithDate:(NSDate *)theDate;
- (CalendarMonthView *) setDailyBorderWithDateString:(NSString *)dateString;
- (void) spoofCalendarDayViewWithEvent:(EKEvent *)theEvent withAction:(EKEventEditViewAction)theAction;
- (void) dayViewSelected:(CalendarDayView *)theDayView;
- (void) navigateToToday;

@end
