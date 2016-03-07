//
//  CalendarConverter.h
//  Pulp
//
//  Created by Josh Klobe on 3/3/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
@interface CalendarConverter : NSObject


+(NSDictionary *)loadWithCalendar:(EKCalendar *)theCalendar;

@end
