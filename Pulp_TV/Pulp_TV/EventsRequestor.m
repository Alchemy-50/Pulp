//
//  EventsRequestor.m
//  Pulp_TV
//
//  Created by Josh Klobe on 3/2/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "EventsRequestor.h"
#import "CalendarEvent.h"
#import "EventKitManager.h"
#import "CalendarTVViewController.h"

@implementation EventsRequestor




+(void)makeTheGetRequest
{
    NSLog(@"makeTheGetRequest!");
    NSString *urlString = @"http://www.a50development.com.php53-23.ord1-1.websitetestlink.com/pulptest/";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"action=get&userID=1"];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:request
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           
                                                           NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                           //NSLog(@"makeTheGetRequest response: %@", newStr);
                                                           
                                                           
                                                           NSDictionary *responseDictionary  = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                               //            NSLog(@"responseDictionary: %@", responseDictionary);
                                                          // NSLog(@"responseDictionary.keys: %@", [responseDictionary allKeys]);
                                                           
                                                           id dataBlob = [responseDictionary objectForKey:@"dataBlob"];
                                                           NSData *theData = [dataBlob dataUsingEncoding:NSUTF8StringEncoding];
                                                           id json = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
                                                           
                                                           /*
                                                           NSLog(@"dataBlob: %@", dataBlob);
                                                           NSLog(@"dataBlob.class: %@", [dataBlob class]);
                                                           NSLog(@" ");
                                                           NSLog(@" ");
                                                           NSLog(@"json: %@", json);
                                                           */
                                                           
                                                           EventsRequestor *er = [[EventsRequestor alloc] init];
                                                           
                                                           [er performSelectorOnMainThread:@selector(parseDict:) withObject:json waitUntilDone:NO];
                                                           
                                                           
                                                           //[[EventsRequestor alloc]
                                                           
                                                       }];
    
    [dataTask resume];
    
}

-(void)parseDict:(NSDictionary *)json
{
    [EventsRequestor parseEventsArray:[json objectForKey:@"events"]];
    [EventsRequestor parseCalendarsDictionary:[json objectForKey:@"calendars"]];
    
    [[CalendarTVViewController sharedController] dataChanged];
    
}

+(void)parseEventsArray:(NSArray *)theEventsArray
{
    
     NSMutableArray *ar = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < [theEventsArray count]; i++)
    {
        CalendarEvent *calendarEvent = [[CalendarEvent alloc] initWithDictionary:[theEventsArray objectAtIndex:i]];
        //NSLog(@"calendarEvent[%d]: %@", i, calendarEvent);
        NSDate *startDate = [calendarEvent getStartDate];
        //NSLog(@"startDate: %@", startDate);
        [ar addObject:calendarEvent];
    }
    
    [[EventKitManager sharedManager] loadEvents:ar];
}

+(void)parseCalendarsDictionary:(NSDictionary *)calendarsDictionary
{
//    NSLog(@"%s, calendarsDictionary: %@", __PRETTY_FUNCTION__, calendarsDictionary);
    [[EventKitManager sharedManager] loadCalendars:calendarsDictionary];
}



@end
