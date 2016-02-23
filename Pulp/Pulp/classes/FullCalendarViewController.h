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
#import "ContentContainerViewController.h"
#import "CalendarManagementTableViewController.h"



@interface FullCalendarViewController : UIViewController

- (void) doLoadViews;
- (void) dataChanged;


@property (nonatomic, retain) ContentContainerViewController *contentContainerViewController;
@property (nonatomic, retain) UIImageView *zoomingImageView;
@property (nonatomic, retain) CalendarManagementTableViewController *calendarManagementTableViewController;
@end
