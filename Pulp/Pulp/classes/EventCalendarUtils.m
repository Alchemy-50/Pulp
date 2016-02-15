//
//  EventCalendarUtils.m
//  AlphaRow
//
//  Created by Josh Klobe on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EventCalendarUtils.h"
#import "GroupDataManager.h"
#import "EventKitManager.h"



@implementation EventCalendarUtils

// ekevent
#define EVENT_TITLE_KEY @"eventtitle"
#define EVENT_LOCATION_KEY @"eventtlocationitle"
#define EVENT_START_DATE_KEY @"eventstartdatekey"
#define EVENT_END_DATE_KEY @"eventenddatekey"
#define EVENT_CALENDAR_TITLE_KEY @"calendartitle"

#define EVENT_CALENDAR_TIME_ZONE_KEY @"timezone"
#define EVENT_CALENDAR_NOTES_KEY @"notes"

// calevent
#define EVENT_CALENDAR_ORGANIZER_KEY @"organizer"
#define EVENT_CALENDAR_PARTICIPANTS_KEY @"participants"

// facebook - event
#define FB_EVENT_START_TIME @"start_time"
#define FB_EVENT_END_TIME @"end_time"
#define FB_EVENT_NAME @"name"
#define FB_EVENT_LOCATION @"location"

// facebook - bday
#define FB_BIRTHDAY_DATE @"birthday_date"
#define FB_BIRTHDAY_NAME @"name"

#pragma mark - EVENT

//-(CalendarEvent *) copy






#pragma mark  Calendar 

#pragma mark facebook



+(NSDate *) dateFromFBEventString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd HH:mm:SS"];
    
    return [dateFormatter dateFromString:string];
}




@end
