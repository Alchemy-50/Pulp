//
//  CalendarEvent.m
//  Calendar
//
//  Created by jay canty on 1/20/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "CalendarEvent.h"

#import "DateFormatManager.h"

@implementation CalendarEvent

@synthesize ekObject, participants, organizer, fbEventID, validEvent;


- (CalendarEvent *) init
{
    [self initWithEKEvent:nil];
    
    return self;
}


- (CalendarEvent *) initWithEKEvent:(EKEvent *)event
{
    self = [super init];
        
    if ([event hasRecurrenceRules])
        self.ekObject = (EKEvent *)[[NSMutableArray alloc] initWithObjects:event, nil];
    else 
        self.ekObject = event;
        
    self.participants = [[NSMutableArray alloc] initWithCapacity:0];
    self.validEvent = YES;
    
    return self;
}

- (CalendarEvent *) initWithSingleEKEvent:(EKEvent *)event
{
    self = [super init];
    
    self.ekObject = event;
    
    self.participants = [[NSMutableArray alloc] initWithCapacity:0];
    self.validEvent = YES;
    
    return self;
}

- (CalendarEvent *) initWithCalendarEvent:(CalendarEvent *)ce {
    
    self = [super init];
    
    //self.ekObject = ce.ekObject;
    
    if (ce.participants != nil)
        self.participants = [NSMutableArray arrayWithArray:ce.participants];
    
    if (ce.organizer != nil)
        self.organizer = [NSString stringWithString:ce.organizer];
    
    if (ce.fbEventID != nil)
        self.fbEventID = [NSString  stringWithString:ce.fbEventID];
    
    
    return self;    
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    
    //[self printCalendarEvent];
    
    [encoder encodeObject:self.organizer forKey:@"organizer"];
    [encoder encodeObject:self.participants forKey:@"participants"];
    [encoder encodeObject:self.fbEventID forKey:@"fbeventid"];
    
    //if (self.commonTaskCalendarID != nil)
    //{
        //NSLog(@"begin test");
        //NSLog(@"commonTaskCalendarID.retainCount: %d", [self.commonTaskCalendarID retainCount]);            
        //NSLog(@"WTF: %@", self.commonTaskCalendarID);
        //[encoder encodeObject:self.commonTaskCalendarID  forKey:@"commontaskcalendarid"];
        
    //}
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self.organizer = [decoder decodeObjectForKey:@"organizer"];
    self.participants = [decoder decodeObjectForKey:@"participants"];
    self.fbEventID = [decoder decodeObjectForKey:@"fbeventid"];    
    //self.commonTaskCalendarID = [decoder decodeObjectForKey:@"commontaskcalendarid"];

    return self;
}


- (void) addEkEvent:(EKEvent *)event
{    
    if ([event hasRecurrenceRules])
    {
        if (self.ekObject == nil)
            self.ekObject = (EKEvent *)[[NSMutableArray alloc] initWithObjects:event, nil];
        
        else {
            
            NSMutableArray *ar = (NSMutableArray *)self.ekObject;
            
            BOOL addEvent = YES;
            
            for (int i=0; i<[ar count]; i++)
            {
                EKEvent *arEvent = [ar objectAtIndex:i];
    
                if ([arEvent.startDate isEqualToDate:event.startDate] & [arEvent.endDate isEqualToDate:event.endDate])
                {
                    [ar replaceObjectAtIndex:i withObject:event];
                    addEvent = NO;
                }
            }
            if (addEvent)
                [ar addObject:event];
        }
        
    } else 
        self.ekObject = event;
}

- (EKEvent *) getEkEventWithParameter:(id)param
{
    if ([self.ekObject isKindOfClass:[EKEvent class]])       
         return (EKEvent *)self.ekObject;
         
    else {
        
        if (param == nil)
            return [((NSMutableArray *)self.ekObject) objectAtIndex:0];
        
        NSString *paramDateString = nil;
             
        if ([param isKindOfClass:[NSDate class]])
            paramDateString = [[DateFormatManager sharedManager].dateFormatter stringFromDate:(NSDate *)param];
        else 
            paramDateString = (NSString *)param;
        
        for (EKEvent *event in (NSMutableArray *)self.ekObject)
        {
            NSString *eventDateString = [[DateFormatManager sharedManager].dateFormatter stringFromDate:event.startDate];
            
            if ( [eventDateString compare:paramDateString] == NSOrderedSame )
                return event;
        } 
    }  
    
    return nil;
}

- (void) printCalendarEvent
{
    NSLog(@"EK: %@", self.ekObject);
    //NSLog(@"CT ID: %@", self.commonTaskCalendarID);
    //NSLog(@"EK: %@", self.calendarEventDictionary);
    
    /*
    id ekObject;
    
    NSMutableArray *participants;
    
    NSString *organizer;
    
    NSString *fbEventID;
    
    NSString *commonTaskCalendarID;
    
    BOOL validEvent;    
    */
    
}






@end
