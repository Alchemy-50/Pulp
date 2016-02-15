//
//  EventCalendarUtils.h
//  AlphaRow
//
//  Created by Josh Klobe on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "CalendarEvent.h"

@interface EventCalendarUtils : NSObject
{
    

}
/*
+(NSDictionary *) jsonEncodeEvent:(EKEvent *)theEvent;
+(EKEvent *) jsonDecodeEvent:(NSDictionary *)eventDict;

+(NSDictionary *) jsonEncodeCalendarEvent:(CalendarEvent *)event;
+(CalendarEvent *) jsonDecodeCalendarEvent:(NSDictionary *)eventDict;
+(void) jsonDecodeCalendarEventArrayAndSave:(NSArray *)jsonArray;

+(void) jsonDecodeFacebookEventArrayAndSave:(NSArray *)jsonArray;

+(BOOL)jsonDecodeFacebookBirthdayArrayAndSave:(NSArray *)jsonArray;


+(NSDate *) dateFromFBBirthdayString:(NSString *)string;
+(NSString *) fbDateStringFromDate:(NSDate *)date;
*/

+(NSDate *) dateFromFBEventString:(NSString *)string;

@end
