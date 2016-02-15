//
//  GroupCalendarManager.m
//  AlphaRow
//
//  Created by Josh Klobe on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GroupDataManager.h"
#import "GroupFormatManager.h"
#import <EventKit/EventKit.h>
#import "EventCalendarUtils.h"
#import "CommonTaskItem.h"
#import "GroupDiskManager.h"
#import "AppStateManager.h"
#import "EventKitManager.h"
#import "CommonTasksManager.h"
#import "AppDelegate.h"
@interface GroupDataManager()

- (GroupDataManager *)init;

// misc
- (NSMutableDictionary *) loadReturnDictionaryWithRetDict:(NSMutableDictionary *)retDict withEvent:(CalendarEvent *)calEvent withFetchStartDate:(NSDate *)startDate withFetchEndDate:(NSDate *)endDate;
NSInteger eventSort(id calEvent1, id calEvent2, void *context);

@end

@implementation GroupDataManager

static GroupDataManager *theManager;
static dispatch_queue_t cacheQueue;

@synthesize  contactsArray, fbContactsDictionary, cacheStartDate, cacheEndDate;

@synthesize  fbEventsCalendarID;

+(GroupDataManager *)sharedManager
{
    if (theManager == nil)
        theManager = [[GroupDataManager alloc] init];
    
    return theManager;
}

- (GroupDataManager *) init
{
    self = [super init];
    
    cacheQueue = dispatch_queue_create("com.alchemy.cachequeue", DISPATCH_QUEUE_CONCURRENT);
    self.contactsArray = [[NSMutableArray alloc] initWithCapacity:0];
//    [self loadCache];
    

    self.fbContactsDictionary = (NSMutableDictionary *)[[GroupDiskManager sharedManager] loadDataFromDiskWithKey:@"fbcontacts"];
    if (self.fbContactsDictionary == nil)
        self.fbContactsDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    return self;
}


- (NSArray *) getSelectedCalendars
{
    NSMutableArray *ar = [NSMutableArray arrayWithCapacity:0];

    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    if (del.currentSelectedCalendar != nil)
        [ar addObject:del.currentSelectedCalendar];
    else
        [ar addObjectsFromArray:[[EventKitManager sharedManager] getEKCalendars:YES]];

//    NSLog(@"getSelectedCalendars: %@", ar);
    
    return ar;
}



-(void) loadCache
{
    // poplulate event cache with eventstore event
    int month = 11;
    int year = 2013;
    
    int newMonth = 1;
    int newYear = 2015;
    
    [self loadCacheWithStartDate:[self getFirstDayOfMonth:month forYear:year] withEndDate:[self getLastDayOfMonth:newMonth forYear:newYear]];
}

- (void) loadCacheWithStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate
{
    self.cacheStartDate = startDate;
    self.cacheEndDate = endDate;
    
  //  NSMutableArray *ekCals = [[NSMutableArray alloc] initWithCapacity:0];
   // [ekCals addObjectsFromArray:[self getSelectedCalendars]];
}


- (NSMutableDictionary *)fetchEventsWithStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate withSelectedCalendars:(NSArray *)selectedCals {
    
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray *eventsArray = [NSMutableArray arrayWithCapacity:0];
    
    EKEvent *festEvent = nil;
    
    NSArray *ar = [[EventKitManager sharedManager] getEventsForStartDate:startDate forEndDate:endDate withCalendars:selectedCals];
    
    for (int i = 0; i < [ar count]; i++)
    {
        EKEvent *theEvent = [ar objectAtIndex:i];
        if ([theEvent.title rangeOfString:@"fest1"].length > 0)
        {
            festEvent = theEvent;
        }
        
    }
    if (festEvent != nil)
    {
/*        NSLog(@"begin fetchEventsWithStartDate");
        NSLog(@"startDate: %@", startDate);
        NSLog(@"endDate: %@", endDate);
        NSLog(@"festEvent: %@", festEvent);
        NSLog(@" ");
  */  }
    
    for (int i = 0; i < [ar count]; i++)
        [eventsArray addObject:[[CalendarEvent alloc] initWithEKEvent:[ar objectAtIndex:i]]];

    
    for (int i = 0; i < [eventsArray count]; i++)
    {
        CalendarEvent *calEvent = [eventsArray objectAtIndex:i];
        id ekObject = calEvent.ekObject;
        if ([ekObject isKindOfClass:[NSArray class]]) {
            for (EKEvent *event in (NSArray *)ekObject)
            {
                CalendarEvent *ce = [[CalendarEvent alloc] initWithCalendarEvent:calEvent];   //insures no loss
                ce.ekObject = event;
                
                retDict = [self loadReturnDictionaryWithRetDict:retDict withEvent:ce withFetchStartDate:startDate withFetchEndDate:endDate];
            }
            
        } else
            retDict = [self loadReturnDictionaryWithRetDict:retDict withEvent:calEvent withFetchStartDate:startDate withFetchEndDate:endDate];
        
    } 
    
    NSArray *dateKeys = [retDict allKeys];    
    for (NSString *dateKey in dateKeys) {

        NSArray *eventArray = [retDict objectForKey:dateKey];
        if ( [eventArray count] > 1 ) {
            
            eventArray = [eventArray sortedArrayUsingFunction:eventSort context:nil];
            [retDict setObject:eventArray forKey:dateKey];
        }
    }
    
	return retDict;
}

NSInteger eventSort(id calEvent1, id calEvent2, void *context)
{
    EKEvent *ekEvent1 = [((CalendarEvent *)calEvent1) getEkEventWithParameter:nil];
    EKEvent *ekEvent2 = [((CalendarEvent *)calEvent2) getEkEventWithParameter:nil];
    
    return [ekEvent1 compareStartDateWithEvent:ekEvent2];
}

