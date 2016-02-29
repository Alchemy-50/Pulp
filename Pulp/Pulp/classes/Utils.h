//
//  Utils.h
//  Calendar
//
//  Created by Josh Klobe on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CalendarEvent.h"



@interface Utils : NSObject

+(BOOL)isIPad;
+(float)getScreenWidth;
+(float)getScreenHeight;
+(float)getSidebarWidth;
+ (NSString *)urlencode:(NSString *)theString;
+(float)getXInFramePerspective:(float)referenceX;
+(float)getYInFramePerspective:(float)referenceY;

@end
