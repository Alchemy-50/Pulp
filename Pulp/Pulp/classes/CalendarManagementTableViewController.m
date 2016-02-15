//
//  CalendarManagementTableViewController.m
//  Calendar
//
//  Created by Alchemy50 on 7/11/14.
//
//

#import "CalendarManagementTableViewController.h"
#import "EventKitManager.h"
#import "CalendarManagementTableViewCell.h"
#import "AppDelegate.h"
@interface CalendarManagementTableViewController ()

@end

@implementation CalendarManagementTableViewController

@synthesize calendarsArray;
@synthesize parentFullCalendarViewController;
@synthesize theTableView;
@synthesize theNewCalendarString;
@synthesize bgView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.bgView.backgroundColor = [UIColor blackColor];
    self.bgView.alpha = .5;
    [self.view insertSubview:self.bgView atIndex:0];
    
    self.calendarsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *ar = [[EventKitManager sharedManager] getEKCalendars:NO];
    for (int i = 0; i < [ar count]; i++)
    {
        EKCalendar *theCalendar = [ar objectAtIndex:i];
        if ([[theCalendar.title lowercaseString] compare:@"todo"] != NSOrderedSame && [[theCalendar.title lowercaseString] compare:@"birthdays"] != NSOrderedSame)
            [self.calendarsArray addObject:theCalendar];
    }

    self.theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    NSLog(@"theTableView.frame: %@", NSStringFromCGRect(self.theTableView.frame));
    self.theTableView.backgroundColor = [UIColor clearColor];
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    [self.view addSubview:self.theTableView];
    [self.theTableView reloadData];
}

-(void)reload
{
    [self.calendarsArray removeAllObjects];
    self.calendarsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *ar = [[EventKitManager sharedManager] getEKCalendars:NO];
    for (int i = 0; i < [ar count]; i++)
    {
        EKCalendar *theCalendar = [ar objectAtIndex:i];
        if ([[theCalendar.title lowercaseString] compare:@"todo"] != NSOrderedSame && [[theCalendar.title lowercaseString] compare:@"birthdays"] != NSOrderedSame)
            [self.calendarsArray addObject:theCalendar];
    }
    
    [self.theTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    tableView.separatorColor = [UIColor clearColor];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
    NSInteger retVal = [self.calendarsArray count]  + 2;
    

    return retVal;
    
}

- (CalendarManagementTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    CalendarManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CalendarManagementTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.text = @"";
    cell.backgroundColor = [UIColor clearColor];
    [cell cleanViews];
    
    
    if (indexPath.row == 0)
    {
        cell.textLabel.text = @"all calendars";
        cell.backgroundColor = [UIColor whiteColor];
    }
    else if (indexPath.row <= [self.calendarsArray count])
        [cell loadWithCalendar:[self.calendarsArray objectAtIndex:indexPath.row-1]];
    else if (indexPath.row == [self.calendarsArray count] + 1)
        [cell loadForAddCalendar];

        
 
    return cell;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"HOLD NOW PLEASE!");
/*
    AppDelegate *theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    if (indexPath.row == [self.calendarsArray count] + 1)
    {
        [self calendarDropdownAddCalendarSelected];
    }
    else if (indexPath.row ==  0)
    {
        theDelegate.currentSelectedCalendar = nil;
        [self.parentFullCalendarViewController topCalButtonHit:YES];
    }
    else
    {
        EKCalendar *calendar = [calendarsArray objectAtIndex:indexPath.row - 1];
        
        if (calendar == theDelegate.currentSelectedCalendar)
            theDelegate.currentSelectedCalendar = nil;
        else
            theDelegate.currentSelectedCalendar = calendar;
        
        [self.parentFullCalendarViewController topCalButtonHit:YES];
        
    }
    */
    
}


- (void) calendarDropdownAddCalendarSelected
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"New Calendar" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    [message show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (buttonIndex > 0)
    {
        self.theNewCalendarString = [alertView textFieldAtIndex:0].text;
        
        NSArray *sourcesArray = [[EventKitManager sharedManager].eventStore sources];
        
        UIActionSheet *popup = [[UIActionSheet alloc] initWithTitle:@"Select Source" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
        
        for (int i = 0; i < [sourcesArray count]; i++)
        {
            EKSource *source = [sourcesArray objectAtIndex:i];
            [popup addButtonWithTitle:source.title];
        }
        
        [popup addButtonWithTitle:@"Cancel"];
        popup.tag = 1;
        [popup showInView:[UIApplication sharedApplication].keyWindow];
    }
}


- (void)actionSheet:(UIActionSheet *)popup clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    NSLog(@"IMPLEMENT THIS ACTION SHEET POPUP CLICKED BUTTON AT INDEX");
    /*
    if ([[popup buttonTitleAtIndex:buttonIndex] compare:@"Cancel"] != NSOrderedSame)
    {
        [self.parentFullCalendarViewController topCalButtonHit:YES];
         EKCalendar *calendar = [[EventKitManager sharedManager] getNewEKCalendar];
         calendar.CGColor = [UIColor colorWithRed:(arc4random() % 255)/255.0f green:(arc4random() % 256)/255.0f blue:(arc4random() % 256)/255.0f alpha:1].CGColor;
         calendar.title = self.theNewCalendarString;
         calendar.source = [[[EventKitManager sharedManager].eventStore sources] objectAtIndex:buttonIndex];
         [[EventKitManager sharedManager] createAndSaveCalendar:calendar];
        
    }
    
    */
}





@end
