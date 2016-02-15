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
    NSLog(@"gotta implement me");
    
    // FIXME: re-implement
    
    
    /*
    ImagesAPIHandler *apiHandler = [[ImagesAPIHandler alloc] init];
    apiHandler.delegate = theDelegate;
    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:imageURLString]];
    
    URLRequest.HTTPMethod = @"GET";
    
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(makeImageRequestWithURLFinished:) forRequestEvents:SMWebRequestEventAllEvents];
    [apiHandler.theWebRequest start];
    */
}


-(void)makeImageRequestWithURLFinished:(id)obj
{
//    [(WeatherView *)self.delegate imageReturnedWithImage:[UIImage imageWithData:self.responseData]];
}
@end
