//
//  AppStateManager.m
//  Calendar
//
//  Created by Jay Canty on 4/23/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "AppStateManager.h"
#import "GroupDiskManager.h"

@implementation AppStateManager

static AppStateManager *theManager;

@synthesize  tableViewExpanded, observingEventStore, donnotAllowNotifications, totalEventCountForPull;

+(AppStateManager *)sharedManager
{
    if (theManager == nil)
        theManager = [[AppStateManager alloc] init];
    
    return theManager;
}

- (AppStateManager *) init
{
    self = [super init];

    self.tableViewExpanded = NO;
    self.observingEventStore = YES;
    
    self.totalEventCountForPull = -1; // think this is dead who knows
    
    self.donnotAllowNotifications = NO;
    
    return self;
}


- (int) getTotalEventCountForPull
{
    @synchronized(self) {
        return totalEventCountForPull;
    }    
}


- (void) setTotalEventCountForPull:(int)count
{
    @synchronized(self) {
        totalEventCountForPull = count;
    }     
}




@end
