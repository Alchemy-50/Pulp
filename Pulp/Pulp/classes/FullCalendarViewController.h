//
//  FullCalendarViewController.h
//  Calendar
//
//  Created by Alchemy50 on 5/27/14.
//
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import "EventKitManager.h"
#import "CalendarMonthView.h"


@interface FullCalendarViewController : UIViewController <UIScrollViewDelegate>


+(FullCalendarViewController *)sharedContainerViewController;
- (void) dataChanged;
- (void) doLoadViews;
- (void) calendarShouldScrollToDate:(NSDate *)theDate;
- (CalendarMonthView *) setDailyBorderWithDate:(NSDate *)theDate;
- (CalendarMonthView *) setDailyBorderWithDateString:(NSString *)dateString;
- (void) dayViewSelected:(CalendarDayView *)theDayView;
- (void) navigateToToday;





@end
