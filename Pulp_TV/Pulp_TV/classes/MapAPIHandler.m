//
//  MapAPIHandler.m
//  Calendar
//
//  Created by Alchemy50 on 6/30/14.
//
//

#import "MapAPIHandler.h"

#import "Utils.h"

#define API_KEY @"AIzaSyBm6NB4P0jnH8TTskQCILjrCvJ97y0X6xw"

#define ROOT_URI @"https://maps.googleapis.com/maps/api/geocode/json?address="

@interface MapAPIHandler ()

@property (nonatomic, retain) NSMutableArray *holderArray;

@end

@implementation MapAPIHandler

static MapAPIHandler *theStaticHandler;

+(MapAPIHandler *)getSharedMapAPIHandler
{
    if (theStaticHandler == nil)
    {
        theStaticHandler = [[MapAPIHandler alloc] init];
        theStaticHandler.allLocationDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        theStaticHandler.holderArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return theStaticHandler;
}

+(void)getLocationForMapWithEvent:(CalendarEvent *)referenceEvent withReferenceCell:(DailyTableViewCell *)referenceCell
{
    NSString *addressString = [Utils urlencode:[referenceEvent getTheLocation]];
    NSString *urlString = [NSString stringWithFormat:@"%@%@&key=%@", ROOT_URI, addressString, API_KEY];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    
    
    NSMutableURLRequest * urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:urlRequest
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           if(error == nil)
                                                           {
                                                               NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                                                               
                                                               if (dict != nil)
                                                               {
                                                                   NSArray *resultsArray = [dict objectForKey:@"results"];
                                                                   if (resultsArray != nil)
                                                                   if ([resultsArray count] > 0)
                                                                   {
                                                                       NSDictionary *refereceDict = [resultsArray objectAtIndex:0];
                                                                       
                                                                       [[MapAPIHandler getSharedMapAPIHandler].allLocationDictionary setObject:[NSDictionary dictionaryWithDictionary:refereceDict] forKey:[referenceEvent getTheLocation]];
                                                                       [referenceCell eventLocationDataReturned];
                                                                   }
                                                               }
                                                               
                                                           }
                                                       }];
    [dataTask resume];
    

}


-(NSDictionary *)getLocationDictionaryWithEvent:(CalendarEvent *)refereneceEvent
{
//    NSLog(@"!self.allLocationDictionary: %@", self.allLocationDictionary);
    return [self.allLocationDictionary objectForKey:[refereneceEvent getTheLocation]];
}








@end
