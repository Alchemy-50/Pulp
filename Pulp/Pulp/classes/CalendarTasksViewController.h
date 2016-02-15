//
//  CalendarTasksViewController.h
//  Calendar
//
//  Created by Josh Klobe on 5/17/13.
//
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "CommonEventContainer.h"

@interface CalendarTasksViewController : UIViewController
{

}

-(void)createEventSavedWithEKEvent:(EKEvent *)theEvent withCommonEventContainer:(CommonEventContainer *)referenceCommonEventContainer withViewController:(UIViewController *)vc;

-(IBAction) deleteButtonHit;



@property (nonatomic, retain) EKCalendar *referenceCalendar;
@property (nonatomic, retain) NSMutableArray *commonEventsArray;

@property (nonatomic, retain) IBOutlet UIView *headerView;
@property (nonatomic, retain) IBOutlet UILabel *headerCalendarNameLabel;
@property (nonatomic, retain) IBOutlet UITableView *commonTasksTableView;

@property (nonatomic, retain) UIAlertView *theNewCommonEventAlertView;
@property (nonatomic, retain) UIAlertView *deleteCalendarAlertView;

@property (nonatomic, retain) IBOutlet UISwitch *calendarShowingSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *calendarSharingSwitch;

@property (nonatomic, assign) NSInteger deleteIndex;

@end
