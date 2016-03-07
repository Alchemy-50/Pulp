//
//  EventsDigester.m
//  Pulp
//
//  Created by Josh Klobe on 2/19/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "EventsDigester.h"
#import "EventKitManager.h"
#import "GroupDataManager.h"
#import "EventConverter.h"
#import "CalendarConverter.h"
@implementation EventsDigester

+(NSDictionary *)getDigestDictionary
{
    
    unsigned flags = NSCalendarUnitYear | NSCalendarUnitDay | NSCalendarUnitMonth;
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    
    
    NSDateComponents *startDateTimeComponents = [calendar components:flags fromDate:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * 10 * -1]];
    NSDateComponents *endDateTimeComponents = [calendar components:flags fromDate:[[NSDate date] dateByAddingTimeInterval:60 * 60 * 24 * 10 * 1]];
    
    
    NSDateComponents *startDateComponents = [[NSDateComponents alloc] init];
    [startDateComponents setDay:[startDateTimeComponents day] + 0];
    [startDateComponents setMonth:[startDateTimeComponents month]];
    [startDateComponents setYear:[startDateTimeComponents year]];
    [startDateComponents setHour:0];
    [startDateComponents setMinute:1];
    NSDate *startDate = [[NSCalendar currentCalendar] dateFromComponents:startDateComponents];
    
    NSDateComponents *endDateComponents = [[NSDateComponents alloc] init];
    [endDateComponents setDay:[endDateTimeComponents day] + 0+ 1];
    [endDateComponents setMonth:[endDateTimeComponents month]];
    [endDateComponents setYear:[endDateTimeComponents year]];
    [endDateComponents setHour:0];
    [endDateComponents setMinute:1];
    NSDate *endDate = [[NSCalendar currentCalendar] dateFromComponents:endDateComponents];
    
    
    
    NSArray *allEvents = [[EventKitManager sharedManager] getEventsForStartDate:startDate forEndDate:endDate withCalendars:[[GroupDataManager sharedManager] getSelectedCalendars]];
    
    //NSLog(@"allEvents: %@", allEvents);
    
    NSLog(@"1");
    NSMutableArray *ar = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < [allEvents count]; i++)
    {
        EKEvent *theEvent = [allEvents objectAtIndex:i];
        NSDictionary *dict = [EventConverter loadWithEvent:theEvent];
        [ar addObject:dict];
    }
    
    NSMutableDictionary *jsonDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    [jsonDictionary setObject:ar forKey:@"events"];
    
    
    NSMutableDictionary *calDictionaryDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *calendarsArray = [[EventKitManager sharedManager] getEKCalendars:NO];
    for (int i = 0; i < [calendarsArray count]; i++)
    {
        NSDictionary *calendarDictionary = [CalendarConverter loadWithCalendar:[calendarsArray objectAtIndex:i]];
        //NSLog(@"calendarDictionary[%d]: %@", i, calendarDictionary);
        [calDictionaryDictionary setObject:calendarDictionary forKey:[calendarDictionary objectForKey:@"calendarIdentifier"]];
        
    }
    [jsonDictionary setObject:calDictionaryDictionary forKey:@"calendars"];
    
    return jsonDictionary;
}

+(void)run
{
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSDictionary *jsonDictionary = [EventsDigester getDigestDictionary];
    
    NSLog(@"jsonDictionary: %@", jsonDictionary);
    
    //NSLog(@"ALL DONE!");
    
    
    NSData * jsonData = [NSJSONSerialization  dataWithJSONObject:jsonDictionary options:0 error:nil];
    NSString * myString = [[NSString alloc] initWithData:jsonData   encoding:NSUTF8StringEncoding];
    
        myString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)myString,
                                                                                  NULL,
                                                                                  (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                                  kCFStringEncodingUTF8 );
    
    
    NSLog(@"myString: %@", myString);
    NSLog(@" ");
    NSLog(@" ");
    NSLog(@" ");
    NSLog(@" ");
    NSLog(@" ");
    
    
    NSString *urlString = @"http://www.a50development.com.php53-23.ord1-1.websitetestlink.com/pulptest/";
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlString] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    [request setHTTPMethod:@"POST"];
    NSString *postString = [NSString stringWithFormat:@"action=put&userID=1&dictString=%@", myString];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration: defaultConfigObject delegate: nil delegateQueue: [NSOperationQueue mainQueue]];
    NSURLSessionDataTask * dataTask =[defaultSession dataTaskWithRequest:request
                                                       completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                                                           
                                                           NSString* newStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                                                           NSLog(@"put request response: %@", newStr);
                                                           
                                                           [EventsDigester makeTheGetRequest];
                                                           
                                                       }];
    
    [dataTask resume];
    
}


+(void)makeTheGetRequest
{
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
                                                           NSLog(@"responseDictionary: %@", responseDictionary);
                                                           NSLog(@"responseDictionary.keys: %@", [responseDictionary allKeys]);
                                                       
                                                           id dataBlob = [responseDictionary objectForKey:@"dataBlob"];
                                                           NSData *theData = [dataBlob dataUsingEncoding:NSUTF8StringEncoding];
                                                           id json = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
                                                           
                                                           NSLog(@"dataBlob: %@", dataBlob);
                                                           NSLog(@"dataBlob.class: %@", [dataBlob class]);
                                                           NSLog(@" ");
                                                           NSLog(@" ");
                                                           NSLog(@"json: %@", json);
                                                           
                                                       }];
    
    [dataTask resume];
    
}



@end
