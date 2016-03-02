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
    return nil;
    
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
    
      return nil;
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
