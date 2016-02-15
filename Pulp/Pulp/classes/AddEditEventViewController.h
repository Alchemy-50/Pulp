//
//  AddEditEventViewController.h
//  Calendar
//
//  Created by Josh Klobe on 7/1/13.
//
//

#import <UIKit/UIKit.h>
#import "RadialEventDateController.h"
#import "CommonEventContainer.h"
#import "LocationViewController.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>


@class EventManagerViewController;

@interface AddEditEventViewController : UIViewController <UITextFieldDelegate, ABPeoplePickerNavigationControllerDelegate>
{
    EventManagerViewController *delegate;
    
    UIScrollView *contentScrollView;
    
    RadialEventDateController *eventStartDateController;
    RadialEventDateController *eventEndDateController;
 
    LocationViewController *locationViewController;
 
    UIView *startTimeContainerView;
    UIView *endTimeContainerView;
    
    EKEvent *referenceEvent;
    
    NSMutableArray *attendeesArray;
}

- (IBAction) cancelButtonHit;
- (IBAction) saveButtonHit;
- (IBAction) startDateButtonHit:(id)caller;
- (IBAction) endDateButtonHit:(id)caller;
- (IBAction) calendarSelectButtonHit;
- (IBAction) allDaySwitchToggled;
- (void) loadWithEvent:(EKEvent *)theEvent;
- (void) updateDateWithDateController:(RadialEventDateController *)theDateController;
- (void) radialDidBeginDrag;
- (void) radialDidEndDrag;
- (void) calendarPickerDidFinishWithNewCalendar:(EKCalendar *)newCalendar;

@property (nonatomic, retain) EventManagerViewController *delegate;

@property (nonatomic, retain) IBOutlet UIScrollView *contentScrollView;

@property (nonatomic, retain) IBOutlet UISwitch *allDaySwitch;
@property (nonatomic, retain) IBOutlet UISwitch *frequentSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *alwaysSame;
@property (nonatomic, retain) IBOutlet UITextField *titleTextField;
@property (nonatomic, retain) IBOutlet UITextField *locationTextField;
@property (nonatomic, retain) IBOutlet UITextField *contactsTextField;
@property (nonatomic, retain) IBOutlet UILabel *dateDisplayField;
@property (nonatomic, retain) IBOutlet UILabel *startTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *endTimeLabel;

@property (nonatomic, retain) IBOutlet UILabel *calendarLabel;


@property (nonatomic, retain) IBOutlet UIView *endLabelView;
@property (nonatomic, retain) IBOutlet UIView *calendarLabelView;

@property (nonatomic, retain) RadialEventDateController *eventStartDateController;
@property (nonatomic, retain) RadialEventDateController *eventEndDateController;
@property (nonatomic, retain) LocationViewController *locationViewController;

@property (nonatomic, retain) EKEvent *referenceEvent;

@property (nonatomic, retain) NSMutableArray *attendeesArray;

@end
