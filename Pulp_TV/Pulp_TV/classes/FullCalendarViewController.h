//
//  FullCalendarViewController.h
//  Calendar
//
//  Created by Alchemy50 on 5/27/14.
//
//

#import <UIKit/UIKit.h>
#import "Defs.h"
#import "Defs.h"
#import "EventKitManager.h"
#import "CalendarMonthView.h"
#import "FocusHandlerProtocol.h"

@interface FullCalendarViewController : UIViewController <UIScrollViewDelegate, FocusHandlerProtocol>


+(FullCalendarViewController *)sharedContainerViewController;
- (void) dataChanged;
- (void) doLoadViews;
- (void) calendarShouldScrollToDate:(NSDate *)theDate;
- (CalendarMonthView *) setDailyBorderWithDate:(NSDate *)theDate;
- (CalendarMonthView *) setDailyBorderWithDateString:(NSString *)dateString;
- (void) dayViewSelected:(CalendarDayView *)theDayView;
- (void) navigateToToday;

- (void) scrollUp;




@end
