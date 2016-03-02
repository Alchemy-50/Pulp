//
//  CalendarMonthView.m
//  AlphaRow
//
//  Created by Josh Klobe on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalendarMonthView.h"
#import <QuartzCore/QuartzCore.h>
#import "DateFormatManager.h"
#import "Circle.h"
#import "Defs.h"
#import "Utils.h"
#import "SettingsManager.h"

#import "ThemeManager.h"
#import "EventKitManager.h"


@interface CalendarMonthView ()
@property (nonatomic, retain) UILabel *theHeaderLabel;
@property (nonatomic, retain) NSMutableArray *daysLabelsArray;
@end

@implementation CalendarMonthView

@synthesize startDate;
@synthesize endDate;
@synthesize calendarDayViewDictionary;
@synthesize dateStringForEventDictionary;
@synthesize presented;

static float insetHeight = 40.0f;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    
    return self;
}

-(BOOL) drawCalendar
{
    
    if (!self.presented)
    {
        
        self.calendarDayViewDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        self.presented = YES;
        self.backgroundColor = [UIColor clearColor];
        UIColor *dayViewBackgroundColor = [UIColor colorWithWhite:1 alpha:.15];
        
        UIView *subheaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, insetHeight)];
        subheaderView.backgroundColor = [UIColor clearColor];
        [self addSubview:subheaderView];
        
        [self setHeads];
        
        NSMutableArray *daysToShowArray = [NSMutableArray arrayWithCapacity:0];
        NSCalendar *currentCalendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents =  [[NSDateComponents alloc] init];
        
        for (int i = 15; i >0 ; i--)
        {
            [dateComponents setDay: - i];
            NSDate *date = [currentCalendar dateByAddingComponents:dateComponents toDate:self.startDate  options:0];
            
            
            if (date != nil)
                [daysToShowArray addObject:date];
        }
        
        for (int i = 0; i <45; i++)
        {
            [dateComponents setDay: + i];
            NSDate *date = [currentCalendar dateByAddingComponents:dateComponents toDate:self.startDate  options:0];
            
            [daysToShowArray addObject:date];
        }
        
        NSDateFormatter *weekdayFormatter = [[NSDateFormatter alloc] init];
        [weekdayFormatter setDateFormat: @"c"];
        
        
        int searchingIndex = 1;
        if ([[SettingsManager getSharedSettingsManager] startWithMonday])
            searchingIndex = 2;
        
        
        unsigned long startIndex = [daysToShowArray indexOfObject:self.startDate];
        
        BOOL found = NO;
        while (!found){
            unsigned long dayOfWeekIndex = [[weekdayFormatter stringFromDate:[daysToShowArray objectAtIndex:startIndex]] integerValue];
            if (dayOfWeekIndex == searchingIndex)
                found = YES;
            else
                startIndex--;
        }
        
        
        NSDateFormatter *dayDateFormatter = [[NSDateFormatter alloc] init];
        [dayDateFormatter setDateFormat:@"dd"];
        
        int rowPosition = 0;
        int iter = 0;
        
        float y = [Utils getYInFramePerspective:60];
        while (rowPosition < 6)
        {
            
            
            float x = (self.frame.size.width / 7) * iter;
            float width =  (self.frame.size.width / 7);
            float height = width;
            height = width;
            
            CalendarDayView *dayView = [[CalendarDayView alloc] initWithFrame:CGRectMake(x, y, width, height) withParentView:self];
            dayView.backgroundColor = dayViewBackgroundColor;
            dayView.theDate = [daysToShowArray objectAtIndex:startIndex];
            dayView.dayLabel.text = [dayDateFormatter stringFromDate:dayView.theDate];
            [self addSubview:dayView];
            
            
            BOOL inScope = YES;
            
            NSComparisonResult comparisonResult = [dayView.theDate compare:self.startDate];
            if (comparisonResult == NSOrderedAscending)
                inScope = NO;
            
            comparisonResult = [dayView.theDate compare:self.endDate];
            if (comparisonResult == NSOrderedDescending)
                inScope = NO;
            
            
            if (inScope)
                [self.calendarDayViewDictionary setObject:dayView forKey:[[DateFormatManager sharedManager].dateFormatter stringFromDate:dayView.theDate]];
            else
            {
                dayView.dayLabel.font = [UIFont fontWithName:@"Lato-Regular" size:28 / 2];;
                dayView.dayLabel.textColor = [UIColor blackColor];
                dayView.backgroundColor = [UIColor colorWithWhite:1 alpha:.05];
                //                dayView.backgroundColor = [UIColor clearColor];
            }
            
            
            startIndex++;
            iter++;
            if (iter == 7)
            {
                rowPosition++;
                iter = 0;
                y = dayView.frame.origin.y + dayView.frame.size.height;
            }
            
            if (rowPosition == 5 && iter == 0)
                break;
        }
        
        
        
        //        asdf
        
        
        for (int i = 0; i < 7; i++)
        {
            NSDate *unusedDay = [daysToShowArray objectAtIndex:startIndex];
            
            NSComparisonResult comparisonResult = [unusedDay compare:self.endDate];
            if (comparisonResult == NSOrderedAscending)
            {
                NSDateFormatter *daysDateFormatter = [[NSDateFormatter alloc] init];
                [daysDateFormatter setDateFormat:@"dd"];
                
                NSCalendar *currentCalendar = [NSCalendar currentCalendar];
                NSDateComponents *dateComponents =  [[NSDateComponents alloc] init];
                [dateComponents setDay: - 7];
                NSDate *date = [currentCalendar dateByAddingComponents:dateComponents toDate:unusedDay  options:0];
                
                CalendarDayView *dayView = [self.calendarDayViewDictionary objectForKey:[[DateFormatManager sharedManager].dateFormatter stringFromDate:date]];
                
                CalendarDoubleDayView *doubleDayView = [[CalendarDoubleDayView alloc] initWithFrame:dayView.frame withParentView:self];
                doubleDayView.backgroundColor = [UIColor clearColor];;
                doubleDayView.parentView = self;
                doubleDayView.dayLabel.text = dayView.dayLabel.text;
                doubleDayView.theDate = dayView.theDate;
                doubleDayView.dayLabel2.text = [daysDateFormatter stringFromDate:unusedDay];
                doubleDayView.theDate2 = unusedDay;
                
                
                [self.calendarDayViewDictionary setObject:doubleDayView forKey:[[DateFormatManager sharedManager].dateFormatter stringFromDate:dayView.theDate]];
                [self.calendarDayViewDictionary setObject:doubleDayView forKey:[[DateFormatManager sharedManager].dateFormatter stringFromDate:unusedDay]];
                
                
                [self addSubview:doubleDayView];
                [dayView removeFromSuperview];
            }
            
            startIndex++;
        }
        
        return YES;
    }
    
    else
        return NO;
}

