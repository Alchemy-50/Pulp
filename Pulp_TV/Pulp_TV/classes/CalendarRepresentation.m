//
//  CalendarRepresentation.m
//  Pulp
//
//  Created by Josh Klobe on 2/29/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "CalendarRepresentation.h"
#import "Defs.h"
#import <Foundation/Foundation.h>


@interface CalendarRepresentation ()
//@property (nonatomic, retain) EKEvent *referenceEvent;
//@property (nonatomic, retain) EKCalendar *referenceCalendar;
@property (nonatomic, retain) id referenceEvent;
@property (nonatomic, retain) id referenceCalendar;
@property (nonatomic, retain) NSDictionary *referenceDictionary;

@end


@implementation CalendarRepresentation


-(id)initWithEventObject:(id)eventObject
{
    self = [super init];
    self.referenceEvent = eventObject;
    
    return self;
}

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    self.referenceDictionary = [[NSDictionary alloc] initWithDictionary:dictionary];
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
    UIColor *retColor = [UIColor purpleColor];
    
    if (self.referenceDictionary != nil)
    {
        NSString *colorInRGB = [self.referenceDictionary objectForKey:@"colorInRGB"];
        
        NSArray *values = [colorInRGB componentsSeparatedByString:@" "];
        CGFloat red = [[values objectAtIndex:1] floatValue];
        CGFloat green = [[values objectAtIndex:2] floatValue];
        CGFloat blue = [[values objectAtIndex:3] floatValue];
        CGFloat alpha = [[values objectAtIndex:4] floatValue];
        //UIColor *color =
        retColor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        
    }
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
