//
//  EventStoreChangeThread.m
//  Calendar
//
//  Created by Jay Canty on 5/30/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "EventStoreChangeThread.h"
#import "EventKitManager.h"
#import "MainViewController.h"
#import <EventKit/EventKit.h>

@interface EventStoreChangeThread ()
@property (nonatomic, assign) NSTimer *notificationWatchTimer;
@property (nonatomic, assign) int count;
@end


@implementation EventStoreChangeThread



- (id)init
{
    if ((self = [super init])) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifyRoot:)
                                                     name:EKEventStoreChangedNotification object:[[EventKitManager sharedManager] getTheEventStore]];
    }
    return self;
}


- (void) notifyRoot:(id)sender
{
 /*
    NSLog(@"notifyRoot, sender: %@", sender);
    NSLog(@"sender.class: %@", [sender class]);
    
    id userInfo = [sender userInfo];
    NSLog(@"userInfo!: %@", userInfo);
    NSLog(@"userInfo.class: %@", [userInfo class]);

    if ([userInfo isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary *)userInfo;
        NSLog(@"dict: %@", dict);
        NSArray *ar = [dict objectForKey:@"EKEventStoreChangedObjectIDsUserInfoKey"];
        NSLog(@"ar: %@", ar);
        for (int i = 0; i < [ar count]; i++)
        {
            id obj = [ar objectAtIndex:i];
            NSLog(@"obj[%d]: %@", i, [ar objectAtIndex:i]);
            NSLog(@"obj.class: %@", [obj class]);
            NSString *desc = [obj description];
            NSLog(@"desc: %@", desc);
            NSLog(@"desc.class: %@", [desc class]);
            
            NSURL *theURL = [NSURL URLWithString:desc];
            NSError *error = nil;
            NSData* data = [NSData dataWithContentsOfURL:theURL options:NSDataReadingUncached error:&error];
            NSLog(@"theURL: %@", theURL);
            NSLog(@"error: %@", error);
            NSLog(@"data.length: %lu", (unsigned long)[data length]);
            
        }
    }
    
*/
  
    

    self.count = 0;
    if (self.notificationWatchTimer == nil)
    {
        self.notificationWatchTimer = [[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES] retain];
        [self.notificationWatchTimer fire];
        
        
        [[MainViewController sharedMainViewController] dataChanged];
        
        //[[MainViewController sharedMainViewController] eventStoreChangedNotificationFired];

        
    }

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"ThreadNotification" object:self];
}


-(void)timerFired
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.count++;
    NSLog(@"count!: %d", self.count);
    
    if (self.count >= 2)
    {
        [self.notificationWatchTimer invalidate];
        self.notificationWatchTimer = nil;
        self.count = 0;
        [[MainViewController sharedMainViewController] dismissUpdatingCoverView];
    }
}







@end
