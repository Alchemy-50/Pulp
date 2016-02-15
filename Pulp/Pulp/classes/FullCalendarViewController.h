//
//  FullCalendarViewController.h
//  Calendar
//
//  Created by Alchemy50 on 5/27/14.
//
//

#import <UIKit/UIKit.h>
#import "ContentContainerViewController.h"
#import "CalendarHeaderView.h"
#import "CalendarManagementTableViewController.h"

@class CalendarTasksViewController;
@class EventManagerViewController;

@interface FullCalendarViewController : UIViewController
{

}

-(void)doLoadViews;
- (void) dataChanged;
- (void) topCalButtonHit:(BOOL)refresh;
- (void) createEventExitButtonHitWithController:(EventManagerViewController *)theController withEvent:(EKEvent *)theEvent withAction:(EKEventEditViewAction)theAction;


@property (nonatomic, retain) ContentContainerViewController *contentContainerViewController;
@property (nonatomic, retain) CalendarHeaderView *calendarHeaderView;
@property (nonatomic, retain) UIImageView *zoomingImageView;
@property (nonatomic, retain) CalendarManagementTableViewController *calendarManagementTableViewController;
@end
