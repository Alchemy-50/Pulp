//
//  CalendarConverter.m
//  Pulp
//
//  Created by Josh Klobe on 3/3/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "CalendarConverter.h"
#import <UIKit/UIKit.h>

@implementation CalendarConverter


+(NSDictionary *)loadWithCalendar:(EKCalendar *)theCalendar
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
    [dict setObject:[theCalendar.calendarIdentifier debugDescription] forKey:@"calendarIdentifier"];
    [dict setObject:[theCalendar.title debugDescription] forKey:@"title"];
    [dict setObject:[NSNumber numberWithInt:theCalendar.type] forKey:@"type"];
    [dict setObject:[[UIColor colorWithCGColor:theCalendar.CGColor] description] forKey:@"colorInRGB"];
    
    return dict;
}


/*
@property(nonatomic, strong) EKSource        *source;
@property(nonatomic, readonly) NSString         *calendarIdentifier NS_AVAILABLE(10_8, 5_0);
@property(nonatomic, copy)     NSString          *title;
@property(nonatomic, readonly)     EKCalendarType     type;
@property(nonatomic, readonly) BOOL allowsContentModifications;
@property(nonatomic, readonly, getter=isSubscribed) BOOL subscribed NS_AVAILABLE(10_8, 5_0);
@property(nonatomic, readonly, getter=isImmutable) BOOL immutable NS_AVAILABLE(10_8, 5_0);
@property(nonatomic) CGColorRef CGColor;
*/




@end
