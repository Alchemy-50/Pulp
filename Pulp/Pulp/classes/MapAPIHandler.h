//
//  MapAPIHandler.h
//  Calendar
//
//  Created by Alchemy50 on 6/30/14.
//
//



#import "Defs.h"
#import "DailyTableViewCell.h"
#import "CalendarEvent.h"


@interface MapAPIHandler : NSObject


+(void)getLocationForMapWithEvent:(CalendarEvent *)referenceEvent withReferenceCell:(DailyTableViewCell *)referenceCell;
+(MapAPIHandler *)getSharedMapAPIHandler;
-(NSDictionary *)getLocationDictionaryWithEvent:(CalendarEvent *)refereneceEvent;

@property (nonatomic, retain) NSMutableDictionary *allLocationDictionary;
@end
