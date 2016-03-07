//
//  WeatherAPIHandler.h
//  Calendar
//
//  Created by Josh Klobe on 2/26/14.
//
//


#import <CoreLocation/CoreLocation.h>

@interface WeatherAPIHandler : NSObject

+(void)makeWeatherRequestWithDelegate:(id)theDelegate withLocation:(CLLocation *)theLocation;
+(void)makeHourlyRequest:(id)theDelegate withLocation:(CLLocation *)theLocation;
@end
