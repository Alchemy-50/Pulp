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
#import "GroupDataManager.h"
#import "PulpMapView.h"
#import "MapAPIHandler.h"
#import "Utils.h"



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
@synthesize expandedMapView;
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
                [self.emptyCountView release];
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
        [self.theTableView setSeparatorColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:.05]];
        self.theTableView.pagingEnabled = NO;
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
    
    NSArray *allEvents = [[EventKitManager sharedManager] getEventsForStartDate:startDate forEndDate:endDate withCalendars:[[GroupDataManager sharedManager] getSelectedCalendars]];
    
    if (allEvents != nil)
        [self.eventsArray addObjectsFromArray:allEvents];
    
    [self handleEmptyPresentation];
    
    self.eventsLoaded = YES;
    
    NSMutableArray *allDayEvents = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < [self.eventsArray count]; i++)
        if (((EKEvent *)[self.eventsArray objectAtIndex:i]).allDay)
            [allDayEvents addObject:[self.eventsArray objectAtIndex:i]];
    
    for (int i = 0; i < [allDayEvents count]; i++)
    {
        [self.eventsArray removeObject:[allDayEvents objectAtIndex:i]];
    }
    
    for (int i = 0; i < [allDayEvents count]; i++)
        [self.eventsArray insertObject:[allDayEvents objectAtIndex:i] atIndex:0];
    
    
   [self.theTableView reloadData];
    
}



