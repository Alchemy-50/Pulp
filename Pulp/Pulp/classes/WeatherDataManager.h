//
//  WeatherDataManager.h
//  Calendar
//
//  Created by Alchemy50 on 6/4/14.
//
//

#import <Foundation/Foundation.h>

@interface WeatherDataManager : NSObject


+(WeatherDataManager *) getSharedWeatherDataManager;

-(void)populateTenDayForecastWithDictionary:(NSDictionary *)theDictionary;
-(NSDictionary *)getDailyForecastDictionaryWithDate:(NSDate *)theDate;
-(void)populateHourlyForecastWithDictionary:(NSDictionary *)weatherDictionary;
-(NSString *)getHourlyDegreesWithDate:(NSDate *)theDate;

@property (nonatomic, retain) NSMutableDictionary *tenDayForecastDictionary;
@property (nonatomic, retain) NSMutableDictionary *hourlyForecastDictionary;

@end
