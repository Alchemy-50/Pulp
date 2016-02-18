//
//  CalendarViewController.m
//  Calendar
//
//  Created by jay canty on 2/2/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "ContentContainerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "GroupDataManager.h"
#import "GroupFormatManager.h"
#import <QuartzCore/QuartzCore.h>
#import "Defs.h"
#import "Utils.h"
#import "DailyView.h"


@interface ContentContainerViewController ()

@property (nonatomic, retain) UIScrollView *theScrollView;
@property (nonatomic, retain) NSMutableDictionary *monthViewLookupDictionary;
@property (nonatomic, retain) CalendarDayView *highlightedDayView;
@property (nonatomic, retain) DailyView *dailyView;
@property (nonatomic, assign) BOOL initialized;

@end



@implementation ContentContainerViewController

static ContentContainerViewController *theStaticVC;

+(ContentContainerViewController *)sharedContainerViewController
{
    return theStaticVC;
}

-(void)reloadViews
{
    NSLog(@"IMPLEMENT ! reloadViews");
}

-(void) doLoadViews
{
    theStaticVC = self;
    self.view.backgroundColor = [UIColor clearColor];
    
    self.monthViewLookupDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    

    float height = 265 + 40;
    
    self.theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, height)];
    self.theScrollView.backgroundColor = [UIColor clearColor];
    self.theScrollView.pagingEnabled = YES;
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
        NSDate *start = [[GroupFormatManager sharedManager].dateTimeFormatter dateFromString:startString];
        
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSRange monthRange = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:start];
        NSString *endString = [NSString stringWithFormat:@"%ld-%ld-%lu 23:59:59", (long)year, (long)month, (unsigned long)monthRange.length];
        NSDate *end = [[GroupFormatManager sharedManager].dateTimeFormatter dateFromString:endString];
        
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
    
}

-(void)updateMonthViews
{
    NSLog(@"updateMonthViews!");
    
    
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

-(void) calendarDataChanged
{
    [self updateMonthViews];
    [self.dailyView.theTableView reloadData];
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
        NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
        NSLog(@"%s", __PRETTY_FUNCTION__);
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
      
    if (self.initialized)
        [self updateMonthViews];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
        NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{


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
    [dateFormatter release];
    
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







-(void)spoofCalendarDayViewWithEvent:(EKEvent *)theEvent withAction:(EKEventEditViewAction)theAction
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    CalendarMonthView *monthView = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-01 00:00:00"];
    NSString *monthLookupString = [dateFormatter stringFromDate:theEvent.startDate];
    NSDate *monthDate = [dateFormatter dateFromString:monthLookupString];
    
    
    for (id key in self.monthViewLookupDictionary)
    {
        NSDate *keyDate = [dateFormatter dateFromString:key];
        if ([keyDate compare:monthDate] == NSOrderedSame)
            monthView = [self.monthViewLookupDictionary objectForKey:key];
        
    }
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    if (monthView != nil)
    {

        
        NSMutableArray *events = [NSMutableArray arrayWithCapacity:0];
        if ([monthView.dateStringForEventDictionary objectForKey:[dateFormatter stringFromDate:theEvent.startDate]] != nil)
            [events addObjectsFromArray:[monthView.dateStringForEventDictionary objectForKey:[dateFormatter stringFromDate:theEvent.startDate]]];
        
        
        CalendarDayView *theDayView = [monthView.calendarDayViewDictionary objectForKey:[dateFormatter stringFromDate:theEvent.startDate]];
        
        if (theAction == EKEventEditViewActionSaved)
        {
            CalendarEvent *theCalendarEvent = [[CalendarEvent alloc] initWithEKEvent:theEvent];
            [events addObject:theCalendarEvent];
        }
        else if (theAction == EKEventEditViewActionDeleted)
        {
            CalendarEvent *eventToRemove = nil;
            for (int i = 0; i < [events count]; i++)
            {
                CalendarEvent *calendarEvent = [events objectAtIndex:i];
                if ([theEvent.title compare:calendarEvent.ekObject.title] == NSOrderedSame)
                    eventToRemove = calendarEvent;
            }
            
            if (eventToRemove != nil)
                [events removeObject:eventToRemove];
        }
        
        [theDayView loadEvents:events];
    }
    
    [self.dailyView loadEvents];
}



@end