-(void)loadEvents
{
    NSDictionary *dict = [[EventKitManager sharedManager] fetchEventsWithStartDate:self.startDate withEndDate:self.endDate withSelectedCalendars:[[EventKitManager sharedManager] getEKCalendars:YES]];
    for (id key in dict)
    {
        CalendarDayView *dayView = [self.calendarDayViewDictionary objectForKey:key];
        [dayView loadEvents:[dict objectForKey:key]];
        
    }
}



-(void)setHeads
{
    
    if (self.theHeaderLabel != nil)
    {
        [self.theHeaderLabel removeFromSuperview];
        self.theHeaderLabel = nil;
    }
    
    self.theHeaderLabel = [[UILabel alloc] initWithFrame:CGRectMake(7,9, self.frame.size.width - 20, 24)];
    self.theHeaderLabel.backgroundColor = [UIColor clearColor];
    self.theHeaderLabel.textColor = [UIColor whiteColor];
    self.theHeaderLabel.textAlignment = NSTextAlignmentLeft;
    self.theHeaderLabel.font = [UIFont fontWithName:@"Lato-Bold" size:20];
    [self addSubview:self.theHeaderLabel];
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM yyyy"];
    self.theHeaderLabel.text = [[dateFormatter stringFromDate:self.startDate] uppercaseString];
    [self getSubheaderViewWithY:41];
    
    
}

-(void)getSubheaderViewWithY:(float)y
{
    
    if (self.daysLabelsArray == nil)
        self.daysLabelsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < [self.daysLabelsArray count]; i++)
    {
        UIView *labelView = [self.daysLabelsArray objectAtIndex:i];
        if (labelView != nil)
            if (labelView.superview != nil)
            {
                [labelView removeFromSuperview];
                labelView = nil;
            }
        
    }
    
    float barHeight = 14;
    
    NSArray *labelsArray = [NSArray arrayWithObjects:@"SUN", @"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT", nil];
    
    if ([[SettingsManager getSharedSettingsManager] startWithMonday])
        labelsArray = [NSArray arrayWithObjects:@"MON", @"TUE", @"WED", @"THU", @"FRI", @"SAT", @"SUN", nil];
    
    
    for (int i = 0; i < [labelsArray count]; i++)
    {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * self.frame.size.width /  ([labelsArray count]), y, (self.frame.size.width / [labelsArray count]), barHeight)];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"Lato-Regular" size:10];
        label.text = [labelsArray objectAtIndex:i];
        label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:label];
        
        [[ThemeManager sharedThemeManager] registerSecondaryObject:label];
        [self.daysLabelsArray addObject:label];
    }
    
    
}

-(void) cleanUp
{
    if (self.presented)
    {
        self.presented = NO;
        
        NSArray *viewKeysArray = [self.calendarDayViewDictionary allKeys];
        
        for (int i = 0; i < [viewKeysArray count]; i++)
        {
            UIView *theView = [self.calendarDayViewDictionary objectForKey:[viewKeysArray objectAtIndex:i]];
            if ([theView isKindOfClass:[CalendarDayView class]])
            {
                CalendarDayView *calendarDayView = (CalendarDayView *)theView;
                [calendarDayView destroyViews];
                
            }
            
            
            [theView removeFromSuperview];
            theView = nil;
            
        }
    }
}



@end
