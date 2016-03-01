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
#import <EventKit/EventKit.h>



@interface EventKitManager ()
@property (nonatomic, retain) EKEventStore *eventStore;
@end

@implementation EventKitManager


static EventKitManager *theManager;
static dispatch_queue_t ekQueue;

@synthesize  eventStore;
@synthesize queueSet;


+(EventKitManager *)sharedManager
{
    if (theManager == nil)
        theManager = [[EventKitManager alloc] init];
    
    return theManager;
}




- (EventKitManager *) init
{
    self = [super init];
    
    self.eventStore = [[EKEventStore alloc] init];
    [self.eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error)
     {
         
         if (!granted)
             NSLog(@"Not granted");
         
         
         
         EKAuthorizationStatus status = [EKEventStore authorizationStatusForEntityType:EKEntityTypeEvent];
         
         switch (status) {
             case EKAuthorizationStatusNotDetermined:
                 NSLog(@"EKAuthorizationStatusNotDetermined");
                 break;
             case EKAuthorizationStatusRestricted:
                 NSLog(@"EKAuthorizationStatusRestricted");
                 break;
             case EKAuthorizationStatusDenied:
                 NSLog(@"EKAuthorizationStatusDenied");
                 break;
             case EKAuthorizationStatusAuthorized:
                 NSLog(@"EKAuthorizationStatusAuthorized");
                 
                 self.queueSet = YES;
                 ekQueue = dispatch_queue_create("com.alchemy.ekqueue", DISPATCH_QUEUE_CONCURRENT);
                 [self performSelectorOnMainThread:@selector(initialize) withObject:nil waitUntilDone:NO];
                 
                 break;
                 
             default:
                 break;
         }
     }];
    
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
    [self.eventStore refreshSourcesIfNecessary];
}

- (id) getNewEKCalendar
{
    //    NSLog(@"self.eventStore: %@", self.eventStore);
    
    EKCalendar *theEKCalendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.eventStore];
    
    CalendarRepresentation *representation = [[CalendarRepresentation alloc] initWithCalendarObject:theEKCalendar];
    return representation;
}

- (id) getEKCalendarWithIdentifier:(NSString *)calId
{
    if (!queueSet)
        return nil;
    else
    {
        __block CalendarRepresentation *representation;
        dispatch_sync(ekQueue, ^{
            
            EKCalendar *ekCal = [self.eventStore calendarWithIdentifier:calId];
            representation = [[CalendarRepresentation alloc] initWithCalendarObject:ekCal];
            
        });
        return representation;
    }
}


- (CalendarEvent *) getNewEKEvent
{
    CalendarEvent *calendarEvent = [[CalendarEvent alloc] initWithEKEvent:[EKEvent eventWithEventStore:self.eventStore]];
    return calendarEvent;
}

- (id) getEKEventWithIdentifier:(NSString *)eventId
{
    if (!self.queueSet)
    {
        return nil;
    }
    else
    {
        __block EKEvent *ekEvent;
        dispatch_sync(ekQueue, ^{
            
            ekEvent = [self.eventStore eventWithIdentifier:eventId];
            
        });
        return ekEvent;
    }
}

- (NSArray *) getEKCalendars:(BOOL)supressHiddenCalendars
{
    
    if (!self.queueSet)
    {
        return nil;
        
    }
    else
    {
        __block NSArray *calArray;
        dispatch_sync(ekQueue, ^{
            
            calArray = [[NSArray alloc] initWithArray:[self.eventStore calendarsForEntityType:EKEntityTypeEvent]];
            
        });
        
        
        NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
        NSMutableDictionary *storedDict = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY];
        if (storedDict != nil)
            [dict addEntriesFromDictionary:storedDict];
        
        //automatically permit new calendars to show
        for (int i  = 0; i < [calArray count]; i++)
        {
            EKCalendar *calendar = [calArray objectAtIndex:i];
            if ([dict objectForKey:calendar.calendarIdentifier] == nil)
                [dict setObject:@"1" forKey:calendar.calendarIdentifier];
            
        }
        [[GroupDiskManager sharedManager] saveDataToDiskWithObject:dict withKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY];
        
        
        NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:0];
        
        for (int i = 0; i < [calArray count]; i++)
        {
            EKCalendar *theCalendar = [calArray objectAtIndex:i];
            if ([dict objectForKey:theCalendar.calendarIdentifier] != nil)
            {
                if (supressHiddenCalendars)
                {
                if ([[dict objectForKey:theCalendar.calendarIdentifier] boolValue])
                {
                    CalendarRepresentation *calendarRepresentation = [[CalendarRepresentation alloc] initWithCalendarObject:theCalendar];
                    [returnArray addObject:calendarRepresentation];
                }
                }
                else
                {
                    CalendarRepresentation *calendarRepresentation = [[CalendarRepresentation alloc] initWithCalendarObject:theCalendar];
                    [returnArray addObject:calendarRepresentation];
                }
            }
        }
        
        
        return returnArray;
    }
}

