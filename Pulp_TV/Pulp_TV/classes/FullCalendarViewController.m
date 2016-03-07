//
//  FullCalendarViewController.m
//  Calendar
//
//  Created by Alchemy50 on 5/27/14.
//
//

#import "FullCalendarViewController.h"

#import "AppDelegate.h"
#import "Defs.h"
#import "ThemeManager.h"
#import "AllCalendarButtonView.h"
#import "CalendarManagementViewController.h"
#import "Utils.h"
#import "DailyView.h"
#import "DateFormatManager.h"
#import "FullCalendarScrollView.h"



@interface FullCalendarViewController ()

@property (nonatomic, retain) FullCalendarScrollView *theScrollView;
@property (nonatomic, retain) NSMutableDictionary *monthViewLookupDictionary;
@property (nonatomic, retain) CalendarDayView *highlightedDayView;
@property (nonatomic, retain) DailyView *dailyView;
@property (nonatomic, assign) BOOL initialized;

@end

@implementation FullCalendarViewController


float theTransitionTime = .22;

static FullCalendarViewController *staticVC;

+(FullCalendarViewController *)sharedContainerViewController
{
    return staticVC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        staticVC = self;
    }
    return self;
}


-(void) dataChanged
{
    [self updateMonthViews:YES];
    [self.dailyView.theTableView reloadData];
}



-(void)doLoadViews
{

    
    [[ThemeManager sharedThemeManager] registerPrimaryObject:self];
    [ThemeManager addCoverViewToView:self.view];
    
    
    UIView *sharedButtonView = [AllCalendarButtonView sharedButtonView];
    [self.view addSubview:sharedButtonView];
    
    
    
    self.monthViewLookupDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    float circleHeight = self.view.frame.size.width / 7;
    float height = [Utils getYInFramePerspective:26] + (circleHeight * 5);
    
    
    self.theScrollView = [[FullCalendarScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width,height)];
    self.theScrollView.backgroundColor = [UIColor clearColor];
    self.theScrollView.delegate = self;
    [self.view addSubview:self.theScrollView];
    
    
    unsigned flags = NSCalendarUnitYear;
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents* travelDateTimeComponents = [calendar components:flags fromDate:[NSDate date]];
    NSInteger year = [travelDateTimeComponents year] - 3;
    NSInteger month = 1;
    
    float y = 0;
    
    for (int i = 0; i < 12 * 6; i++)
    {
        NSString *startString = [NSString stringWithFormat:@"%ld-%ld-01 00:00:00", (long)year, (long)month];
        NSDate *start = [[DateFormatManager sharedManager].dateTimeFormatter dateFromString:startString];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSRange monthRange = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:start];
        NSString *endString = [NSString stringWithFormat:@"%ld-%ld-%lu 23:59:59", (long)year, (long)month, (unsigned long)monthRange.length];
        NSDate *end = [[DateFormatManager sharedManager].dateTimeFormatter dateFromString:endString];
        
        CalendarMonthView *calendarMonthView = [[CalendarMonthView alloc] initWithFrame:CGRectMake(0, y, self.view.frame.size.width, self.theScrollView.frame.size.height)];
        calendarMonthView.autoresizesSubviews = NO;
        calendarMonthView.backgroundColor = [UIColor clearColor];
        calendarMonthView.startDate = start;
        calendarMonthView.endDate = end;
        [self.theScrollView addSubview:calendarMonthView];
        [self.monthViewLookupDictionary setObject:calendarMonthView forKey:startString];
        
        
        
        if (month == 12)
        {
            year++;
            month = 1;
        }
        else
            month++;
        
        y = calendarMonthView.frame.origin.y + calendarMonthView.frame.size.height;
        
        self.theScrollView.contentSize = CGSizeMake(0,y);
    }
    
    self.dailyView = [[DailyView alloc] initWithFrame:CGRectMake(0, self.theScrollView.frame.size.height, self.theScrollView.frame.size.width, self.view.frame.size.height - self.theScrollView.frame.size.height)];
    self.dailyView.suppressMaps = YES;
    self.dailyView.backgroundColor = [UIColor clearColor];
    self.dailyView.cellStyleClear = YES;
    [self.view addSubview:self.dailyView];
    
    [self calendarShouldScrollToDate:[NSDate date]];
    
    [self setDailyBorderWithDate:[NSDate date]];
    self.dailyView.dailyViewDate = [NSDate date];
    [self.dailyView loadEvents];
    
    
    self.initialized = YES;
    
    
    UIButton *calButton = [UIButton buttonWithType:UIButtonTypeCustom];
    calButton.backgroundColor = [UIColor clearColor];
    [calButton addTarget:[CalendarManagementViewController sharedCalendarManagementViewController] action:@selector(doPresent) forControlEvents:UIControlEventTouchUpInside];
    calButton.frame = CGRectMake(sharedButtonView.frame.origin.x, 0, sharedButtonView.frame.size.width, sharedButtonView.frame.origin.y + sharedButtonView.frame.size.height + 5);
    [self.view addSubview:calButton];

    
}

