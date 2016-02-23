//
//  EventStoreChangeThread.m
//  Calendar
//
//  Created by Jay Canty on 5/30/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "EventStoreChangeThread.h"
#import "EventKitManager.h"

@interface EventStoreChangeThread ()
@property (nonatomic, assign) NSTimer *notificationWatchTimer;
@property (nonatomic, assign) int count;
@end


@implementation EventStoreChangeThread



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
    NSLog(@"notifyRoot, sender: %@", sender);

    self.count = 0;
    if (self.notificationWatchTimer == nil)
    {
        self.notificationWatchTimer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES] retain];
        [self.notificationWatchTimer fire];
    }

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ThreadNotification" object:self];
}


-(void)timerFired
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.count++;
    NSLog(@"count!: %d", self.count);
}







@end
