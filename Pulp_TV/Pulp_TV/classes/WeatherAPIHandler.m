//
//  WeatherAPIHandler.m
//  Calendar
//
//  Created by Josh Klobe on 2/26/14.
//
//

#import "WeatherAPIHandler.h"
#import <CoreLocation/CoreLocation.h>
#import "DailyViewController.h"


//a494ddf4e080c52e


@implementation WeatherAPIHandler

+(void)makeWeatherRequestWithDelegate:(id)theDelegate withLocation:(CLLocation *)theLocation
{
    NSString *latitude = [NSString stringWithFormat:@"%f", theLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", theLocation.coordinate.longitude];
    
    NSString *requestString = [NSString stringWithFormat:@"http://api.wunderground.com/api/a494ddf4e080c52e/forecast10day/q/%@,%@.json", latitude, longitude];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                               [theDelegate performSelectorOnMainThread:@selector(weatherDidReturnWithDictionary:) withObject:dict waitUntilDone:YES];
                                                               
                                                           }
                                                       }];
    [dataTask resume];
}



+(void)makeHourlyRequest:(id)theDelegate withLocation:(CLLocation *)theLocation
{
    NSString *latitude = [NSString stringWithFormat:@"%f", theLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", theLocation.coordinate.longitude];
    
    NSString *requestString = [NSString stringWithFormat:@"http://api.wunderground.com/api/a494ddf4e080c52e/hourly/q/%@,%@.json", latitude, longitude];
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestString]];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                               [theDelegate performSelectorOnMainThread:@selector(handleHourlyWeatherDataWithDictionary:) withObject:dict waitUntilDone:YES];
                                                           }
                                                       }];
    [dataTask resume];

    
    
    
}



@end
