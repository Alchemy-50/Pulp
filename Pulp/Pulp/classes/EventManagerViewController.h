//
//  EventManagerViewController.h
//  Calendar
//
//  Created by Josh Klobe on 7/1/13.
//
//

#import <UIKit/UIKit.h>
#import "CommonEventContainer.h"
#import "AddEditEventViewController.h"
#import <EventKit/EventKit.h>
#import "EventKitManager.h"
#import <EventKitUI/EventKitUI.h>

@class FullCalendarViewController;
@class CommonEventContainer;
@class CalendarDayView;

@interface EventManagerViewController : UIViewController <EKEventEditViewDelegate>
{

}

- (void) createNewEventWithReferenceDate;
- (void) displayEvent;
- (void) eventViewCancelButtonHit;
- (void) eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action;
- (void) createNewEventWithCommonEventContainer:(CommonEventContainer *)theCommonEventContainer withReferenceDate:(NSDate *)referenceDate;

@property (nonatomic, retain) id theParentViewController;
@property (nonatomic, assign) CGRect startEndRect;

@property (nonatomic, retain) EKEventEditViewController *addController;

@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UIImageView *theImageView;

@property (nonatomic, retain) CommonEventContainer *commonEventReferenceContainer;
@property (nonatomic, retain) NSDate *calendarReferenceDate;
@property (nonatomic, retain) EKObject *ekObjectReference;



@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *contactsLabel;
@property (nonatomic, retain) IBOutlet UILabel *dateLabel;
@property (nonatomic, retain) IBOutlet UILabel *timeLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *locationAddressLabel;

@property (nonatomic, assign) BOOL denyProcess;
@end
