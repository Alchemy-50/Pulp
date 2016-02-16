//
//  WeatherAPIHandler.m
//  Calendar
//
//  Created by Josh Klobe on 2/26/14.
//
//

#import "WeatherAPIHandler.h"
#import <CoreLocation/CoreLocation.h>
#import "CenterViewController.h"


//a494ddf4e080c52e


@implementation WeatherAPIHandler

+(void)makeWeatherRequestWithDelegate:(id)theDelegate withLocation:(CLLocation *)theLocation
{

    NSString *latitude = [NSString stringWithFormat:@"%f", theLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", theLocation.coordinate.longitude];
    
    NSString *requestString = [NSString stringWithFormat:@"http://api.wunderground.com/api/a494ddf4e080c52e/forecast10day/q/%@,%@.json", latitude, longitude];

    NSLog(@"!makeWeatherRequestWithDelegate requestString: %@", requestString);

    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    request.HTTPMethod = @"GET";
    [request setHTTPMethod: @"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {

         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
         [theDelegate performSelectorOnMainThread:@selector(weatherDidReturnWithDictionary:) withObject:dict waitUntilDone:YES];
     }];    
}


+(void)makeHourlyRequest:(id)theDelegate withLocation:(CLLocation *)theLocation
{
    NSString *latitude = [NSString stringWithFormat:@"%f", theLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", theLocation.coordinate.longitude];
    
    NSString *requestString = [NSString stringWithFormat:@"http://api.wunderground.com/api/a494ddf4e080c52e/hourly/q/%@,%@.json", latitude, longitude];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    request.HTTPMethod = @"GET";
    [request setHTTPMethod: @"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

         
         [theDelegate performSelectorOnMainThread:@selector(handleHourlyWeatherDataWithDictionary:) withObject:dict waitUntilDone:YES];
     }];
}



@end
