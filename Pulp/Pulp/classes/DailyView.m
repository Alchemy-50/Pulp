//
//  DailyView.m
//  Calendar
//
//  Created by Josh Klobe on 2/25/14.
//
//

#import "DailyView.h"
#import "DailyTableViewCell.h"
#import "AppDelegate.h"
#import "CenterViewController.h"
#import "MapAPIHandler.h"
#import "Utils.h"
#import "ThemeManager.h"


static float todoHeight = 40;
static float allDayHeight = 32;

@implementation DailyView

@synthesize eventsArray;
@synthesize theTableView;
@synthesize dailyViewDate;
@synthesize emptyCountView;
@synthesize eventsLoaded;
@synthesize testView;
@synthesize referenceMapViewFrame;

@synthesize currentReferenceEvent;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.eventsArray = [[NSMutableArray alloc] initWithCapacity:0];
        self.backgroundColor = [UIColor whiteColor]; //[UIColor colorWithRed:46.0f/255.0f green:175.0f/255 blue:152.0f/255.0f alpha:1];
        
    }
    
    return self;
}

- (void) handleEmptyPresentation
{
    if ([self.eventsArray count] == 0)
    {
        if (self.emptyCountView == nil)
            if ([self.emptyCountView superview] == nil)
            {
                UIImage *nothingImage = [UIImage imageNamed:@"nothing-today-graphic.png"];
                
                self.emptyCountView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - nothingImage.size.width / 2, self.frame.size.height / 2 - nothingImage.size.height / 2, nothingImage.size.width, nothingImage.size.height)];
                self.emptyCountView.image = nothingImage;
                [self addSubview:self.emptyCountView];
            }
    }
    else
    {
        if (self.emptyCountView != nil)
            if ([self.emptyCountView superview] != nil)
            {
                [self.emptyCountView removeFromSuperview];
                self.emptyCountView = nil;
            }
    }
    
    
    
}

-(void)unloadEvents
{
    [self.eventsArray removeAllObjects];
    [self.theTableView reloadData];
    
    self.eventsLoaded = NO;
}



-(void)loadEvents
{
    
    
    if (self.theTableView == nil)
    {
        self.theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.theTableView.backgroundColor = [UIColor clearColor];
        self.theTableView.delegate = self;
        self.theTableView.dataSource = self;
        [self addSubview:self.theTableView];
        
    }
        
    [self.eventsArray removeAllObjects];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate:self.dailyViewDate];
    [components setMinute:0];
    [components setSecond:0];
    [components setHour:0];
    NSDate *startDate = [gregorian dateFromComponents: components];
    
    [components setHour:23];
    [components setMinute:58];
    NSDate *endDate = [gregorian dateFromComponents:components];
    
    NSArray *allEvents = [[EventKitManager sharedManager] getEventsForStartDate:startDate forEndDate:endDate withCalendars:[[EventKitManager sharedManager] getEKCalendars:YES]];
    
    if (allEvents != nil)
        [self.eventsArray addObjectsFromArray:allEvents];
    
    [self handleEmptyPresentation];
    
    self.eventsLoaded = YES;
    
    NSMutableArray *allDayEvents = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < [self.eventsArray count]; i++)
    {
        CalendarEvent *calendarEvent = [self.eventsArray objectAtIndex:i];
        if ([calendarEvent isAllDay])
            [allDayEvents addObject:[self.eventsArray objectAtIndex:i]];
    }
    
    
    for (int i = 0; i < [allDayEvents count]; i++)
    {
        [self.eventsArray removeObject:[allDayEvents objectAtIndex:i]];
    }
    
    for (int i = 0; i < [allDayEvents count]; i++)
        [self.eventsArray insertObject:[allDayEvents objectAtIndex:i] atIndex:0];
    
    
   [self.theTableView reloadData];
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSInteger count = [self.eventsArray count];
    return count;
}

- (DailyTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    DailyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[DailyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.suppressMaps = self.suppressMaps;
        cell.cellStyleClear = self.cellStyleClear;
//        if (self.cellStyleClear)

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.autoresizesSubviews = NO;
        cell.parentView = self;
    }
    
    cell.theIndexPath = indexPath;
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
    
    
    CalendarEvent *calendarEvent = [self.eventsArray objectAtIndex:indexPath.row];
    [cell loadWithEvent:calendarEvent];
    
    if (![calendarEvent isAllDay] && ([[[calendarEvent getCalendar] getTitle] compare:@"TODO"] == NSOrderedSame))
        [cell setFieldsWithEvent:calendarEvent];

    
    cell.dividerView.frame = CGRectMake(0, cell.frame.size.height - 1, cell.frame.size.width, 1);
    
    [cell setLastRowStyle:((self.theTableView.contentSize.height > [[UIScreen mainScreen] bounds].size.height) && indexPath.row == [self.eventsArray count] - 1)];
    
    return cell;
}

-(void)cellDidReturnWithLocation
{
    [self.theTableView reloadData];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CalendarEvent *theEvent = [self.eventsArray objectAtIndex:indexPath.row];
    
    float height = 0;
    
    if ([theEvent isAllDay])
         height = allDayHeight;
    else if ([[[theEvent getCalendar] getTitle] compare:@"TODO"] == NSOrderedSame)
        height = todoHeight;
    else
        height = [DailyTableViewCell getDesiredCellHeightWithEvent:theEvent withIndexPath:indexPath withSuppressMaps:self.suppressMaps];
    
    
    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[MainViewController sharedMainViewController] dailyEventSelected:[self.eventsArray objectAtIndex:indexPath.row]];
}


-(void)cellButtonHitWithIndexPath:(NSIndexPath *)theIndexPath
{
    [[MainViewController sharedMainViewController] dailyEventSelected:[self.eventsArray objectAtIndex:theIndexPath.row]];
}


-(void)pulpMapViewIsInitialized
{
    
    
}

-(void)crashButtonHit
{
    
}



@end
