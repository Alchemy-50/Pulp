//
//  MainViewController.h
//  Calendar
//
//  Created by Josh Klobe on 2/11/16.
//
//

#import <UIKit/UIKit.h>
#import "Defs.h"
#import "EventKitManager.h"
#import "CalendarDayView.h"
#import "CalendarEvent.h"

#define SECONDARY_VIEW_STATE_CALENDAR 0
#define SECONDARY_VIEW_STATE_TODOS 1


@interface MainViewController : UIViewController <UIScrollViewDelegate, UIFocusEnvironment>

+(MainViewController *)sharedMainViewController;


-(int)getSecondaryState;
-(void)dataChanged;
-(void)dailyViewAddEventButtonHit:(NSDate *)referenceDate;
-(void)dayViewTapped:(CalendarDayView *)tappedDay;
-(void)presentSettingsViewController;
-(void)toggleToTodos;
-(void)toggleToCalendar;
-(void)dailyEventSelected:(CalendarEvent *)theEvent;
-(void)dismissSettingsViewController;
-(void)resetCoverScrollToDate:(NSDate *)theDate;


-(void)launchUpdatingCoverView;
-(void)dismissUpdatingCoverView;


    
@end
