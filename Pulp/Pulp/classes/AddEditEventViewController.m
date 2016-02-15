//
//  AddEditEventViewController.m
//  Calendar
//
//  Created by Josh Klobe on 7/1/13.
//
//

#import "AddEditEventViewController.h"
#import <AddressBook/ABAddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "CommonEventContainer.h"
#import "EventManagerViewController.h"
#import "CalendarSelectViewController.h"
#import "LocationViewController.h"


@interface AddEditEventViewController ()

@end

@implementation AddEditEventViewController

@synthesize delegate;

@synthesize contentScrollView;
@synthesize allDaySwitch;
@synthesize titleTextField;
@synthesize locationTextField;
@synthesize contactsTextField;
@synthesize dateDisplayField;
@synthesize startTimeLabel;
@synthesize endTimeLabel;
@synthesize endLabelView;
@synthesize calendarLabelView;
@synthesize calendarLabel;
@synthesize eventStartDateController;
@synthesize locationViewController;
@synthesize eventEndDateController;
@synthesize frequentSwitch;
@synthesize alwaysSame;
@synthesize attendeesArray;
@synthesize referenceEvent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"add_edit_background.png"]];
    
    NSArray *textFields = [NSArray arrayWithObjects:self.titleTextField, self.locationTextField, self.contactsTextField, nil];
    
    for (int i = 0; i < [textFields count]; i++)
    {
        UITextField *theTextField = [textFields objectAtIndex:i];
        if ([theTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor whiteColor];
            theTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:theTextField.placeholder attributes:@{NSForegroundColorAttributeName: color}];
        }
    }
    
    
}

- (void) loadWithEvent:(EKEvent *)theEvent
{
    self.referenceEvent = theEvent;
    [self loadFields];
}

-(void)loadFields
{
    if (self.referenceEvent.endDate == nil)
        self.referenceEvent.endDate = [self.referenceEvent.startDate dateByAddingTimeInterval:60 * 60];
    
    
    if (self.referenceEvent.title != nil)
        self.titleTextField.text = self.referenceEvent.title;
    if (self.referenceEvent.location != nil)
        self.locationTextField.text = self.referenceEvent.location;
    
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"EEE-MMM dd-yyyy"];
    self.dateDisplayField.text = [dateFormatter stringFromDate:self.referenceEvent.startDate];
    
    
    [self setTimeLabel:self.startTimeLabel withDate:self.referenceEvent.startDate withAllDay:self.referenceEvent.allDay];
    [self setTimeLabel:self.endTimeLabel withDate:self.referenceEvent.endDate withAllDay:self.referenceEvent.allDay];
    
    [dateFormatter setDateFormat:@"a"];
    self.eventStartDateController.amPmLabel.text = [dateFormatter stringFromDate:self.referenceEvent.startDate];
    
    
    if (self.referenceEvent.calendar.title != nil)
        self.calendarLabel.text = self.referenceEvent.calendar.title;
    
    
    NSMutableString *attendeesString = [NSMutableString stringWithCapacity:0];
    
    for (int i = 0; i < [self.referenceEvent.attendees count]; i++)
    {
        EKParticipant *attendee = [self.referenceEvent.attendees objectAtIndex:i];
        [attendeesString appendString:attendee.name];
        
        if (i != [self.referenceEvent.attendees count] -1)
            [attendeesString appendString:@", "];
    }
    self.contactsTextField.text = attendeesString;
    
    self.contentScrollView.contentSize = CGSizeMake(0, self.endLabelView.frame.origin.y + self.endLabelView.frame.size.height);
    
    if (self.referenceEvent.allDay)
        self.allDaySwitch.on = YES;
}

- (void)foursquareLocationReturnedWithDictionary:(NSDictionary *)theDictionary
{
    NSDictionary *responseDictionary = [theDictionary objectForKey:@"response"];
    NSDictionary *venueDictionary = [responseDictionary objectForKey:@"venue"];
//    NSDictionary *locationDictionary = [venueDictionary objectForKey:@"location"];
    self.locationTextField.text = [venueDictionary objectForKey:@"name"];
    
}




