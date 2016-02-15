//
//  EventStoreChangeThread.h
//  Calendar
//
//  Created by Jay Canty on 5/30/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AppViewController;

@interface EventStoreChangeThread : NSThread {
    
    NSTimer *notificationWatchTimer;
    
    int count;
}

@property (nonatomic, assign) NSTimer *notificationWatchTimer;

@property (nonatomic, assign) int count;

@end