-(void)spoofArrayWithEvent:(EKEvent *)theEvent
{
    NSLog(@"theEvent.eventIdendifier: %@", theEvent.eventIdentifier);
    
    int referenceIndex = -1;
    for (int i =0 ; i < [self.eventsArray count]; i++)
    {
        EKEvent *existingEvent = [self.eventsArray objectAtIndex:i];
        
        if ([existingEvent.eventIdentifier compare:theEvent.eventIdentifier] == NSOrderedSame)
            referenceIndex = i;
    }
    
    if (referenceIndex >= 0)
        [self.eventsArray replaceObjectAtIndex:referenceIndex withObject:theEvent];
    else
        [self.eventsArray addObject:theEvent];
    
    
    
    NSArray *orderedArray = [self.eventsArray sortedArrayUsingComparator:^NSComparisonResult(EKEvent *a, EKEvent *b) {
        return  [a compareStartDateWithEvent:b];
    }];
    
    [self.eventsArray removeAllObjects];
    [self.eventsArray addObjectsFromArray:orderedArray];
    
    
    [self handleEmptyPresentation];
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
        cell = [[[DailyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.suppressMaps = self.suppressMaps;
        cell.cellStyleClear = self.cellStyleClear;
        if (self.cellStyleClear)
            tableView.separatorColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.autoresizesSubviews = NO;
        cell.parentView = self;
    }
    
    cell.theIndexPath = indexPath;
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
    
    
    EKEvent *theEvent = [self.eventsArray objectAtIndex:indexPath.row];
    [cell loadWithEvent:theEvent];
    
    if (!theEvent.allDay && ([theEvent.calendar.title compare:@"TODO"] == NSOrderedSame))
        [cell setFieldsWithEvent:theEvent];

    
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
    EKEvent *theEvent = [self.eventsArray objectAtIndex:indexPath.row];
    
    float height = 0;
    
    if (theEvent.allDay)
         height = allDayHeight;
    else if ([theEvent.calendar.title compare:@"TODO"] == NSOrderedSame)
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


-(void)mapTappedWithMapView:(MKMapView *)tappedMapView withEvent:(EKEvent *)theEvent
{
    if (self.expandedMapView == nil)
    {
        self.currentReferenceEvent = theEvent;
        //self.referenceMapViewFrame =  CGRectMake(0, [tappedMapView convertPoint:tappedMapView.frame.origin toView:nil].y - 105, tappedMapView.frame.size.width, tappedMapView.frame.size.height);
        self.referenceMapViewFrame =  CGRectMake(self.frame.size.width / 2, [tappedMapView convertPoint:tappedMapView.frame.origin toView:nil].y - 105, 0, 0);
        
        
        
        self.expandedMapView = [[PulpMapView alloc] initWithFrame:self.referenceMapViewFrame];
        self.expandedMapView.callbackDailyView = self;
        [self addSubview:self.expandedMapView];
        
        self.expandedMapView.desiredLocationCoordinate = tappedMapView.centerCoordinate;
        self.expandedMapView.destinationTitle = theEvent.title;
        self.expandedMapView.destinationSubtitle = theEvent.location;
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate registerAsLocationUpdateRespondee:self.expandedMapView];
        
        if ([self.expandedMapView superview] == nil)
            [self addSubview:self.expandedMapView];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.33];
        self.expandedMapView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        [CenterViewController sharedCenterViewController].addEventPlusImageView.alpha = 0;
        [UIView commitAnimations];
        
        UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        exitButton.frame = CGRectMake(0, 0, 100, 100);
        exitButton.backgroundColor = [UIColor blackColor];
        exitButton.alpha = .5;
        [exitButton setTitle:@"X" forState:UIControlStateNormal];
        [exitButton addTarget:self action:@selector(mapViewShouldExit:) forControlEvents:UIControlEventTouchUpInside];
        [self.expandedMapView addSubview:exitButton];
        
        UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        mapButton.frame = CGRectMake( self.frame.size.width - 100, 0, 100, 100);
        mapButton.backgroundColor = [UIColor blackColor];
        mapButton.alpha = .5;
        [mapButton setTitle:@"MAP" forState:UIControlStateNormal];
        [mapButton addTarget:self action:@selector(mapButtonHit) forControlEvents:UIControlEventTouchUpInside];
        [self.expandedMapView addSubview:mapButton];
        
        
        NSDictionary *referenceDictionary = [NSDictionary dictionaryWithDictionary:[[MapAPIHandler getSharedMapAPIHandler] getLocationDictionaryWithEvent:theEvent]];
        
        
        NSLog(@"referenceDictionary: %@", referenceDictionary);
        
        NSDictionary *geometryDictionary = [referenceDictionary objectForKey:@"geometry"];
        NSLog(@"geometryDictionary: %@", geometryDictionary);
        
        
        
        
        CLLocationCoordinate2D center;
        
        NSDictionary *locationDictionary = [geometryDictionary objectForKey:@"location"];
        NSLog(@"locationDictionary: %@", locationDictionary);
        center.latitude = [[locationDictionary objectForKey:@"lat"] doubleValue];
        center.longitude = [[locationDictionary objectForKey:@"lng"] doubleValue];

        
        
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
        myAnnotation.coordinate = center;
        
        [self.expandedMapView addAnnotation:myAnnotation];
        [self.expandedMapView setCenterCoordinate:center];
        
        MKCoordinateRegion adjustedRegion = [self.expandedMapView regionThatFits:MKCoordinateRegionMakeWithDistance(center, 800, 800)];
        adjustedRegion.span.longitudeDelta  = 0.0105;
        adjustedRegion.span.latitudeDelta  = 0.0105;
        [self.expandedMapView setRegion:adjustedRegion animated:NO];
        
        [self.expandedMapView loadAnnotations];
    }
}

-(void)pulpMapViewIsInitialized
{
    
    
}

-(void)crashButtonHit
{
    
}

-(void)mapViewShouldExit:(UIButton *)exitButton
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.33];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(mapViewDidExit)];
    exitButton.alpha = 0;
    self.expandedMapView.frame = self.referenceMapViewFrame;
    [CenterViewController sharedCenterViewController].addEventPlusImageView.alpha = 1;
    [UIView commitAnimations];
}


-(void)mapViewDidExit
{
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate unregisterAsLocationUpdateRespondee:self.expandedMapView];
    
    [self.expandedMapView removeFromSuperview];
    self.expandedMapView = nil;
}

-(void)mapButtonHit
{
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedString = [self.currentReferenceEvent.location stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    NSString *urlString = [NSString stringWithFormat:@"%@/?q=%@", @"http://maps.apple.com", encodedString];
    
    [[AppDelegate sharedDelegate] launchExternalURLString:urlString];
}


@end
