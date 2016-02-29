//
//  EventConverter.h
//  Pulp
//
//  Created by Josh Klobe on 2/19/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EventKitManager.h"



@interface EventConverter : NSObject


+(NSDictionary *)getEventDictionaryFromEvent:(EKEvent *)theEvent;
@end
