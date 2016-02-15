//
//  EventStoreChangeThread.m
//  Calendar
//
//  Created by Jay Canty on 5/30/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "EventStoreChangeThread.h"
#import "EventKitManager.h"



@implementation EventStoreChangeThread

@synthesize notificationWatchTimer, count;

- (id)init
{
    
    if ((self = [super init])) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyRoot:)
                                                     name:EKEventStoreChangedNotification object:[EventKitManager sharedManager].eventStore];
                
    }
    return self;    
    
}

- (void) notifyRoot:(id)sender
{
    //NSLog(@"notifyRppt, sender: %@", sender);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ThreadNotification" object:self];
}









@end
