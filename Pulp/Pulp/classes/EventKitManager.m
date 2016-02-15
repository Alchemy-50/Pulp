//
//  EventKitManager.m
//  Calendar
//
//  Created by Jay Canty on 4/25/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "EventKitManager.h"
#import "CommonEventContainer.h"
#import "CommonEventsManager.h"
#import "GroupDiskManager.h"
#import "GroupDataManager.h"
#import "AppDelegate.h"
#import "AlarmNotificationHandler.h"
#import "MainViewController.h"

@implementation EventKitManager


#define NEW_COMMON_EVENT_ID @"NEW_COMMON_EVENT_ID"
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


-(EKSource *)getStandardEKSource
{
    EKSource *returnSource = nil;
    for (EKSource *source in self.eventStore.sources)
        if (source.sourceType == EKSourceTypeCalDAV)
            returnSource = source;


    return returnSource;
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
//                 NSLog(@"EKAuthorizationStatusNotDetermined");
                 break;
             case EKAuthorizationStatusRestricted:
//                 NSLog(@"EKAuthorizationStatusRestricted");
                 break;
             case EKAuthorizationStatusDenied:
//                 NSLog(@"EKAuthorizationStatusDenied");
                 break;
             case EKAuthorizationStatusAuthorized:
//                 NSLog(@"EKAuthorizationStatusAuthorized");

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

- (NSString *) getNewCommonEventID
{
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    return [standardUserDefaults objectForKey:NEW_COMMON_EVENT_ID];    
}

-(void) initialize
{
     
    EKCalendar *defaultCalendar = [self.eventStore defaultCalendarForNewEvents];
    BOOL defaultNewFound = NO;
    NSArray *commonEventsForDefault = [[CommonEventsManager sharedEventsManager] getCommonEventsForCalendar:defaultCalendar];
    
    NSUserDefaults *standardUserDefaults = [NSUserDefaults standardUserDefaults];
    for (int i = 0; i < [commonEventsForDefault count]; i++)
    {
        
        CommonEventContainer *container = [commonEventsForDefault objectAtIndex:i];
        if ([container.commonEventID compare:[standardUserDefaults objectForKey:NEW_COMMON_EVENT_ID]] == NSOrderedSame)
            defaultNewFound = YES;
    }
    
    if (!defaultNewFound)
    {
        CommonEventContainer *commonEventContainer = [[CommonEventContainer alloc] init];
        commonEventContainer.title = @"NEW";
        commonEventContainer.referenceCalendarIdentifier = defaultCalendar.calendarIdentifier;
        [[CommonEventsManager sharedEventsManager] setCommonEvent:commonEventContainer forCalendar:defaultCalendar];
        
        
        [standardUserDefaults setObject:commonEventContainer.commonEventID forKey:NEW_COMMON_EVENT_ID];
        [standardUserDefaults synchronize];
        
    }
  
  
    [[GroupDataManager sharedManager] loadCache];
    [[MainViewController sharedMainViewController] dataChanged];
    
}


- (void) remoteRefresh
{
    [self.eventStore refreshSourcesIfNecessary];
}

- (EKCalendar *) getNewEKCalendar
{
//    NSLog(@"self.eventStore: %@", self.eventStore);
    return [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:self.eventStore];
}

- (EKCalendar *) getEKCalendarWithIdentifier:(NSString *)calId
{
    if (!queueSet)
        return nil;
    else
    {
        __block EKCalendar *ekCal;
        dispatch_sync(ekQueue, ^{
            
            ekCal = [self.eventStore calendarWithIdentifier:calId];
            
        });
        return ekCal;
    }
}


- (EKEvent *) getNewEKEvent
{
    return [EKEvent eventWithEventStore:self.eventStore];
}

- (EKEvent *) getEKEventWithIdentifier:(NSString *)eventId
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
        
        NSDictionary *dict = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY];
        
        if (dict == nil)
        {
            NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:0];
            
            for (int i = 0; i < [calArray count]; i++)
            {
                EKCalendar *calendar = [calArray objectAtIndex:i];
                
                [dictionary setObject:@"1" forKey:calendar.calendarIdentifier];
            }
            
            [[GroupDiskManager sharedManager] saveDataToDiskWithObject:dictionary withKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY];
        }
        
        NSMutableArray *returnArray = [NSMutableArray arrayWithCapacity:0];
        
        for (int i = 0; i < [calArray count]; i++)
        {
            EKCalendar *theCalendar = [calArray objectAtIndex:i];
            if ([dict objectForKey:theCalendar.calendarIdentifier] != nil)
            {
                if ([[dict objectForKey:theCalendar.calendarIdentifier] boolValue])
                    [returnArray addObject:theCalendar];
            }
        }
        
        if (supressHiddenCalendars)
            return returnArray;
        else
            return calArray;
        
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
        __block NSMutableArray *eventsArray;
        dispatch_sync(ekQueue, ^{
            
            eventsArray = [[NSMutableArray arrayWithCapacity:0] retain];
            NSPredicate *predicate = [self.eventStore predicateForEventsWithStartDate:startDate endDate:endDate calendars:calendarsArray];
            [eventsArray addObjectsFromArray:[self.eventStore eventsMatchingPredicate:predicate]];
            
        });
        return [eventsArray autorelease];
    }
}


