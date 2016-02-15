//
//  CalendarTasksViewController.m
//  Calendar
//
//  Created by Josh Klobe on 5/17/13.
//
//

#import "CalendarTasksViewController.h"
#import "AppDelegate.h"
#import "CommonEventContainer.h"
#import "CommonEventsManager.h"
#import "GroupDiskManager.h"
#import "EventKitManager.h"


@interface CalendarTasksViewController ()

@end

@implementation CalendarTasksViewController

@synthesize referenceCalendar, commonEventsArray;

@synthesize headerView, headerCalendarNameLabel, commonTasksTableView;
@synthesize theNewCommonEventAlertView;
@synthesize deleteCalendarAlertView;
@synthesize calendarShowingSwitch;
@synthesize calendarSharingSwitch;
@synthesize deleteIndex;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.commonEventsArray = [[NSMutableArray alloc] initWithCapacity:0];
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.deleteIndex = -1;
    
    self.headerCalendarNameLabel.text = self.referenceCalendar.title;
    
    [self loadData];
    
    UIColor *calendarColor = [UIColor colorWithCGColor:referenceCalendar.CGColor];
    self.headerView.backgroundColor = calendarColor;
    self.view.backgroundColor = calendarColor;
    

    
    NSDictionary *dict = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY];
    
    self.calendarShowingSwitch.on = [[dict objectForKey:self.referenceCalendar.calendarIdentifier] boolValue];
    
    [self.calendarShowingSwitch addTarget:self action:@selector(calendarShowingSwitchValueDidChange) forControlEvents:UIControlEventValueChanged];
    
    self.calendarSharingSwitch.on = 0;
}

-(void)calendarShowingSwitchValueDidChange
{
    NSLog(@"calendarShowingSwitchValueDidChange: %d", self.calendarShowingSwitch.on);
}


-(void)loadData
{
    [self.commonEventsArray removeAllObjects];
    
    NSArray *commonEventsForCalendar = [[CommonEventsManager sharedEventsManager] getCommonEventsForCalendar:self.referenceCalendar];
    if (commonEventsForCalendar != nil)
        [self.commonEventsArray addObjectsFromArray:commonEventsForCalendar];
    
    [self.commonTasksTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.commonEventsArray count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    if (indexPath.row >= [self.commonEventsArray count])
        cell.textLabel.text = @"Add Common Event";
    else
    {
        CommonEventContainer *container = [self.commonEventsArray objectAtIndex:indexPath.row];
        cell.textLabel.text = container.title;
    }
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row >= [self.commonEventsArray count])
    {
        self.theNewCommonEventAlertView = [[UIAlertView alloc] initWithTitle:@"New Common Event"
                                                                  message:@"Set Title"
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                        otherButtonTitles:@"Continue", nil];
        [self.theNewCommonEventAlertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [self.theNewCommonEventAlertView textFieldAtIndex:0].autocapitalizationType = UITextAutocapitalizationTypeWords;
        [self.theNewCommonEventAlertView show];
        
    }
    else
    {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Delete?" message:((CommonEventContainer *)[self.commonEventsArray objectAtIndex:indexPath.row]).title delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"YES", nil];
        [message show];
        
        self.deleteIndex = indexPath.row;
        
        
        /*   CreateEventViewController *createEventViewController = [[CreateEventViewController alloc] initWithNibName:nil bundle:nil];
         createEventViewController.view.frame = self.view.frame;
         createEventViewController.delegate = self;
         createEventViewController.referenceCommonEventContainer = [self.commonEventsArray objectAtIndex:indexPath.row];
         createEventViewController.view.alpha = 0;
         [self.view addSubview:createEventViewController.view];
         
         
         [UIView beginAnimations:nil context:nil];
         [UIView setAnimationDuration:0.35];
         [UIView setAnimationDelegate:createEventViewController];
         createEventViewController.view.alpha = 1;
         [UIView setAnimationDidStopSelector:@selector(doLoadViews)];
         [UIView commitAnimations];
         
         */
    }
}

-(void)createEventExitButtonHitWithController:(UIViewController *)vc
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    [UIView setAnimationDelegate:vc];
    vc.view.alpha =0;
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    [UIView commitAnimations];
    
}

-(void)createEventSavedWithEKEvent:(EKEvent *)theEvent withCommonEventContainer:(CommonEventContainer *)referenceCommonEventContainer withViewController:(UIViewController *)vc
{
    
    NSInteger index = [self.commonEventsArray indexOfObject:referenceCommonEventContainer];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter setDateFormat:@"hh:mm:ss"];
    
    NSString *timeString = [dateFormatter stringFromDate:theEvent.startDate];
    
    NSString *epochString = [NSString stringWithFormat:@"1970-01-01 %@", timeString];
    
    NSDateFormatter *baseDateFormatter = [[NSDateFormatter alloc] init];
    [baseDateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [baseDateFormatter setDateFormat:@"yyyy-mm-dd HH:mm:ss"];
    
    NSDate *baseDate = [baseDateFormatter dateFromString:epochString];
    
    /*
     NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
     NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
     NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:baseDate];
     NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:baseDate];
     NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
     
     baseDate = [baseDate dateByAddingTimeInterval:interval];
     */
    
    CommonEventContainer *theCommonEventContainer = [self.commonEventsArray objectAtIndex:index];
    
    NSTimeInterval timeInterval = [baseDate timeIntervalSince1970];
    theCommonEventContainer.eventTime = timeInterval;
    EKCalendar *theReferenceCalendar = [[EventKitManager sharedManager] getEKCalendarWithIdentifier:referenceCommonEventContainer.referenceCalendarIdentifier];
    [[CommonEventsManager sharedEventsManager] setCommonEvent:theCommonEventContainer forCalendar:theReferenceCalendar];
    
    [self createEventExitButtonHitWithController:vc];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if ([alertView.title compare:@"Delete?"] == NSOrderedSame)
    {
        if (buttonIndex)
        {
            NSLog(@"do delete");
            [[CommonEventsManager sharedEventsManager] removeCommonEvent:[self.commonEventsArray objectAtIndex:deleteIndex] forCalendar:self.referenceCalendar];
            [self loadData];
        }
    }
    else if ([alertView.title compare:@"New Common Event"] == NSOrderedSame)
    {
        if (alertView == self.theNewCommonEventAlertView)
        {
            if (buttonIndex == 1)
            {

                CommonEventContainer *commonEventContainer = [[CommonEventContainer alloc] init];                
                commonEventContainer.title = [alertView textFieldAtIndex:0].text;
                commonEventContainer.referenceCalendarIdentifier = self.referenceCalendar.calendarIdentifier;
                [[CommonEventsManager sharedEventsManager] setCommonEvent:commonEventContainer forCalendar:self.referenceCalendar];
                [self loadData];
            }
        }
    }
        else if (alertView == self.deleteCalendarAlertView)
        {
            if (buttonIndex == 1)
            {
                [[EventKitManager sharedManager] deleteCalendar:self.referenceCalendar];
                [[MainViewController sharedMainViewController] dismissViewControllerAnimated:YES completion:nil];
            }
    }
}



-(IBAction) deleteButtonHit
{
    NSLog(@"self.referenceCalendar: %@", self.referenceCalendar);
    
    self.deleteCalendarAlertView = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:@"This will permanently remove this calendar and all associated events"
                                                             delegate:self cancelButtonTitle:@"Oh God No!" otherButtonTitles:@"I Am Quite Certain", nil];
    [self.deleteCalendarAlertView show];
    [self.deleteCalendarAlertView release];
}




@end
