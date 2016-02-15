//
//  CalendarSelectViewController.m
//  Calendar
//
//  Created by Josh Klobe on 5/15/13.
//
//

#import "CalendarSelectViewController.h"
#import "EventKitManager.h"
#import "AddEditEventViewController.h"

@interface CalendarSelectViewController ()

@end

@implementation CalendarSelectViewController

@synthesize delegate;

@synthesize thePickerView;
@synthesize contentArray;
@synthesize selectedIndex;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.contentArray = [[NSMutableArray alloc] initWithCapacity:0];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self.contentArray addObjectsFromArray:[[EventKitManager sharedManager] getEKCalendars:NO]];
}


- (NSInteger)numberOfRowsInComponent:(NSInteger)component
{
    return [self.contentArray count];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.contentArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    EKCalendar *theCalendar = [self.contentArray objectAtIndex:row];
    return theCalendar.title;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedIndex = row;
}

-(IBAction)cancelButtonHit
{
    [self.delegate calendarPickerDidFinishWithNewCalendar:nil];
    
}

-(IBAction)saveButtonHit
{
    [self.delegate calendarPickerDidFinishWithNewCalendar:[self.contentArray objectAtIndex:self.selectedIndex]];
}

@end