-(BOOL) createAndSaveCalendar:(EKCalendar *)calendar
{
    NSMutableDictionary *showingStoredCalendarDictionary = [NSMutableDictionary dictionaryWithDictionary:[[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY]];
    [showingStoredCalendarDictionary setObject:@"1" forKey:calendar.calendarIdentifier];
    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:showingStoredCalendarDictionary withKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY];
    return [self saveCalendar:calendar];
}

-(BOOL) saveCalendar:(EKCalendar *)calendar
{
    BOOL retval = 1;
    if (!self.queueSet)
    {
        
        
    }
    else
    {
//        dispatch_barrier_async(ekQueue, ^{
            
            NSError *err = nil;
            
            retval = [self.eventStore saveCalendar:calendar commit:YES error:&err];
            NSLog(@"save calendar.title: %@", calendar.title);
            NSLog(@"save calendar.source: %@", calendar.source);
        
            NSLog(@"err: %@", err);
        
            if (err) {
                
            
                NSLog(@"!!!!!!!!!err: %@", err);
                NSLog(@"saveCalendar8, error: %@", err);

            }
        else
        {
            [self commit];
        }

    }
    
    return retval;
}

-(BOOL) saveCalendarWaitForResult:(EKCalendar *)calendar
{
    
    dispatch_sync(ekQueue, ^{
        
        NSError *err = nil;
        
        [self.eventStore saveCalendar:calendar commit:YES error:&err];
        
        if (err) {
            
            NSLog(@"saveCalendarWaitForResult, error: %@", err);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning7" message:[NSString stringWithFormat:@"%@ %@",@"Error:", err]
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        
    });
    
    return YES;
}

-(void) deleteCalendar:(EKCalendar *)calendar
{
    dispatch_barrier_async(ekQueue, ^{
        
        NSError *err = nil;
        [self.eventStore removeCalendar:calendar commit:YES error:&err];
        if (err) {
            
            NSLog(@"deleteCalendar, error: %@", err);
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning6" message:[NSString stringWithFormat:@"%@ %@",@"Error:", err]
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    });
}

-(void) saveCalendarEvent:(EKEvent *)event
{
    dispatch_barrier_async(ekQueue, ^{
        
        NSError *err = nil;
        
        BOOL success = [self.eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&err];
        NSLog(@"save calendar event success: %d", success);
        if (err)
        {
            NSLog(@"saveCalendarEvent, error: %@", err);
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning5" message:[NSString stringWithFormat:@"%@ %@",@"Error:", err]
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
        else
            [AlarmNotificationHandler processEventWithCalEvent:event];
    });
}


-(void) deleteCalendarEvent:(EKEvent *)event spanFutureEvents:(BOOL)span
{
    NSError *err = nil;
    
    EKSpan theSpan = EKSpanThisEvent;
    
    if (span)
        theSpan = EKSpanFutureEvents;
    

    [self.eventStore removeEvent:event span:theSpan commit:YES error:&err];
    
    if (err) {
        
        NSLog(@"err: %@", err);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning2" message:[NSString stringWithFormat:@"%@ %@",@"Error:", err]
                                                       delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Warning1" message:[NSString stringWithFormat:@"%@ %@",@"Error:", err]
                                                           delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
        }
    });
}





@end