-(void)updateMonthViews:(BOOL)doRedraw
{
    int index = [[NSNumber numberWithFloat:self.theScrollView.contentOffset.y / self.theScrollView.frame.size.height] intValue] + 1;
    
    NSArray *subviewsArray = [self.theScrollView subviews];
    
    NSMutableArray *presentArray = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = index - 2; i < index+2; i++)
        if (i > 0 && i < [subviewsArray count])
            [presentArray addObject:[subviewsArray objectAtIndex:i]];
    
    
    for (int i =0; i < [subviewsArray count]; i++)
    {
        CalendarMonthView *calendarMonthView = [subviewsArray objectAtIndex:i];
        if ([calendarMonthView isKindOfClass:[CalendarMonthView class]])
        {
            if (doRedraw)
                [calendarMonthView cleanUp];
            
            if ([presentArray containsObject:calendarMonthView])
            {
                if ([calendarMonthView drawCalendar])
                    [calendarMonthView loadEvents];
            }
            else
                [calendarMonthView cleanUp];
        }
    }
    
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.initialized)
        [self updateMonthViews:NO];
    
    
    int index = [[NSNumber numberWithFloat:roundf(self.theScrollView.contentOffset.y / self.theScrollView.frame.size.height)] intValue];
    NSArray *subviewsArray = [self.theScrollView subviews];
    CalendarMonthView *calendarMonthView = [subviewsArray objectAtIndex:index];
    NSDate *referenceDate = calendarMonthView.startDate;
    NSDate *today = [NSDate date];
    NSComparisonResult comparisonResult = [calendarMonthView.startDate compare:today];
    if (comparisonResult == NSOrderedAscending)
    {
        comparisonResult = [calendarMonthView.endDate compare:today];
        if (comparisonResult == NSOrderedDescending)
            referenceDate = today;
    }
    
    [self setDailyBorderWithDate:referenceDate];
    self.dailyView.dailyViewDate = referenceDate;
    [self.dailyView loadEvents];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    float f = scrollView.contentOffset.y / scrollView.frame.size.height;
    float theRintF = rintf(f);
    float rem = theRintF - f;
    rem = fabsf(rem);
    
    if (rem > .001)
    {
        if ([AllCalendarButtonView sharedButtonView].alpha == 1)
            [AllCalendarButtonView sharedButtonView].alpha = 0;
    }
    else
    {
        if ([AllCalendarButtonView sharedButtonView].alpha == 0)
            [AllCalendarButtonView sharedButtonView].alpha = 1;
    }
        

    
}

-(void)calendarShouldScrollToDate:(NSDate *)theDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM"];
    NSInteger monthInt = [[dateFormatter stringFromDate:theDate] integerValue];
    [dateFormatter setDateFormat:@"yyyy-MM-01 00:00:00"];
    NSString *monthString = [dateFormatter stringFromDate:theDate];
    monthString = [monthString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"0%ld", (long)monthInt] withString:[NSString stringWithFormat:@"%ld", (long)monthInt]];
    
    
    CalendarMonthView *calendarMonthView = [self.monthViewLookupDictionary objectForKey:monthString];
    [self.theScrollView setContentOffset:CGPointMake(0, calendarMonthView.frame.origin.y) animated:YES];
    
}

-(void)navigateToToday
{
    CalendarDayView *theDayView = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *todayKey = [dateFormatter stringFromDate:[NSDate date]];
    
    [self setDailyBorderWithDateString:todayKey];
    
    for (id key in self.monthViewLookupDictionary)
    {
        CalendarMonthView *monthView = [self.monthViewLookupDictionary objectForKey:key];
        
        if ([monthView.calendarDayViewDictionary objectForKey:todayKey] != nil)
            theDayView = [monthView.calendarDayViewDictionary objectForKey:todayKey];
    }
    
    
    [self dayViewSelected:theDayView];
}


- (void) dayViewSelected:(CalendarDayView *)theDayView
{
    [self setDailyBorderWithDate:theDayView.theDate];
    self.dailyView.dailyViewDate = theDayView.theDate;
    [self.dailyView loadEvents];
}



-(CalendarMonthView *)setDailyBorderWithDate:(NSDate *)theDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    id ret = [self setDailyBorderWithDateString:[dateFormatter stringFromDate:theDate]];
    
    return ret;
}


-(CalendarMonthView *)setDailyBorderWithDateString:(NSString *)dateString
{
    id ret = nil;
    
    if (self.highlightedDayView != nil)
        [self.highlightedDayView setUnselected];
    
    for (id key in self.monthViewLookupDictionary)
    {
        CalendarMonthView *monthView = [self.monthViewLookupDictionary objectForKey:key];
        
        if ([monthView isKindOfClass:[CalendarMonthView class]])
        {
            for (NSString *key in (monthView.calendarDayViewDictionary))
            {
                CalendarDayView *theDayView = [monthView.calendarDayViewDictionary objectForKey:key];
                if (theDayView)
                    if (theDayView != nil)
                        if ([theDayView isKindOfClass:[CalendarDayView class]])
                        {
                            if ([key compare:dateString] == NSOrderedSame)
                            {
                                [theDayView setSelected];
                                self.highlightedDayView = theDayView;
                                ret = monthView;
                            }
                            else if (theDayView.layer.borderWidth == 3.5f)
                                [theDayView setUnselected];
                        }
            }
        }
    }
    return ret;
}














@end
