//
//  FullViewEventCreateViewController.h
//  Calendar
//
//  Created by Josh Klobe on 6/5/14.
//
//

#import <UIKit/UIKit.h>
#import "EventCalendarSelectViewController.h"
#import "EventTaskSelectViewController.h"
#import "CommonEventContainer.h"

#define FullViewEventCreateViewControllerTransitionTime .16

@class FullCalendarViewController, CalendarDayView;
@interface FullViewEventCreateViewController : UIViewController <UIScrollViewDelegate>




-(void)present;
-(void)calendarSelected:(EKCalendar *)selectedCalendar;
-(void)commonTaskSelected:(CommonEventContainer *)selectedCommonEventContainer; 

@property (nonatomic, retain) CalendarDayView *referenceCalendarDayView;
@property (nonatomic, retain) id theParentViewController;
@property (nonatomic, retain) UIScrollView *containerScrollView;
@property (nonatomic, retain) UIButton *exitButton;
@property (nonatomic, retain) EventCalendarSelectViewController *eventCalendarSelectViewController;
@property (nonatomic, retain) EventTaskSelectViewController *eventTaskSelectViewController;
@property (nonatomic, retain) NSDate *referenceDate;

@end
