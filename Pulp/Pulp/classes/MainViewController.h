//
//  MainViewController.h
//  Calendar
//
//  Created by Josh Klobe on 2/11/16.
//
//

#import <UIKit/UIKit.h>
#import "EventManagerViewController.h"
#import <EventKit/EventKit.h>

#define SECONDARY_VIEW_STATE_CALENDAR 0
#define SECONDARY_VIEW_STATE_TODOS 1

@interface MainViewController : UIViewController <UIScrollViewDelegate>

+(MainViewController *)sharedMainViewController;
-(int)getSecondaryState;
-(void)dataChanged;
-(void)dailyViewAddEventButtonHit:(NSDate *)referenceDate;
-(void)createEventExitButtonHitWithController:(EventManagerViewController *)theController withEvent:(EKEvent *)theEvent withAction:(EKEventEditViewAction)theAction;
-(void)dayViewTapped:(CalendarDayView *)tappedDay;
-(void)presentSettingsViewController;
-(void)toggleToTodos;
-(void)toggleToCalendar;
-(void)dailyEventSelected:(EKEvent *)theEvent;
-(void)dismissSettingsViewController;
-(void)resetCoverScrollToDate:(NSDate *)theDate;
@end
