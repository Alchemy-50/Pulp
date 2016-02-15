//
//  CommonTasksManager.m
//  Calendar
//
//  Created by Josh Klobe on 4/23/13.
//
//

#import "CommonTasksManager.h"
#import "GroupDataManager.h"
#import "EventKitManager.h"
#import "GroupDiskManager.h"
#import "CommonTaskEventContainer.h"

#define COMMON_TASKS_CALENDAR_CONTAINER_TITLE @"cal_cc"
#define COMMON_TASKS_CALENDAR_ID_CONTAINER_STORAGE_KEY @"COMMON_TASKS_CALENDAR_ID_CONTAINER_STORAGE_KEY"
#define COMMON_TASKS_STORED_DICTIONARY_KEY @"COMMON_TASKS_STORED_DICTIONARY_KEY"
@interface CommonTasksManager ()
@property (nonatomic, retain) EKCalendar *commonTasksCalendar;
@property (nonatomic, retain) NSMutableDictionary *tasksForCalendarIDDictionary;
@end


@implementation CommonTasksManager

static CommonTasksManager *theCommonTasksManager;



-(id)init
{
    self = [super init];

    NSString *commonTaskCalendarID = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:COMMON_TASKS_CALENDAR_ID_CONTAINER_STORAGE_KEY];
    
    if (commonTaskCalendarID == nil)
    {
        self.commonTasksCalendar =  [[EventKitManager sharedManager] getNewEKCalendar];
        self.commonTasksCalendar.title = COMMON_TASKS_CALENDAR_CONTAINER_TITLE;
        self.commonTasksCalendar.source = [[EventKitManager sharedManager] getStandardEKSource];
        [[GroupDiskManager sharedManager] saveDataToDiskWithObject:self.commonTasksCalendar.calendarIdentifier withKey:COMMON_TASKS_CALENDAR_ID_CONTAINER_STORAGE_KEY];
        [[EventKitManager sharedManager] saveCalendarWaitForResult:self.commonTasksCalendar];
    }
    
    if (self.commonTasksCalendar == nil)
        self.commonTasksCalendar = [[EventKitManager sharedManager] getEKCalendarWithIdentifier:[[GroupDiskManager sharedManager] loadDataFromDiskWithKey:COMMON_TASKS_CALENDAR_ID_CONTAINER_STORAGE_KEY]];
    
    if (self.tasksForCalendarIDDictionary == nil)
    {
        self.tasksForCalendarIDDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    
        NSDictionary *storedDictionary = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:COMMON_TASKS_STORED_DICTIONARY_KEY];
        
        if (storedDictionary != nil)
            [self.tasksForCalendarIDDictionary addEntriesFromDictionary:storedDictionary];

        
    }
    
    return self;
}


+(NSArray *)getCommonTasksForCalendar:(EKCalendar *)theCalendar
{

    
    if (theCommonTasksManager == nil)
        theCommonTasksManager = [[CommonTasksManager alloc] init];
    

    
    NSLog(@"getCommonTasksForCalendar [theCommonTasksManager.tasksForCalendarIDDictionary: %@", theCommonTasksManager.tasksForCalendarIDDictionary);
    
    return [theCommonTasksManager.tasksForCalendarIDDictionary objectForKey:theCalendar.calendarIdentifier];
    
    
    
}

+(void)setCommonTask:(CommonTaskEventContainer *)theTask forCalendar:(EKCalendar *)theCalendar
{
    if (theCommonTasksManager == nil)
        theCommonTasksManager = [[CommonTasksManager alloc] init];
    
    
    NSMutableArray *tasksArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *existingArray = [theCommonTasksManager.tasksForCalendarIDDictionary objectForKey:theCalendar.calendarIdentifier];
    if (existingArray != nil)
        [tasksArray addObjectsFromArray:existingArray];
    
    [tasksArray addObject:theTask];
    
    [theCommonTasksManager.tasksForCalendarIDDictionary setObject:tasksArray forKey:theCalendar.calendarIdentifier];
    
    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:theCommonTasksManager.tasksForCalendarIDDictionary withKey:COMMON_TASKS_STORED_DICTIONARY_KEY];
    
    
    NSLog(@"setCommonTask [theCommonTasksManager.tasksForCalendarIDDictionary: %@", theCommonTasksManager.tasksForCalendarIDDictionary);
}


@end
