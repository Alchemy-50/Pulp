//
//  EventCalendarSelectViewController.m
//  Calendar
//
//  Created by Josh Klobe on 6/5/14.
//
//

#import "EventCalendarSelectViewController.h"
#import "EventCalendarSelectTableViewCell.h"
#import "EventKitManager.h"
#import "FullViewEventCreateViewController.h"
#import "GroupDataManager.h"
@interface EventCalendarSelectViewController ()

@end

@implementation EventCalendarSelectViewController


@synthesize parentFullViewEventCreateViewController;
@synthesize theTableView;
@synthesize calendarsArray;;
@synthesize labelsArray;


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
    
}

-(void)loadTheViews
{
    NSLog(@"loadTheViews!!!");
    
    self.labelsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
        
    NSArray *storedCalendarsArray = [NSArray arrayWithArray:[GroupDataManager sharedManager].getSelectedCalendars];
    
    self.calendarsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSArray *excludedCalendars = [NSArray arrayWithObjects:@"birthdays", @"todo", @"holidays in united states", @"contacts' birthdays and events", @"us holidays", @"fb events",  nil];

    
    
    for (int i = 0; i < [storedCalendarsArray count]; i++)
    {
        EKCalendar *theCal = [storedCalendarsArray objectAtIndex:i];
        if (![excludedCalendars containsObject:[theCal.title lowercaseString]])
            [self.calendarsArray addObject:theCal];
    }
    
    float yInset = 100;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = .45;
    [self.view addSubview:bgView];
    
    
    self.theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yInset,self.view.frame.size.width, self.view.frame.size.height - 2 * yInset)];
    self.theTableView.separatorColor = [UIColor clearColor];
    self.theTableView.backgroundColor = [UIColor clearColor];
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    [self.view addSubview:self.theTableView];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.calendarsArray count];
}

- (EventCalendarSelectTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    EventCalendarSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[EventCalendarSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [cell loadWithCalendar:[self.calendarsArray objectAtIndex:indexPath.row]];
    
    UILabel *theLabel = cell.calendarLabel;
    if (![self.labelsArray containsObject:theLabel])
        [self.labelsArray addObject:theLabel];
    
//    cell.textLabel.text = [NSString stringWithFormat:@"row: %d", indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.parentFullViewEventCreateViewController calendarSelected:[self.calendarsArray objectAtIndex:indexPath.row]];
    
}

-(void)showCalendarLabels
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.22];
    for (int i = 0; i < [self.labelsArray count]; i++)
    {
        UILabel *theLabel = [self.labelsArray objectAtIndex:i];
        theLabel.alpha = 1;
    }
    [UIView commitAnimations];
    
}


-(void)hideCalendarLabels
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.22];
    for (int i = 0; i < [self.labelsArray count]; i++)
    {
        UILabel *theLabel = [self.labelsArray objectAtIndex:i];
        theLabel.alpha = 0;
    }
    [UIView commitAnimations];
}



@end
