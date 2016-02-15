//
//  NotificationInfo.h
//  Calendar
//
//  Created by Jay Canty on 5/1/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationInfo : NSObject {
    
    int updateType;
    
}

@property (nonatomic, assign) int updateType;

- (NotificationInfo *) initWithUpdateType:(int)uType;

@end
