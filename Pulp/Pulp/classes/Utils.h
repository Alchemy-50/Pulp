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

#define  COLOR_1 1
#define  COLOR_2 2
#define  COLOR_3 3
#define  COLOR_4 4
#define  COLOR_5 5
#define  COLOR_6 6
#define  COLOR_7 7
#define  COLOR_8 8
#define  COLOR_9 9
#define  COLOR_10 10
#define  COLOR_11 11
#define  COLOR_12 12
#define  COLOR_13 13
#define  COLOR_14 14
#define  COLOR_15 15


@interface Utils : NSObject

+ (CalendarEvent *) copyCalendarEvent:(CalendarEvent *)calEvent;

+(BOOL)isIPad;

+(void) changeColors:(UIView *)theView withTopColor:(UIColor *)topColor withBottomColor:(UIColor *)bottomColor;
+(CalendarEvent *) partialCopyCalendarEvent:(CalendarEvent *)eventToCopy toCalendarEvent:(CalendarEvent *)copyingEvent;
+(UIImage*) hueImageWithImage:(UIImage*) source fixedHue:(CGFloat) hue alpha:(CGFloat) alpha withSaturation:(float)theSaturation withBrigtness:(float)theBrightness;
+(UIColor *)getAppColor:(int)colorDefinition;
+(float)getScreenWidth;
+(float)getScreenHeight;
+(float)getSidebarWidth;
+ (NSString *)urlencode:(NSString *)theString;

+(float)getXInFramePerspective:(float)referenceX;
+(float)getYInFramePerspective:(float)referenceY;
@end
