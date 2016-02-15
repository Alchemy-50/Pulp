//
//  WeatherDataManager.m
//  Calendar
//
//  Created by Alchemy50 on 6/4/14.
//
//

#import "WeatherDataManager.h"
#import "SettingsManager.h"
@implementation WeatherDataManager

static WeatherDataManager *theSharedManager;

@synthesize tenDayForecastDictionary;
@synthesize hourlyForecastDictionary;


+(WeatherDataManager *)getSharedWeatherDataManager
{
    if (theSharedManager == nil)
    {
        theSharedManager = [[WeatherDataManager alloc] init];
        theSharedManager.tenDayForecastDictionary = [[NSMutableDictionary alloc] init];
        theSharedManager.hourlyForecastDictionary = [[NSMutableDictionary alloc] init];
    }
    
    return theSharedManager;
}


-(void)populateTenDayForecastWithDictionary:(NSDictionary *)weatherDictionary
{
    NSDictionary *forecastDictionary = [weatherDictionary objectForKey:@"forecast"];
    NSDictionary *simpleForecastDictionary = [forecastDictionary objectForKey:@"simpleforecast"];
    NSArray *forecastDayArray = [simpleForecastDictionary objectForKey:@"forecastday"];
    
    for (int i = 0; i < [forecastDayArray count]; i++)
    {
        NSDictionary *forecastDayDictionary = [forecastDayArray objectAtIndex:i];
        NSDictionary *dateDictionary = [forecastDayDictionary objectForKey:@"date"];
        id yDay = [dateDictionary objectForKeyedSubscript:@"yday"];
        
        
        [self.tenDayForecastDictionary setObject:forecastDayDictionary forKey:yDay];
    }
    
}

-(NSDictionary *)getDailyForecastDictionaryWithDate:(NSDate *)theDate
{
    NSMutableDictionary *returnDictionary = nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"D"];
    
    NSNumber *key = [NSNumber numberWithInt:[[dateFormatter stringFromDate:theDate] intValue] -1];
    
    NSDictionary *dict = [self.tenDayForecastDictionary objectForKey:key];
    if (dict != nil)
        returnDictionary = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    return returnDictionary;
}

-(void)populateHourlyForecastWithDictionary:(NSDictionary *)weatherDictionary
{
    NSArray *hourlyForecastArray = [weatherDictionary objectForKey:@"hourly_forecast"];
    
    for (int i = 0; i < [hourlyForecastArray count]; i++)
    {
        NSDictionary *dayHourlyDictionary = [hourlyForecastArray objectAtIndex:i];
        NSDictionary *fcttimeDictionary = [dayHourlyDictionary objectForKey:@"FCTTIME"];
        
        NSNumber *yday = [fcttimeDictionary objectForKey:@"yday"];
        NSNumber *yNumber = [fcttimeDictionary objectForKey:@"hour"];

        
        
        NSMutableDictionary *dayOfYearDict = [NSMutableDictionary dictionaryWithCapacity:0];
        NSDictionary *exitingDict = [self.hourlyForecastDictionary objectForKey:yday];
        if (exitingDict != nil)
            [dayOfYearDict addEntriesFromDictionary:exitingDict];
        
        [dayOfYearDict setObject:dayHourlyDictionary forKey:yNumber];
        
        [self.hourlyForecastDictionary setObject:dayOfYearDict forKey:yday];
    }
    
}

-(NSString *)getHourlyDegreesWithDate:(NSDate *)theDate
{
    NSString *returnString = nil;
    //[weatherData objectForKey:@"english"]
 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"D"];
    
    NSString *key = [NSString stringWithFormat:@"%d", [[dateFormatter stringFromDate:theDate] intValue] -1];
    
    NSDictionary *containerDictionary = [self.hourlyForecastDictionary objectForKey:key];
    if (containerDictionary != nil)
    {
        [dateFormatter setDateFormat:@"HH"];
        key = [NSString stringWithFormat:@"%d", [[dateFormatter stringFromDate:theDate] intValue]];
        containerDictionary = [containerDictionary objectForKey:key];
        if (containerDictionary != nil)
        {
            NSDictionary *tempDictionary = [containerDictionary objectForKey:@"temp"];
            if (tempDictionary != nil)
            {
                if ([[SettingsManager getSharedSettingsManager] tempInCelcius])
                    returnString = [tempDictionary objectForKey:@"metric"];
                else
                    returnString = [tempDictionary objectForKey:@"english"];
            }
        }
    }
    

    
    
    return returnString;
}

@end
