//
//  CenterViewController.m
//  Calendar
//
//  Created by Josh Klobe on 2/9/16.
//
//

#import "DailyViewController.h"
#import "DailyTableViewCell.h"
#import "EventKitManager.h"
#import "DailyView.h"
#import "WeatherAPIHandler.h"
#import "AppDelegate.h"
#import "WeatherDataManager.h"
#import "MainViewController.h"
#import "Defs.h"
#import "PulpFAImageView.h"
#import "ThemeManager.h"
#import "FullCalendarViewController.h"


@interface DailyViewController ()

@end

@implementation DailyViewController


static DailyViewController *globalViewController;

+(DailyViewController *)sharedDailyViewController{
    
    return globalViewController;
}


-(void)loadViews
{
    self.view.autoresizesSubviews = NO;
    self.view.backgroundColor = [UIColor colorWithRed:46.0f/255.0f green:175.0f/255 blue:152.0f/255.0f alpha:1];
    
    
    globalViewController = self;
    
    
    self.dayDatesArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.dayDatesDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.currentVisibleIndex = -1;
    
    
    self.contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.contentScrollView.delegate = self;
    self.contentScrollView.backgroundColor = [UIColor redColor];
    self.contentScrollView.autoresizesSubviews = NO;
    [self.view addSubview:self.contentScrollView];
    
    
    UIImage *plusImage = [UIImage imageNamed:@"add-event-plus_new.png"];
    float desiredHeight = plusImage.size.width + 15;
    CGSize actualSize = [PulpFAImageView getImageSizeFromString:@"fa-plus-circle" withDesiredHeight:desiredHeight];
    
    float inset = 1.35;
    
    self.addEventPlusImageView = [[PulpFAImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width - actualSize.height * inset, self.view.frame.size.height - actualSize.height * inset, actualSize.width, actualSize.height)];
    self.addEventPlusImageView.referenceString = @"fa-plus-circle";
    self.addEventPlusImageView.desiredHeight = desiredHeight;
    [self.view addSubview:self.addEventPlusImageView];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.addEventPlusImageView];

    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(self.addEventPlusImageView.frame.origin.x, self.addEventPlusImageView.frame.origin.y, self.addEventPlusImageView.frame.size.width, self.addEventPlusImageView.frame.size.height)];
    aView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:aView];
    
     
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    int iter = 0;
    DailyView *theView = nil;
    
    for (int i = -365; i < 365; i++)
    {
        NSDate *theDate = [NSDate date];
        theDate = [theDate dateByAddingTimeInterval:i * 60 * 60 * 24];
        NSString *dateKey = [dateFormatter stringFromDate:theDate];
        
        theView = [[DailyView alloc] initWithFrame:CGRectMake(0, iter *self.contentScrollView.frame.size.height, self.contentScrollView.frame.size.width, self.contentScrollView.frame.size.height)];
        theView.dailyViewDate = theDate;
        [self.contentScrollView addSubview:theView];
        
        
        [self.dayDatesDictionary setObject:theView forKey:dateKey];
        [self.dayDatesArray addObject:theView];
        
        if (i == 0)
            self.currentView = theView;
        
        iter++;
    }
    
    self.contentScrollView.contentSize = CGSizeMake(5, theView.frame.origin.y + theView.frame.size.height);
    
        
    [self scrollToDate:[NSDate date]];
    
}



-(void)scrollToDate:(NSDate *)theDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *key = [dateFormatter stringFromDate:theDate];
    DailyView *theView = [self.dayDatesDictionary objectForKey:key];

    
    if (theView != nil)
        [self.contentScrollView setContentOffset:CGPointMake(0,theView.frame.origin.y) animated:YES];
    



    NSUInteger referenceIndex = [self.dayDatesArray indexOfObject:theView];
    
    NSMutableArray *viewsToLoadArray = [NSMutableArray arrayWithCapacity:0];
    [viewsToLoadArray addObject:[self.dayDatesArray objectAtIndex:referenceIndex]];
    
    if (referenceIndex > 0)
        [viewsToLoadArray addObject:[self.dayDatesArray objectAtIndex:referenceIndex - 1]];
    if (referenceIndex < [self.dayDatesArray count] - 1)
        [viewsToLoadArray addObject:[self.dayDatesArray objectAtIndex:referenceIndex + 1]];
    
    
    for (int i = 0; i < [self.dayDatesArray count]; i++)
    {
        DailyView *theView = [self.dayDatesArray objectAtIndex:i];        
        
        if ([viewsToLoadArray containsObject:theView])
            [theView loadEvents];
        else
            [theView unloadEvents];
    }
     
    
}





-(void)refreshContent
{
//    [self presentAndHideDailyViews:YES withIndex:[self.dayDatesArray indexOfObject:[self getVisibleDailyView]]];
}



-(void)positionUpdatedWithLocation:(CLLocation *)latestLocation;
{
    self.theLatestLocation = latestLocation;
    if (!self.hasRunWeather)
    {
        self.hasRunWeather = YES;
        [self runWeatherReport];
    }
}

-(void)runWeatherReport
{
    [WeatherAPIHandler makeWeatherRequestWithDelegate:self withLocation:self.theLatestLocation];
    [WeatherAPIHandler makeHourlyRequest:self withLocation:self.theLatestLocation];
}


- (DailyView *) getVisibleDailyView
{
    DailyView *returnView = nil;
    
    NSArray *subviewsArray = [self.contentScrollView subviews];
    if (self.currentVisibleIndex < [subviewsArray count] && self.currentVisibleIndex >= 0)
    {
        DailyView *dailyView = [[self.contentScrollView subviews] objectAtIndex:self.currentVisibleIndex];
        if ([dailyView isKindOfClass:[DailyView class]])
            returnView = dailyView;
    }
    
    return returnView;
}



-(void)weatherDidReturnWithDictionary:(NSDictionary *)weatherDictionary
{
    [[WeatherDataManager getSharedWeatherDataManager] populateTenDayForecastWithDictionary:weatherDictionary];
    [self.centerSidebarView updateWeatherData];
//    [self.dailyHeaderView updateWeatherData];
    
}

-(void) handleHourlyWeatherDataWithDictionary:(NSDictionary *)theDict
{
    [[WeatherDataManager getSharedWeatherDataManager] populateHourlyForecastWithDictionary:theDict];
}



@end
