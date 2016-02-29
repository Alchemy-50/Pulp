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



- (EKEvent *) getEkEvent
{
    if ([self.ekObject isKindOfClass:[EKEvent class]])       
         return (EKEvent *)self.ekObject;
    else if ([self.ekObject isKindOfClass:[NSArray class]])
        return [((NSMutableArray *)self.ekObject) objectAtIndex:0];
    else
        return nil;
}





@end
