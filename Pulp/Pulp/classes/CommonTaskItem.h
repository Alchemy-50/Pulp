//
//  CommonTaskItem.h
//  Calendar
//
//  Created by jay canty on 1/19/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalendarEvent.h"


@interface CommonTaskItem : NSObject <NSCoding> {
        
    NSString *eventID;
    int order;
    BOOL automatic;
}

-(CommonTaskItem *)initWithEventID:eventId;

@property (nonatomic, retain) NSString *eventID;
@property (nonatomic, assign) int order;
@property (nonatomic, assign) BOOL automatic;

@end
