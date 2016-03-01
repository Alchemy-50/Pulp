//
//  CalendarRepresentation.m
//  Pulp
//
//  Created by Josh Klobe on 2/29/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "CalendarRepresentation.h"
#import "Defs.h"
#import <EventKit/EventKit.h>

@interface CalendarRepresentation ()
@property (nonatomic, retain) EKEvent *referenceEvent;
@property (nonatomic, retain) EKCalendar *referenceCalendar;
@end


@implementation CalendarRepresentation


-(id)initWithEventObject:(id)eventObject
{
    self = [super init];
    if ([eventObject isKindOfClass:[EKEvent class]])
        self.referenceEvent = eventObject;
    
    return self;
}

-(id)initWithCalendarObject:(id)calendarObject
{
    self = [super init];
    if ([calendarObject isKindOfClass:[EKCalendar class]])
        self.referenceCalendar = calendarObject;
    
    return self;
}

-(SourceRepresentation *)getSource
{
    SourceRepresentation *representation = [[SourceRepresentation alloc] initWithSource:self.referenceCalendar.source];
    return representation;
}

-(id)getEKEventCalendar
{
    return self.referenceCalendar;
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


-(NSString *)getTheCalendarIdentifier
{
    NSString *retString = @"";
    if (self.referenceEvent != nil)
        retString = self.referenceEvent.calendar.calendarIdentifier;
    
    return retString;
}

-(void)setTitleWithText:(NSString *)theTitleText;
{
    self.referenceCalendar.title = theTitleText;
}

-(void)setColorWithCGColor:(CGColorRef)theColorRef
{
    self.referenceCalendar.CGColor = theColorRef;
}

@end
