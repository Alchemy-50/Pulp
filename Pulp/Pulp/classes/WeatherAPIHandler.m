//
//  WeatherAPIHandler.m
//  Calendar
//
//  Created by Josh Klobe on 2/26/14.
//
//

#import "WeatherAPIHandler.h"
#import <CoreLocation/CoreLocation.h>


//a494ddf4e080c52e


@implementation WeatherAPIHandler

+(void)makeWeatherRequestWithDelegate:(id)theDelegate withLocation:(CLLocation *)theLocation
{
 
    // FIXME: re-implement
    /*
    NSString *latitude = [NSString stringWithFormat:@"%f", theLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", theLocation.coordinate.longitude];
    
    //NSString *requestString = [NSString stringWithFormat:@"http://api.wunderground.com/api/a494ddf4e080c52e/conditions/q/35.689,139.691.json"];
    NSString *requestString = [NSString stringWithFormat:@"http://api.wunderground.com/api/a494ddf4e080c52e/forecast10day/q/%@,%@.json", latitude, longitude];

    NSLog(@"!makeWeatherRequestWithDelegate requestString: %@", requestString);

    WeatherAPIHandler *apiHandler = [[WeatherAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    
    URLRequest.HTTPMethod = @"GET";
    
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makeWeatherRequestFinished:) forRequestEvents:SMWebRequestEventAllEvents];
    [apiHandler.theWebRequest start];
    */
    
}
-(void)makeWeatherRequestFinished:(id)obj
{
    // FIXME: re-implement
    
    /*
    if (self.responseData != nil)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingAllowFragments error:nil];
        [self.delegate weatherDidReturnWithDictionary:dict];
    }
     
     */
}


+(void)makeHourlyRequest:(id)theDelegate withLocation:(CLLocation *)theLocation
{
    // FIXME: re-implement
    
    /*
    NSString *latitude = [NSString stringWithFormat:@"%f", theLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", theLocation.coordinate.longitude];
    
    //http://api.wunderground.com/api/a494ddf4e080c52e/hourly/q/CA/San_Francisco.json
    NSString *requestString = [NSString stringWithFormat:@"http://api.wunderground.com/api/a494ddf4e080c52e/hourly/q/%@,%@.json", latitude, longitude];

    WeatherAPIHandler *apiHandler = [[WeatherAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    
    URLRequest.HTTPMethod = @"GET";
    
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makeHourlyWeatherRequestFinished:) forRequestEvents:SMWebRequestEventAllEvents];
    [apiHandler.theWebRequest start];

     */
}

-(void)makeHourlyWeatherRequestFinished:(id)obj
{
 // FIXME: re-implement
    /*
    if (self.responseData != nil)
    {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingAllowFragments error:nil];
        
//        NSLog(@"hourly responseDict: %@", dict);
        [self.delegate handleHourlyWeatherDataWithDictionary:dict];
    }
*/
    
}



@end
