//
//  MapAPIHandler.m
//  Calendar
//
//  Created by Alchemy50 on 6/30/14.
//
//

#import "MapAPIHandler.h"
#import <MapKit/MapKit.h>

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

+(void)getLocationForMapWithEvent:(EKEvent *)referenceEvent withReferenceCell:(DailyTableViewCell *)referenceCell
{
    // FIXME: re-implement
    /*
    
    [MapAPIHandler getSharedMapAPIHandler];
    
    NSString *authID =  @"8099735d-f90d-47f5-a748-4b203881a0b2";
    NSString *authToken = @"EEYP3QqoGpaPxNOd143i";
    
    
    NSString *esc_addr =  [referenceEvent.location stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSString *req = [NSString stringWithFormat:@"http://maps.google.com/maps/api/geocode/json?sensor=false&address=%@", esc_addr];
    NSString *req = [NSString stringWithFormat:@"https://api.smartystreets.com/street-address?auth-id=%@&auth-token=%@&street=%@&candidates=10", authID, authToken, esc_addr];
//    NSLog(@"req!: %@", req);

    NSMutableURLRequest *URLRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:req]];
    URLRequest.HTTPMethod = @"GET";
    
    MapAPIHandler *apiHandler = [[MapAPIHandler alloc] init];
    apiHandler.delegate = referenceCell;
    apiHandler.requestContextObject = referenceEvent;
    apiHandler.theWebRequest = [SMWebRequest requestWithURLRequest:URLRequest delegate:apiHandler context:NULL];
    [apiHandler.theWebRequest addTarget:apiHandler action:@selector(getLocationForMapWithEventFinished:) forRequestEvents:SMWebRequestEventAllEvents];
    [apiHandler.theWebRequest start];
    
    [theStaticHandler.holderArray addObject:apiHandler];
     */
}



-(void)getLocationForMapWithEventFinished:(id)obj
{
    // FIXME: re-implement
    
    /*
//    NSLog(@"getLocationForMapWithEventFinished: %@", obj);
    EKEvent *referenceEvent = (EKEvent *)self.requestContextObject;
    DailyTableViewCell *returnCell = (DailyTableViewCell *)self.delegate;
    
    if (self.responseData != nil)
    {
        NSArray *array = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingAllowFragments error:nil];

        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
        if ([array count] > 0)
            [dict addEntriesFromDictionary:[array objectAtIndex:0]];

        [[MapAPIHandler getSharedMapAPIHandler].allLocationDictionary setObject:[NSDictionary dictionaryWithDictionary:dict] forKey:referenceEvent.eventIdentifier];
        [returnCell eventLocationDataReturned];        
    }
    [theStaticHandler.holderArray removeObject:self];
     
     */
}

-(NSDictionary *)getLocationDictionaryWithEvent:(EKEvent *)refereneceEvent
{
//    NSLog(@"!self.allLocationDictionary: %@", self.allLocationDictionary);
    return [self.allLocationDictionary objectForKey:refereneceEvent.eventIdentifier];
}








@end
