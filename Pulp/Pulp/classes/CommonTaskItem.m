//
//  CommonTaskItem.m
//  Calendar
//
//  Created by jay canty on 1/19/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "CommonTaskItem.h"

@implementation CommonTaskItem

@synthesize eventID, order, automatic;

-(CommonTaskItem *)initWithEventID:eventId {
    
    if (self = [super init])
    {
        self.eventID = eventId;
        self.order = -1;
        self.automatic = NO;
    }     
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:eventID forKey:@"eventID"];
    [encoder encodeBool:automatic forKey:@"automatic"];
    [encoder encodeInt:order forKey:@"order"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    if (self = [super init])
    {
        self.eventID = [decoder decodeObjectForKey:@"eventID"];
        self.automatic = [decoder decodeBoolForKey:@"automatic"];
        self.order = [decoder decodeIntForKey:@"order"];
    }    
    return self;
}



@end
