//
//  AlarmNotificationHandler.h
//  Calendar
//
//  Created by Josh Klobe on 7/12/14.
//
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
@interface AlarmNotificationHandler : NSObject

+(void)runScheduler;
+(void)processEventWithCalEvent:(EKEvent *)calEvent;

@end
