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
#import "MonthContainerView.h"
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
- (MonthContainerView *) setDailyBorderWithDate:(NSDate *)theDate;
- (MonthContainerView *) setDailyBorderWithDateString:(NSString *)dateString;
- (void) spoofCalendarDayViewWithEvent:(EKEvent *)theEvent withAction:(EKEventEditViewAction)theAction;
- (void) dayViewSelected:(CalendarDayView *)theDayView;


@end
