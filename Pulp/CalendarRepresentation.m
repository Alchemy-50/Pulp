//
//  CalendarRepresentation.m
//  Pulp
//
//  Created by Josh Klobe on 2/29/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "CalendarRepresentation.h"
#import "Defs.h"


@interface CalendarRepresentation ()
//@property (nonatomic, retain) EKEvent *referenceEvent;
//@property (nonatomic, retain) EKCalendar *referenceCalendar;
@property (nonatomic, retain) id referenceEvent;
@property (nonatomic, retain) id referenceCalendar;

@end


@implementation CalendarRepresentation


-(id)initWithEventObject:(id)eventObject
{
    self = [super init];
    self.referenceEvent = eventObject;
    
    return self;
}

-(id)initWithCalendarObject:(id)calendarObject
{
    self = [super init];
    self.referenceCalendar = calendarObject;
    
    return self;
}

-(SourceRepresentation *)getSource
{
//    SourceRepresentation *representation = [[SourceRepresentation alloc] initWithSource:self.referenceCalendar.source];
  //  return representation;
    return nil;
    
}

-(id)getEKEventCalendar
{
    return self.referenceCalendar;
}


-(UIColor *)getColor
{
    UIColor *retColor = [UIColor redColor];
    
    
    return retColor;
}

-(NSString *)getTitle
{
    NSString *retString = @"null?";
    
    
    return retString;
}


-(NSString *)getTheCalendarIdentifier
{
    NSString *retString = @"";
    
    return retString;
}

-(void)setTitleWithText:(NSString *)theTitleText;
{
//    self.referenceCalendar.title = theTitleText;
}

-(void)setColorWithCGColor:(CGColorRef)theColorRef
{
//    self.referenceCalendar.CGColor = theColorRef;
}

@end