- (NSMutableArray *) getEventsForStartDate:(NSDate *)startDate forEndDate:(NSDate *)endDate withCalendars:(NSArray *)calendarsArray
{
    
    if (!self.queueSet)
    {
        return nil;
        
    }
    else
    {
        
        NSMutableArray *ekEventCalendars = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < [calendarsArray count]; i++)
        {
            CalendarRepresentation *representation = [calendarsArray objectAtIndex:i];
            [ekEventCalendars addObject:[representation getEKEventCalendar]];
        }
        __block NSMutableArray *calendarEventsArray;
        dispatch_sync(ekQueue, ^{
            
            calendarEventsArray = [[NSMutableArray arrayWithCapacity:0] retain];

            NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:ekEventCalendars];
            NSArray *eventsArray = [NSArray arrayWithArray:[self.eventStore eventsMatchingPredicate:predicate]];
            for (int i = 0; i < [eventsArray count]; i++)
            {
                CalendarEvent *calendarEvent = [[CalendarEvent alloc] initWithEKEvent:[eventsArray objectAtIndex:i]];
                [calendarEventsArray addObject:calendarEvent];
            }            
        });
        return [calendarEventsArray autorelease];
    }
}


- (BOOL) createAndSaveCalendar:(id)calendar
{
    NSString *identifier = @"";
    if ([calendar isKindOfClass:[EKCalendar class]])
        identifier = ((EKCalendar *)calendar).calendarIdentifier;
    else if ([calendar isKindOfClass:[CalendarRepresentation class]])
        identifier = [((CalendarRepresentation *)calendar) getTheCalendarIdentifier];
    
    NSMutableDictionary *showingStoredCalendarDictionary = [NSMutableDictionary dictionaryWithDictionary:[[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY]];
    [showingStoredCalendarDictionary setObject:@"1" forKey:identifier];
    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:showingStoredCalendarDictionary withKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY];
    return [self saveCalendar:calendar];
}

-(BOOL) saveCalendar:(id)calendar
{
    BOOL retval = YES;
    if (self.queueSet)
    {
        NSError *err = nil;
        retval = [self.eventStore saveCalendar:calendar commit:YES error:&err];
        if (err) {
            NSLog(@"%s, err: %@", __PRETTY_FUNCTION__, err);
            
        }
        else
        {
            [self commit];
        }
    }
    return retval;
}



- (void) deleteCalendar:(id)calendar
{
    NSError *err = nil;
    [self.eventStore removeCalendar:calendar commit:YES error:&err];
    if (err) {
        NSLog(@"%s, err: %@", __PRETTY_FUNCTION__, err);
    }
}




