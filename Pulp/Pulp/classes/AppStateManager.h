//
//  AppStateManager.h
//  Calendar
//
//  Created by Jay Canty on 4/23/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppStateManager : NSObject {
    
    BOOL observingEventStore;
    BOOL tableViewExpanded;
    int totalEventCountForPull;   // represses notif action
    BOOL donnotAllowNotifications;
}

+(AppStateManager *)sharedManager;

- (int) getTotalEventCountForPull;
- (void) setTotalEventCountForPull:(int)count;

@property (nonatomic, assign) BOOL tableViewExpanded;
@property (nonatomic, assign) BOOL observingEventStore;
@property (nonatomic, assign) int totalEventCountForPull;
@property (nonatomic, assign) BOOL donnotAllowNotifications;

@end
