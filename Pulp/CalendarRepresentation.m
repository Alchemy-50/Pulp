//
//  CalendarRepresentation.m
//  Pulp
//
//  Created by Josh Klobe on 2/29/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "CalendarRepresentation.h"
#import <EventKit/EventKit.h>

@interface CalendarRepresentation ()
@property (nonatomic, retain) EKEvent *referenceEvent;
@end


@implementation CalendarRepresentation


-(id)initWithEventObject:(id)eventObject
{
    self = [super init];
    if ([eventObject isKindOfClass:[EKEvent class]])
        self.referenceEvent = eventObject;
    
    return self;
}

-(UIColor *)getColor
{
    UIColor *retColor = [UIColor redColor];
    
    if (self.referenceEvent != nil)
        retColor = [UIColor colorWithCGColor:self.referenceEvent.calendar.CGColor];
    
    return retColor;
}

-(NSString *)getTitle
{
    NSString *retString = @"null?";
    
    if (self.referenceEvent != nil)
        retString = self.referenceEvent.calendar.title;
    
    return retString;
}

@end