- (void) saveCalendarEvent:(id)event
{
    dispatch_barrier_async(ekQueue, ^{
        
        NSError *err = nil;
        
        BOOL success = [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        NSLog(@"save calendar event success: %d", success);
        if (err)
        {
            NSLog(@"saveCalendarEvent, error: %@", err);
            //FIXME:  REimplement alert
            /*
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning5" message:[NSString stringWithFormat:@"%@ %@",@"Error:", err]
             delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
             [alert release];
             */
        }
        else
        {
            CalendarEvent *calendarEvent = [[CalendarEvent alloc] initWithEKEvent:event];
            [AlarmNotificationHandler processEventWithCalEvent:calendarEvent];
        }
    });
}


-(void) deleteCalendarEvent:(id)event spanFutureEvents:(BOOL)span
{
    NSError *err = nil;
    
    EKSpan theSpan = EKSpanThisEvent;
    
    if (span)
        theSpan = EKSpanFutureEvents;
    
    
    [self.eventStore removeEvent:event span:theSpan commit:YES error:&err];
    
    if (err) {
        
        NSLog(@"err: %@", err);
        //FIXME:  REimplement alert
        /*
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning2" message:[NSString stringWithFormat:@"%@ %@",@"Error:", err]
         delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
         [alert show];
         [alert release];
         */
    }
    
    
    //    [self.eventStore commit:&err];
    
    //    [self saveCalendar:event.calendar];
    
}


-(void) commit
{
    dispatch_barrier_async(ekQueue, ^{
        
        NSError *err = nil;
        
        NSLog(@"source commit: %d", [self.eventStore commit:&err]);
        
        if (err) {
            
            NSLog(@"err: %@", err);
            //FIXME:  REimplement alert
            /*
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning1" message:[NSString stringWithFormat:@"%@ %@",@"Error:", err]
             delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
             [alert release];
             */
        }
    });
}





- (NSMutableDictionary *)fetchEventsWithStartDate:(NSDate *)startDate withEndDate:(NSDate *)endDate withSelectedCalendars:(NSArray *)selectedCals {
    
    NSMutableDictionary *retDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSMutableArray *eventsArray = [NSMutableArray arrayWithCapacity:0];
    
    
    [eventsArray addObjectsFromArray:[[EventKitManager sharedManager] getEventsForStartDate:startDate forEndDate:endDate withCalendars:selectedCals]];
    
    for (int i = 0; i < [eventsArray count]; i++)
    {
        CalendarEvent *calEvent = [eventsArray objectAtIndex:i];
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
    CalendarEvent *eventOne = (CalendarEvent *)calEvent1;
    CalendarEvent *eventTwo = (CalendarEvent *)calEvent2;
    
    return [[eventOne getStartDate] compare:[eventTwo getStartDate]];
}

- (NSMutableDictionary *) loadReturnDictionaryWithRetDict:(NSMutableDictionary *)retDict withEvent:(CalendarEvent *)calEvent withFetchStartDate:(NSDate *)startDate withFetchEndDate:(NSDate *)endDate
{
    NSDate *eventStartDate = [calEvent getStartDate];
    NSDate *eventEndDate = [calEvent getEndDate];
    
    int eventStartDay = [[[DateFormatManager sharedManager].dayFormatter stringFromDate:eventStartDate] intValue];
    int eventStartMonth = [[[DateFormatManager sharedManager].monthFormatter stringFromDate:eventStartDate] intValue];
    int eventStartYear = [[[DateFormatManager sharedManager].yearFormatter stringFromDate:eventStartDate] intValue];
    
    int eventEndDay = [[[DateFormatManager sharedManager].dayFormatter stringFromDate:eventEndDate] intValue];
    int eventEndMonth = [[[DateFormatManager sharedManager].monthFormatter stringFromDate:eventEndDate] intValue];
    int eventEndYear = [[[DateFormatManager sharedManager].yearFormatter stringFromDate:eventEndDate] intValue];

    if ( ( ([eventStartDate earlierDate:startDate] == startDate || [eventStartDate isEqualToDate:startDate]) && [eventStartDate earlierDate:endDate] == eventStartDate) || ([eventEndDate earlierDate:startDate] == startDate && [eventEndDate earlierDate:endDate] == eventStartDate) )
    {
        //NSLog(@"EKEVENT: %@", ekEvent.startDate);
    
        if ([eventStartDate compare:startDate] == NSOrderedDescending || [eventStartDate compare:startDate] == NSOrderedSame)
        {
            // checks if the event starts before this calendar
            NSString *s = [[DateFormatManager sharedManager].dateFormatter stringFromDate:eventStartDate];
            
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
                    NSString *eventDateKey = [[DateFormatManager sharedManager].dateFormatter stringFromDate:eventDate];
                    
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
                NSString *s = [[DateFormatManager sharedManager].dateFormatter stringFromDate:eventEndDate];
                
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






@end
