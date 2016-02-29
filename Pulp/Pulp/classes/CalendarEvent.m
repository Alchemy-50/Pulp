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

@synthesize ekObject;


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
    
    return self;
}



- (CalendarEvent *) initWithCalendarEvent:(CalendarEvent *)ce {
    
    self = [super init];
    
    
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





@end