-(IBAction)startDateButtonHit:(id)caller
{
    NSLog(@"startDateButtonHit");
    if (self.eventStartDateController == nil)
    {
        self.eventStartDateController = [[RadialEventDateController alloc] initWithNibName:@"RadialEventDateController" bundle:nil];
        self.eventStartDateController.view.frame = CGRectMake(0, self.endLabelView.frame.origin.y, self.view.frame.size.width, 240);
        [self.contentScrollView insertSubview:self.eventStartDateController.view atIndex:0];
        [self.eventStartDateController doLoadViews];
        self.eventStartDateController.view.alpha = 0;
        self.eventStartDateController.delegate = self;
        
        if (self.referenceEvent.startDate != nil)
            [self.eventStartDateController setDialsWithDate:self.referenceEvent.startDate];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.33];
        self.endLabelView.frame = CGRectMake(0, self.eventStartDateController.view.frame.origin.y + self.eventStartDateController.view.frame.size.height + 15, self.endLabelView.frame.size.width, self.endLabelView.frame.size.height);
        self.eventStartDateController.view.alpha = 1;
        if (self.eventEndDateController != nil)
            self.eventEndDateController.view.frame = CGRectMake(0, self.endLabelView.frame.origin.y + self.endLabelView.frame.size.height, self.view.frame.size.width, self.eventEndDateController.view.frame.size.height);
        [UIView commitAnimations];
        
        self.contentScrollView.contentSize = CGSizeMake(0, self.endLabelView.frame.origin.y + self.endLabelView.frame.size.height);
        if (self.eventEndDateController != nil)
            self.contentScrollView.contentSize = CGSizeMake(0, self.eventEndDateController.view.frame.origin.y + self.eventEndDateController.view.frame.size.height);
        
    }
    else
    {
        [UIView beginAnimations:nil context:caller];
        [UIView setAnimationDuration:.33];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(startAnimationDidStop:finished:context:)];
        self.endLabelView.frame = CGRectMake(0, self.eventStartDateController.view.frame.origin.y, self.endLabelView.frame.size.width, self.endLabelView.frame.size.height);
        self.eventStartDateController.view.alpha = 0;
        if (self.eventEndDateController != nil)
            self.eventEndDateController.view.frame = CGRectMake(0, self.endLabelView.frame.origin.y + self.endLabelView.frame.size.height, self.view.frame.size.width, self.eventEndDateController.view.frame.size.height);
        [UIView commitAnimations];
        
    }
    
    
    
}

- (void)startAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {

    NSLog(@"start date did exit: %@", context);
    [self.eventStartDateController.view removeFromSuperview];
    [self.eventStartDateController release];
    self.eventStartDateController = nil;
    
    self.contentScrollView.contentSize = CGSizeMake(0, self.endLabelView.frame.origin.y + self.endLabelView.frame.size.height);
    if (self.eventEndDateController != nil)
        self.contentScrollView.contentSize = CGSizeMake(0, self.eventEndDateController.view.frame.origin.y + self.eventEndDateController.view.frame.size.height);
    
    if (context != nil)
    {
        id obj = context;
        if ([obj isKindOfClass:[AddEditEventViewController class]])
            [self endDateButtonHit:nil];
    }
}


- (IBAction) endDateButtonHit:(id)caller
{
    NSLog(@"endDateButtonHit!");
    
    /*if (self.eventStartDateController != nil)
    {
        NSLog(@"eventStartDateController != nil");
        [self startDateButtonHit:self];
    }
    else 
     */
    if (self.eventEndDateController == nil)
    {
        
        self.eventEndDateController = [[RadialEventDateController alloc] initWithNibName:@"RadialEventDateController" bundle:nil];
        self.eventEndDateController.view.frame = CGRectMake(0, self.endLabelView.frame.origin.y + self.endLabelView.frame.size.height, self.view.frame.size.width, 240);
        self.eventEndDateController.delegate = self;
        [self.contentScrollView insertSubview:self.eventEndDateController.view atIndex:0];
        [self.eventEndDateController doLoadViews];
        self.eventEndDateController.view.alpha = 0;
        
        if (self.referenceEvent.endDate != nil)
            [self.eventEndDateController setDialsWithDate:self.referenceEvent.endDate];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.33];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(endDateDidPresent)];
        self.eventEndDateController.view.alpha = 1;
        [UIView commitAnimations];
        self.contentScrollView.contentSize = CGSizeMake(0, self.eventEndDateController.view.frame.origin.y + self.eventEndDateController.view.frame.size.height);
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.33];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(endDateDidExit)];
        self.eventEndDateController.view.alpha = 0;
        [UIView commitAnimations];
        
    }
}


-(void)endDateDidPresent
{
    [self.contentScrollView setContentOffset:CGPointMake(0, self.endLabelView.frame.origin.y) animated:YES];
}


