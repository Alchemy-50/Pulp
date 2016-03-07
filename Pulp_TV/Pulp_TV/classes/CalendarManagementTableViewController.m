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
#import "FullCalendarViewController.h"
#import "ThemeManager.h"
#import "GroupDiskManager.h"
#import "EditCalendarManagementViewController.h"
#import "CalendarManagementViewController.h"
#import "Utils.h"
#import "CalendarRepresentation.h"
#import "MainViewController.h"

@interface CalendarManagementTableViewController ()


@property (nonatomic, retain) UITableView *theTableView;
@property (nonatomic, retain) NSMutableArray *contentArray;

@end

@implementation CalendarManagementTableViewController


-(void)initialize
{
    [self loadContentArray];
    
    self.theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.theTableView.backgroundColor = [UIColor clearColor];
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    [self.view addSubview:self.theTableView];
    
    [self.theTableView reloadData];
}


-(void)reload
{
    [self loadContentArray];
    [self.theTableView reloadData];
}

-(void)loadContentArray
{
    self.contentArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableDictionary *calendarsBySourceDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    
    
    NSArray *ar = [[EventKitManager sharedManager] getEKCalendars:NO];
    for (int i = 0; i < [ar count]; i++)
    {
        CalendarRepresentation *theCalendar = [ar objectAtIndex:i];
        if ([[[theCalendar getTitle] lowercaseString] compare:@"todo"] != NSOrderedSame && [[[theCalendar getTitle] lowercaseString] compare:@"birthdays"] != NSOrderedSame)
        {
            SourceRepresentation *sourceRepresentation = [theCalendar getSource];
            
            NSMutableArray *ar = [calendarsBySourceDictionary objectForKey:[sourceRepresentation getTitle]];
            if (ar == nil)
                ar = [[NSMutableArray alloc] initWithCapacity:0];
            
            [ar addObject:theCalendar];
            
            [calendarsBySourceDictionary setObject:ar forKey:[sourceRepresentation getTitle]];
        }
        
    }
    
    for (id key in calendarsBySourceDictionary)
    {
        NSArray *ar = [calendarsBySourceDictionary objectForKey:key];
        
        CalendarRepresentation *theCalendar = [ar objectAtIndex:0];
        SourceRepresentation *theSource = [theCalendar getSource];
        [self.contentArray addObject:theSource];
        
        for (int i = 0; i < [ar count]; i++)
            [self.contentArray addObject:[ar objectAtIndex:i]];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.contentArray count];
    
}

- (CalendarManagementTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    CalendarManagementTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CalendarManagementTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.view.frame.size.width, cell.frame.size.height);//[self tableView:tableView heightForRowAtIndexPath:indexPath]);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = @"";
        cell.backgroundColor = [UIColor clearColor];
        [cell initialize];
        
    }
    
    [cell cleanViews];
    
    id obj = [self.contentArray objectAtIndex:indexPath.row];
    
    
    if ([obj isKindOfClass:[SourceRepresentation class]])
        [cell loadWithSource:obj];
    
    else if ([obj isKindOfClass:[CalendarRepresentation class]])
        [cell loadWithCalendar:obj];
    
    
    //[cell loadForAddCalendar];
    
    return cell;
}


-(void)checkAllButtonHit
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    for (int i = 0; i < [self.contentArray count]; i++)
    {
        CalendarRepresentation *referenceCalendar = [self.contentArray objectAtIndex:i];
        if ([referenceCalendar isKindOfClass:[CalendarRepresentation class]])
        {
            NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY]];
            BOOL val = [[dict objectForKey:[referenceCalendar getTheCalendarIdentifier]] boolValue];
            val = YES;
            
            [dict setObject:[NSNumber numberWithBool:val] forKey:[referenceCalendar getTheCalendarIdentifier]];
            [[GroupDiskManager sharedManager] saveDataToDiskWithObject:dict withKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY];
        }
    }
    
    [self reload];
}



-(void)calendarContentChanged
{
    [self reload];
    [[MainViewController sharedMainViewController] dataChanged];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarRepresentation *theCalendar = [self.contentArray objectAtIndex:indexPath.row];
    if ([theCalendar isKindOfClass:[CalendarRepresentation class]])
    {
        
        
        EditCalendarManagementViewController *editCalendarViewController = [[EditCalendarManagementViewController alloc] initWithNibName:nil bundle:nil];
        editCalendarViewController.theParentController = self;
        editCalendarViewController.view.frame = CGRectMake(0, 0, [Utils getScreenWidth], [Utils getScreenHeight]);
//        [[MainViewController sharedMainViewController] presentViewController:editCalendarViewController animated:YES completion:nil];
        [[CalendarManagementViewController sharedCalendarManagementViewController] presentViewController:editCalendarViewController animated:YES completion:nil];
        [editCalendarViewController loadWithCalendar:theCalendar];
        
    }
   
}


- (void) calendarDropdownAddCalendarSelected
{
    
    // FIXME: Implement uialertcontroller with handlers below
    
    /*
     UIAlertController * alert=   [UIAlertController
     alertControllerWithTitle:@"My Title"
     message:@"Enter User Credentials"
     preferredStyle:UIAlertControllerStyleAlert];
     
     [self presentViewController:alert animated:YES completion:nil];
     
     
     UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"New Calendar" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Continue", nil];
     [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
     [message show];
     
     */
}

/*
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
 
 if ([[popup buttonTitleAtIndex:buttonIndex] compare:@"Cancel"] != NSOrderedSame)
 {
 [self.parentFullCalendarViewController topCalButtonHit:YES];
 EKCalendar *calendar = [[EventKitManager sharedManager] getNewEKCalendar];
 calendar.CGColor = [UIColor colorWithRed:(arc4random() % 255)/255.0f green:(arc4random() % 256)/255.0f blue:(arc4random() % 256)/255.0f alpha:1].CGColor;
 calendar.title = self.theNewCalendarString;
 calendar.source = [[[EventKitManager sharedManager].eventStore sources] objectAtIndex:buttonIndex];
 [[EventKitManager sharedManager] createAndSaveCalendar:calendar];
 
 }
 }
 */




@end