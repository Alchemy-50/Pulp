//
//  DefaultCalendarSelectTableViewController.m
//  Calendar
//
//  Created by Alchemy50 on 6/11/14.
//
//

#import "DefaultCalendarSelectTableViewController.h"
#import "EventKitManager.h"


@interface DefaultCalendarSelectTableViewController ()

@property (nonatomic, retain) NSMutableArray *calendars;
@property (nonatomic, retain) UITableView *theTableView;
@end

@implementation DefaultCalendarSelectTableViewController

@synthesize parentAppSettingsViewController;
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray *calsArray = [NSArray arrayWithArray:[[EventKitManager sharedManager] getEKCalendars:NO]];
    
    self.calendars = [[NSMutableArray alloc] initWithCapacity:0];
    for (int i = 0; i < [calsArray count]; i++)
    {
        CalendarRepresentation *theCalendar = [calsArray objectAtIndex:i];
        
        if ([[[theCalendar getTitle] uppercaseString] compare:@"TODO"] != NSOrderedSame)
            [self.calendars addObject:theCalendar];
    }

    
    self.theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height - 50) style:UITableViewStylePlain];
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
//    [self.view addSubview:self.theTableView];
    
}





- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.calendars count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    CalendarRepresentation *theCalendar = [self.calendars objectAtIndex:indexPath.row];
    cell.textLabel.text = [theCalendar getTitle];    
//    cell.textLabel.text = obj.objectTitle;
    
    
    return cell;
}


// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.parentAppSettingsViewController defaultCalendarSelected:[self.calendars objectAtIndex:indexPath.row]];    
}

@end
