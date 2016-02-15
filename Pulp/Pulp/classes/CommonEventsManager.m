//
//  CommonEventsManager.m
//  Calendar
//
//  Created by Josh Klobe on 5/21/13.
//
//

#import "CommonEventsManager.h"
#import "GroupDiskManager.h"
#import "CommonEventContainer.h"
#import "EventKitManager.h"
#import "CalendarTasksDropdownView.h"

#define COMMON_EVENTS_MANAGER_STORAGE_KEY @"COMMON_EVENTS_MANAGER_STORAGE_KEY"

@implementation CommonEventsManager

static CommonEventsManager *theCommonEventsManager;


@synthesize commonEventsForCalendarsDictionary;


+(CommonEventsManager *)sharedEventsManager
{
    if (theCommonEventsManager == nil)
    {
        theCommonEventsManager = [[CommonEventsManager alloc] init];
        
        theCommonEventsManager.commonEventsForCalendarsDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        NSDictionary *storedDict = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:COMMON_EVENTS_MANAGER_STORAGE_KEY];
        if (storedDict != nil)
            [theCommonEventsManager.commonEventsForCalendarsDictionary addEntriesFromDictionary:storedDict];
    }
    
    return theCommonEventsManager;
}

-(NSArray *)getAllCommonTasks
{
    NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:0];
    
    NSDictionary *dict = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY];

    for (id key in self.commonEventsForCalendarsDictionary)
    {
        NSArray *ar = [self.commonEventsForCalendarsDictionary objectForKey:key];
        for (int i = 0; i < [ar count]; i++)
        {
            CommonEventContainer *eventContainer = [ar objectAtIndex:i];
            EKCalendar *cal = [[EventKitManager sharedManager] getEKCalendarWithIdentifier:eventContainer.referenceCalendarIdentifier];
            if (cal != nil)
            {
                BOOL visible = [[dict objectForKey:eventContainer.referenceCalendarIdentifier] boolValue];
                if (visible)
                    [returnArray addObject:eventContainer];
            }
        }
    }
    return returnArray;
}


-(NSArray *)getCommonEventsForCalendar:(EKCalendar *)theCalendar
{
    
    return [self.commonEventsForCalendarsDictionary objectForKey:theCalendar.calendarIdentifier];
}

-(void)removeCommonEvent:(CommonEventContainer *)eventContainer forCalendar:(EKCalendar *)theCalendar
{
    NSMutableArray *ar = [NSMutableArray arrayWithCapacity:0];
    if ([self.commonEventsForCalendarsDictionary objectForKey:theCalendar.calendarIdentifier] != nil)
        [ar addObjectsFromArray:[self.commonEventsForCalendarsDictionary objectForKey:theCalendar.calendarIdentifier]];
    
    if ([ar containsObject:eventContainer])
        [ar removeObject:eventContainer];
    
    if (theCalendar.calendarIdentifier != nil)
        [self.commonEventsForCalendarsDictionary setObject:ar forKey:theCalendar.calendarIdentifier];
    
    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:self.commonEventsForCalendarsDictionary withKey:COMMON_EVENTS_MANAGER_STORAGE_KEY];
}




-(void)setCommonEvent:(CommonEventContainer *)newEventContainer forCalendar:(EKCalendar *)theCalendar
{
    BOOL replace = NO;
    NSArray *keysArray = [self.commonEventsForCalendarsDictionary allKeys];
    
    for (int i = 0; i < [keysArray count]; i++)
    {
        NSString *key = [keysArray objectAtIndex:i];
        
        NSMutableArray *containersArray = [NSMutableArray arrayWithArray:[self.commonEventsForCalendarsDictionary objectForKey:key]];
        
        for (int j = 0; j < [containersArray count]; j++)
        {
            CommonEventContainer *existingEventContainer = [containersArray objectAtIndex:j];

            if ([existingEventContainer.commonEventID compare:newEventContainer.commonEventID] == NSOrderedSame)
            {
                replace = YES;
                [containersArray replaceObjectAtIndex:j withObject:newEventContainer];
                [self.commonEventsForCalendarsDictionary setObject:containersArray forKey:existingEventContainer.referenceCalendarIdentifier];

            }
        }

        
        
    }
    
    
    if (!replace)
    {
        NSLog(@"add common event");
        NSMutableArray *ar = [NSMutableArray arrayWithArray:[self.commonEventsForCalendarsDictionary objectForKey:theCalendar.calendarIdentifier]];
        [ar addObject:newEventContainer];
        [self.commonEventsForCalendarsDictionary setObject:ar forKey:theCalendar.calendarIdentifier];

        [[CalendarTasksDropdownView getSharedCalendarTasksDropdownView] loadCommonTaskSubviews];
        
    }

    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:self.commonEventsForCalendarsDictionary withKey:COMMON_EVENTS_MANAGER_STORAGE_KEY];

    
}





@end
