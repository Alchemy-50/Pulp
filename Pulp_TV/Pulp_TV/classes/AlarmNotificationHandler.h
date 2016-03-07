//
//  AlarmNotificationHandler.h
//  Calendar
//
//  Created by Josh Klobe on 7/12/14.
//
//

#import <Foundation/Foundation.h>
#import "CalendarEvent.h"



@interface AlarmNotificationHandler : NSObject

+(void)runScheduler;
+(void)processEventWithCalEvent:(CalendarEvent *)calEvent;

@end
