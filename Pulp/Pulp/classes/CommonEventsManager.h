//
//  CommonEventsManager.h
//  Calendar
//
//  Created by Josh Klobe on 5/21/13.
//
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "CommonEventContainer.h"

@interface CommonEventsManager : NSObject


+(CommonEventsManager *)sharedEventsManager;

-(NSArray *)getAllCommonTasks;
-(NSArray *)getCommonEventsForCalendar:(EKCalendar *)theCalendar;
-(void)removeCommonEvent:(CommonEventContainer *)eventContainer forCalendar:(EKCalendar *)theCalendar;
-(void)setCommonEvent:(CommonEventContainer *)eventContainer forCalendar:(EKCalendar *)theCalendar;

@property (nonatomic, retain) NSMutableDictionary *commonEventsForCalendarsDictionary;
@end