- (NSMutableDictionary *) loadReturnDictionaryWithRetDict:(NSMutableDictionary *)retDict withEvent:(CalendarEvent *)calEvent withFetchStartDate:(NSDate *)startDate withFetchEndDate:(NSDate *)endDate
{
    EKEvent *ekEvent = (EKEvent *)calEvent.ekObject;
    
    NSDate *eventStartDate = ekEvent.startDate;
    // have to check for multiday events
    NSDate *eventEndDate = ekEvent.endDate;
    
    int eventStartDay = [[[GroupFormatManager sharedManager].dayFormatter stringFromDate:eventStartDate] intValue];
    int eventStartMonth = [[[GroupFormatManager sharedManager].monthFormatter stringFromDate:eventStartDate] intValue];
    int eventStartYear = [[[GroupFormatManager sharedManager].yearFormatter stringFromDate:eventStartDate] intValue];
    
    int eventEndDay = [[[GroupFormatManager sharedManager].dayFormatter stringFromDate:eventEndDate] intValue];
    int eventEndMonth = [[[GroupFormatManager sharedManager].monthFormatter stringFromDate:eventEndDate] intValue];
    int eventEndYear = [[[GroupFormatManager sharedManager].yearFormatter stringFromDate:eventEndDate] intValue];
    
    if ( ( ([eventStartDate earlierDate:startDate] == startDate || [eventStartDate isEqualToDate:startDate]) && [eventStartDate earlierDate:endDate] == eventStartDate) || ([eventEndDate earlierDate:startDate] == startDate && [eventEndDate earlierDate:endDate] == eventStartDate) )
    {
        //NSLog(@"EKEVENT: %@", ekEvent.startDate);
        
        if ([eventStartDate compare:startDate] == NSOrderedDescending || [eventStartDate compare:startDate] == NSOrderedSame)
        {
            // checks if the event starts before this calendar
            NSString *s = [[GroupFormatManager sharedManager].dateFormatter stringFromDate:eventStartDate];
            
            if ([retDict objectForKey:s] == nil)
                [retDict setObject:[NSMutableArray arrayWithCapacity:0] forKey:s];
            
            NSMutableArray *ar = [retDict objectForKey:s];
            if (![ar containsObject:calEvent] )
                [ar addObject:calEvent];
            
            [retDict setObject:ar forKey:s];
        }
        
        if (eventStartDay != eventEndDay || eventStartMonth != eventEndMonth || eventStartYear != eventEndYear) {
            
            // if event spans multiple days
            // This performs the difference calculation
            unsigned flags = NSCalendarUnitDay;
            NSDateComponents *difference = [[NSCalendar currentCalendar] components:flags fromDate:eventStartDate toDate:eventEndDate options:NSCalendarWrapComponents];
            
            if ([difference day] > 0) {
                
                // Event spans for more than one night
                // get array of dates and iterate.
                for (int i=1; i<[difference day]; i++)
                {
                    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                    
                    NSDateComponents *comps = [[NSDateComponents alloc] init];
                    [comps setDay:i];
                    
                    NSDate *eventDate = [gregorian dateByAddingComponents:comps  toDate:eventStartDate options:0];
                    NSString *eventDateKey = [[GroupFormatManager sharedManager].dateFormatter stringFromDate:eventDate];
                    
                    if ([eventDate compare:startDate] == NSOrderedDescending && [eventDate compare:endDate] == NSOrderedAscending)
                    {
                        if ([retDict objectForKey:eventDateKey] == nil)
                            [retDict setObject:[NSMutableArray arrayWithCapacity:0] forKey:eventDateKey];
                        
                        NSMutableArray *ar = [retDict objectForKey:eventDateKey];
                        if (![ar containsObject:calEvent] )
                            [ar addObject:calEvent];
                        
                        [retDict setObject:ar forKey:eventDateKey];
                    }
                }
            }
            if ([eventEndDate compare:endDate] == NSOrderedAscending)
            {
                // Takes care of overnight event or last day of multi-day
                // checks if the event ends after this calendar
                NSString *s = [[GroupFormatManager sharedManager].dateFormatter stringFromDate:eventEndDate];
                
                if ([retDict objectForKey:s] == nil)
                    [retDict setObject:[NSMutableArray arrayWithCapacity:0] forKey:s];
                
                NSMutableArray *ar = [retDict objectForKey:s];
                if (![ar containsObject:calEvent] )
                    [ar addObject:calEvent];
                
                [retDict setObject:ar forKey:s];
            }
        }
    }
    
    return retDict;
    
}


-(NSDate*) getFirstDayOfMonth:(int)month forYear:(int)year
{
    NSString *dateString = [NSString stringWithFormat:@"%d-%d-01 00:00:00", year, month];
    NSDate *date = [[GroupFormatManager sharedManager].dateTimeFormatter dateFromString:dateString];
    
    return date;
}

-(NSDate*) getLastDayOfMonth:(int)month forYear:(int)year
{
    NSString *startString = [NSString stringWithFormat:@"%d-%d-01 00:00:00", year, month];
    NSDate *start = [[GroupFormatManager sharedManager].dateTimeFormatter dateFromString:startString];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange monthRange = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:start];
    NSString *dateString = [NSString stringWithFormat:@"%d-%d-%lu 23:59:59", year, month, (unsigned long)monthRange.length];
    NSDate *date = [[GroupFormatManager sharedManager].dateTimeFormatter dateFromString:dateString];
    
    return date;
}



- (void)dealloc
{
    [super dealloc];
}



@end
