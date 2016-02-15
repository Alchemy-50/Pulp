//
//  EventContainerObject.h
//  AlphaRow
//
//  Created by Josh Klobe on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@protocol EventContainerObject <NSObject>

-(EKEvent *)getEventFromObject;
@end
