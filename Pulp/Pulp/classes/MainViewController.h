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

@interface MainViewController : UIViewController <UIScrollViewDelegate>

+(MainViewController *)sharedMainViewController;
-(void)dataChanged;
-(void)dailyViewAddEventButtonHit:(NSDate *)referenceDate;
-(void)createEventExitButtonHitWithController:(EventManagerViewController *)theController withEvent:(EKEvent *)theEvent withAction:(EKEventEditViewAction)theAction;
-(void)dayViewTapped:(CalendarDayView *)tappedDay;
-(void)presentSettingsViewController;
-(void)resetCover;
-(void)toggleToTodos;
-(void)toggleToCalendar;
-(void)dailyEventSelected:(EKEvent *)theEvent;
-(void)dismissSettingsViewController;
@end
