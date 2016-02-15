//
//  CommonTasksManager.h
//  Calendar
//
//  Created by Josh Klobe on 4/23/13.
//
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "CommonTaskEventContainer.h"


#define COMMON_TASKS_CALENDAR_ID_STORAGE_KEY @"COMMON_TASKS_CALENDAR_ID_STORAGE_KEY"

@interface CommonTasksManager : NSObject

+(NSArray *)getCommonTasksForCalendar:(EKCalendar *)theCalendar;
+(void)setCommonTask:(CommonTaskEventContainer *)theTask forCalendar:(EKCalendar *)theCalendar;

@end
