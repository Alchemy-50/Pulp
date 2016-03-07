//
//  EventKitManager.m
//  Calendar
//
//  Created by Jay Canty on 4/25/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "EventKitManager.h"
#import "GroupDiskManager.h"
#import "DateFormatManager.h"
#import "AppDelegate.h"
#import "AlarmNotificationHandler.h"
#import "MainViewController.h"



@interface EventKitManager ()
@property (nonatomic, retain) id eventStore;
@property (nonatomic, retain) NSMutableArray *storedReferenceEvents;
@property (nonatomic, retain) NSMutableDictionary *storedReferenceDictionary;
@end

@implementation EventKitManager


static EventKitManager *theManager;
static dispatch_queue_t ekQueue;

@synthesize  eventStore;
@synthesize queueSet;


+(EventKitManager *)sharedManager
{
    if (theManager == nil)
    {
        theManager = [[EventKitManager alloc] init];
        theManager.storedReferenceEvents = [[NSMutableArray alloc] initWithCapacity:0];
        theManager.storedReferenceDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
    }
    
    return theManager;
}

-(void)loadEvents:(NSArray *)theEvents
{
    [self.storedReferenceEvents removeAllObjects];
    [self.storedReferenceEvents addObjectsFromArray:theEvents];
    
    
}

- (void)loadCalendars:(NSDictionary *)theCalendars
{
    [self.storedReferenceDictionary removeAllObjects];
    [self.storedReferenceDictionary addEntriesFromDictionary:theCalendars];
}


-(NSDictionary *)getCalendarWithIdentifier:(NSString *)theIdentifier
{
    return [self.storedReferenceDictionary objectForKey:theIdentifier];
}

- (EventKitManager *) init
{
    self = [super init];
    
    return self;
}

-(id)getTheEventStore
{
    return self.eventStore;
}


-(void) initialize
{
    [[MainViewController sharedMainViewController] dataChanged];
}



- (void) remoteRefresh
{
}

- (id) getNewEKCalendar
{
    
    return nil;
}

- (id) getEKCalendarWithIdentifier:(NSString *)calId
{
    return nil;
    
}


- (CalendarEvent *) getNewEKEvent
{
    return nil;
    
}

- (id) getEKEventWithIdentifier:(NSString *)eventId
{
    return nil;
}

- (NSArray *) getEKCalendars:(BOOL)supressHiddenCalendars
{
    return nil;
}

- (NSMutableArray *) getEventsForStartDate:(NSDate *)startDate forEndDate:(NSDate *)endDate withCalendars:(NSArray *)calendarsArray
{
    NSMutableArray *ret = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < [self.storedReferenceEvents count]; i++)
    {
        CalendarEvent *theCalendarEvent = [self.storedReferenceEvents objectAtIndex:i];
        
        
        
        NSComparisonResult startResult = [startDate compare:[theCalendarEvent getStartDate]];
        NSComparisonResult endResult = [endDate compare:[theCalendarEvent getEndDate]];
        
        if (startResult == NSOrderedAscending && endResult == NSOrderedDescending)
        {
            [ret addObject:theCalendarEvent];
            
            /*
            NSLog(@"startDate: %@", startDate);
            NSLog(@"endDate: %@", endDate);
            NSLog(@"theCalendarEvent[%d].title: %@", i, [theCalendarEvent getTheTitle]);
            NSLog(@"theCalendarEvent[%d].startDate: %@", i, [theCalendarEvent getStartDate]);
            NSLog(@"theCalendarEvent[%d].endDate: %@", i, [theCalendarEvent getEndDate]);
            
            
            switch (startResult) {
                case NSOrderedAscending:
                    NSLog(@"start NSOrderedAscending");
                    break;
                    
                case NSOrderedSame:
                    NSLog(@"start NSOrderedSame");
                    break;
                    
                case NSOrderedDescending:
                    NSLog(@"start NSOrderedDescending");
                    break;
                default:
                    break;
            }
            
            
            switch (endResult) {
                case NSOrderedAscending:
                    NSLog(@"end NSOrderedAscending");
                    break;
                    
                case NSOrderedSame:
                    NSLog(@"end NSOrderedSame");
                    break;
                    
                case NSOrderedDescending:
                    NSLog(@"end NSOrderedDescending");
                    break;
                default:
                    break;
            }
            
            
            
            NSLog(@" ");
            NSLog(@" ");
            NSLog(@" ");
            NSLog(@" ");
         */
        }
        
        
    }
    
    return ret;
}


- (BOOL) createAndSaveCalendar:(id)calendar
{
    return YES;
}

-(BOOL) saveCalendar:(id)calendar
{
    return YES;
}



- (void) deleteCalendar:(id)calendar
{
    
}




- (void) saveCalendarEvent:(id)event
{
}


-(void) deleteCalendarEvent:(id)event spanFutureEvents:(BOOL)span
{
}


-(void) commit
{
}





- (NSMutableDictionary *)fetchEventsWithStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate withSelectedCalendars:(NSArray *)selectedCals {

    NSMutableDictionary *returnDictionary = [NSMutableDictionary dictionaryWithCapacity:0];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    NSArray *eventsArray = [NSArray arrayWithArray:[self getEventsForStartDate:startDate forEndDate:endDate withCalendars:nil]];
    
    
    for (int i = 0; i < [eventsArray count]; i++)
    {
        CalendarEvent *calendarEvent = [eventsArray objectAtIndex:i];
        NSString *theDateString = [dateFormatter stringFromDate:[calendarEvent getStartDate]];
    
        
        NSMutableArray *ar = [returnDictionary objectForKey:theDateString];
        if (ar == nil)
            ar = [[NSMutableArray alloc] initWithCapacity:0];
        [ar addObject:calendarEvent];
        
        [returnDictionary setObject:ar forKey:theDateString];
        
    }
    
    return returnDictionary;
}

NSInteger eventSort(id calEvent1, id calEvent2, void *context)
{
    return 0;
}

- (NSMutableDictionary *) loadReturnDictionaryWithRetDict:(NSMutableDictionary *)retDict withEvent:(CalendarEvent *)calEvent withFetchStartDate:(NSDate *)startDate withFetchEndDate:(NSDate *)endDate
{
    return nil;
    
}






@end
