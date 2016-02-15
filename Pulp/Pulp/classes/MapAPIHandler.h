//
//  MapAPIHandler.h
//  Calendar
//
//  Created by Alchemy50 on 6/30/14.
//
//


#import <MapKit/MapKit.h>
#import <EventKit/EventKit.h>
#import "DailyTableViewCell.h"

@interface MapAPIHandler : NSObject


+(void)getLocationForMapWithEvent:(EKEvent *)referenceEvent withReferenceCell:(DailyTableViewCell *)referenceCell;
+(MapAPIHandler *)getSharedMapAPIHandler;
-(NSDictionary *)getLocationDictionaryWithEvent:(EKEvent *)refereneceEvent;

@property (nonatomic, retain) NSMutableDictionary *allLocationDictionary;
@end
