//
//  NotificationInfo.m
//  Calendar
//
//  Created by Jay Canty on 5/1/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "NotificationInfo.h"

@implementation NotificationInfo

@synthesize updateType;

- (NotificationInfo *) initWithUpdateType:(int)uType
{
    self = [super init];
    
    self.updateType = uType;
    
    return self;
}



@end
