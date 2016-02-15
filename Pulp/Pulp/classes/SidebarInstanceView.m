//
//  SidebarInstanceView.m
//  Calendar
//
//  Created by Josh Klobe on 2/9/16.
//
//

#import "SidebarInstanceView.h"
#import "WeatherView.h"
#import "WeatherDataManager.h"
#import "NSString+FontAwesome.h"
#import "FAImageView.h"
#import "UIImage+FontAwesome.h"
#import "FAImageView.h"
#import "PulpFAImageView.h"
#import "ThemeManager.h"



@interface SidebarInstanceView ()
@property (nonatomic, retain) UILabel *monthLabel;
@property (nonatomic, retain) UILabel *dayOfMonthLabel;
@property (nonatomic, retain) UILabel *dayOfWeekLabel;
@property (nonatomic, retain) WeatherView *weatherView;
@property (nonatomic, retain) NSDate *referenceDate;
@end




@implementation SidebarInstanceView


-(void)loadWithDate:(NSDate *)theDate withReferenceIndex:(int)referenceIndex
{
    self.referenceDate = theDate;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    self.monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.frame.size.width, 20)];
    self.monthLabel.backgroundColor = [UIColor clearColor];
    self.monthLabel.textColor = [UIColor whiteColor];
    self.monthLabel.textAlignment = NSTextAlignmentCenter;
    self.monthLabel.font = [UIFont fontWithName:@"Lato-Bold" size:17];
    [self addSubview:self.monthLabel];
    
    
    self.dayOfMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.monthLabel.frame.origin.y + self.monthLabel.frame.size.height, self.frame.size.width, 17)];
    self.dayOfMonthLabel.backgroundColor = [UIColor clearColor];
    self.dayOfMonthLabel.textColor = [UIColor whiteColor];
    self.dayOfMonthLabel.textAlignment = NSTextAlignmentCenter;
    self.dayOfMonthLabel.font = [UIFont fontWithName:@"Lato-Bold" size:13];
    [self addSubview:self.dayOfMonthLabel];
    
    
    self.dayOfWeekLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.dayOfMonthLabel.frame.origin.y + self.dayOfMonthLabel.frame.size.height, self.frame.size.width, 15)];
    self.dayOfWeekLabel.backgroundColor = [UIColor clearColor];
    self.dayOfWeekLabel.textColor = [UIColor whiteColor];
    self.dayOfWeekLabel.textAlignment = NSTextAlignmentCenter;
    self.dayOfWeekLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12];
    [self addSubview:self.dayOfWeekLabel];
    
    
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.dayOfWeekLabel];
    
    float inset = 4.5;
    
    self.weatherView = [[WeatherView alloc] initWithFrame:CGRectMake(14, self.dayOfWeekLabel.frame.origin.y + self.dayOfWeekLabel.frame.size.height + 4, self.frame.size.width - 2 * inset, self.frame.size.width - 2 * inset)];
    self.weatherView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.weatherView];
    

    
    
    
    
    
    [dateFormatter setDateFormat:@"MMM"];
    self.monthLabel.text = [[dateFormatter stringFromDate:theDate] uppercaseString];

    
    [dateFormatter setDateFormat:@"d"];
    self.dayOfMonthLabel.text = [dateFormatter stringFromDate:theDate];

    [dateFormatter setDateFormat:@"EEE"];
    self.dayOfWeekLabel.text = [[dateFormatter stringFromDate:theDate] uppercaseString];
    
}

-(void)updateWeather
{
    [self.weatherView loadWithDictionary:[[WeatherDataManager getSharedWeatherDataManager] getDailyForecastDictionaryWithDate:self.referenceDate]];
}



@end