-(void)endDateDidExit
{
    [self.eventEndDateController.view removeFromSuperview];
    [self.eventEndDateController release];
    self.eventEndDateController = nil;
    self.contentScrollView.contentSize = CGSizeMake(0, self.endLabelView.frame.origin.y + self.endLabelView.frame.size.height);
    
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    UIButton *textExitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    textExitButton.backgroundColor = [UIColor clearColor];
    textExitButton.frame = CGRectMake(0,44,self.view.frame.size.width, self.view.frame.size.height-44);
    [textExitButton addTarget:self action:@selector(textExitButtonHit:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:textExitButton];
    
    if (textField == self.contactsTextField)
    {
        UIButton *textExitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        textExitButton.backgroundColor = [UIColor clearColor];
        textExitButton.frame = CGRectMake(0,44,self.view.frame.size.width, self.view.frame.size.height-44);
        [textExitButton addTarget:self action:@selector(textExitButtonHit:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:textExitButton];
        NSLog(@"textFieldShouldBeginEditing");
        
        /*
        ABPeoplePickerNavigationController *picker = [[ABPeoplePickerNavigationController alloc] init];
        picker.peoplePickerDelegate = self;
        [self presentViewController:picker animated:YES completion:nil];
        */
        return NO;
    }
    else if (textField == self.locationTextField)
    {
        self.locationViewController = [[LocationViewController alloc] initWithNibName:nil bundle:nil];
        self.locationViewController.delegate = self;
        [self presentViewController:self.locationViewController animated:YES completion:nil];
        
        if ([self.locationTextField.text length] > 0)
            self.locationViewController.theSearchBar.text = self.locationTextField.text;
        
        return NO;
    }
    else
        return YES;
}


/*

- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController*)peoplePicker didSelectPerson:(ABRecordRef)person NS_AVAILABLE_IOS(8_0)
{
    [self.attendeesArray addObject:person];
    [self peoplePickerNavigationControllerDidCancel:peoplePicker];
    
}


- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
*/

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"textFieldDidEndEditing");
    if (textField == self.titleTextField)
        self.referenceEvent.title = textField.text;
}

-(void)textExitButtonHit:(UIButton *)sender
{
    [sender removeFromSuperview];
    [self.titleTextField resignFirstResponder];
    [self.locationTextField resignFirstResponder];
    [self.contactsTextField resignFirstResponder];
}



-(void)imageReturnedWithData:(id)obj
{
    
}

-(void) calendarPickerDidFinishWithNewCalendar:(EKCalendar *)newCalendar
{
    self.referenceEvent.calendar = newCalendar;
    [self dismissViewControllerAnimated:YES completion:nil];
    self.calendarLabel.text = newCalendar.title;
}


-(void)setTimeLabel:(UILabel *)theLabel withDate:(NSDate *)theDate withAllDay:(BOOL)allDay
{
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    
    NSLog(@"allDay: %d", allDay);

    if (allDay)
    {
        [dateFormatter setDateFormat:@"dd MMM"];
    }
    else
    {
        [dateFormatter setDateFormat:@"hh:mm a"];
    }
    theLabel.text = [dateFormatter stringFromDate:theDate];
    
}


-(void)updateDateWithDateController:(RadialEventDateController *)theDateController
{
    if (theDateController == self.eventStartDateController)
    {
        self.referenceEvent.startDate = theDateController.theDate;
        [self setTimeLabel:self.startTimeLabel withDate:self.referenceEvent.startDate withAllDay:self.referenceEvent.allDay];
        
        if ([self.referenceEvent.endDate compare:self.referenceEvent.startDate] == NSOrderedAscending)
        {
            self.referenceEvent.endDate = [self.referenceEvent.startDate dateByAddingTimeInterval:60*60];
            [self setTimeLabel:self.endTimeLabel withDate:self.referenceEvent.endDate withAllDay:self.referenceEvent.allDay];
        }
    }
    else
    {
        self.referenceEvent.endDate = theDateController.theDate;
        [self setTimeLabel:self.endTimeLabel withDate:self.referenceEvent.endDate withAllDay:self.referenceEvent.allDay];
    }
}


-(void)locationExitButtonHit:(LocationViewController *)theVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction) cancelButtonHit
{
    NSLog(@"!cancelButtonHit");
    [self.view removeFromSuperview];
}

- (IBAction) saveButtonHit
{
//    NSLog(@"self.attendeesArray: %@", self.attendeesArray);
//    NSLog(@"theEvent.attendees: %@", self.referenceEvent.attendees);
    
//    [self.delegate addEditSaveButtonHit];
}


- (IBAction) calendarSelectButtonHit
{
    CalendarSelectViewController *calendarSelectViewController = [[CalendarSelectViewController alloc] initWithNibName:@"CalendarSelectViewController" bundle:nil];
    calendarSelectViewController.delegate = self;
    [self presentViewController:calendarSelectViewController animated:YES completion:nil];
}

- (IBAction) allDaySwitchToggled
{
    if (self.allDaySwitch.on)
        self.referenceEvent.allDay = YES;
    else
        self.referenceEvent.allDay = NO;
    
    [self setTimeLabel:self.startTimeLabel withDate:self.referenceEvent.startDate withAllDay:self.referenceEvent.allDay];
    [self setTimeLabel:self.endTimeLabel withDate:self.referenceEvent.endDate withAllDay:self.referenceEvent.allDay];
}


-(void) radialDidBeginDrag
{
    self.contentScrollView.scrollEnabled = NO;
}

-(void) radialDidEndDrag
{
    self.contentScrollView.scrollEnabled = YES;
}


@end
