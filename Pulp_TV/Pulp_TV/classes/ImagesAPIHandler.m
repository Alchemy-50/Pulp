//
//  ImagesAPIHandler.m
//  Calendar
//
//  Created by Josh Klobe on 2/26/14.
//
//

#import "ImagesAPIHandler.h"
#import "WeatherView.h"


@implementation ImagesAPIHandler

+(void)makeImageRequestWithDelegate:(id)theDelegate withURL:(NSString *)imageURLString
{
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURLString]];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               [(WeatherView *)theDelegate performSelectorOnMainThread:@selector(imageReturnedWithImage:) withObject:[UIImage imageWithData:data] waitUntilDone:YES];
                                                           }
                                                       }];
    [dataTask resume];
    
    
}


@end
