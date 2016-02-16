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
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURLString]];
    request.HTTPMethod = @"GET";
    [request setHTTPMethod: @"GET"];
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error)
     {
         [(WeatherView *)theDelegate performSelectorOnMainThread:@selector(imageReturnedWithImage:) withObject:[UIImage imageWithData:data] waitUntilDone:YES];
     }];
}


@end
