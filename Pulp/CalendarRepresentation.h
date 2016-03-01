//
//  CalendarRepresentation.h
//  Pulp
//
//  Created by Josh Klobe on 2/29/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SourceRepresentation.h"

@interface CalendarRepresentation : NSObject

-(id)initWithEventObject:(id)eventObject;
-(id)initWithCalendarObject:(id)calendarObject;
-(SourceRepresentation *)getSource;
-(id)getEKEventCalendar;
-(UIColor *)getColor;
-(NSString *)getTitle;
-(NSString *)getTheCalendarIdentifier;

-(void)setTitleWithText:(NSString *)theTitleText;
-(void)setColorWithCGColor:(CGColorRef)theColorRef;
@end
