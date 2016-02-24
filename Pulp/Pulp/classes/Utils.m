//
//  Utils.m
//  Calendar
//
//  Created by Josh Klobe on 12/20/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Utils.h"
#import <QuartzCore/QuartzCore.h>
#import "EventKitManager.h"





@implementation Utils


+(BOOL)isIPad
{
    

#ifdef UI_USER_INTERFACE_IDIOM
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
#else
    return NO;
#endif
}

+(UIColor *)getAppColor:(int)colorDefinition
{
    UIColor *returnColor = nil;
    
    switch (colorDefinition) {
        case COLOR_1:
            returnColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1];
            break;
        case COLOR_2:
            returnColor = [UIColor colorWithRed:237/255.0f green:237/255.0f blue:237/255.0f alpha:1];
            break;
        case COLOR_3:
            returnColor = [UIColor colorWithRed:226/255.0f green:226/255.0f blue:226/255.0f alpha:1];
            break;
        case COLOR_4:
            returnColor = [UIColor colorWithRed:115/255.0f green:115/255.0f blue:115/255.0f alpha:1];
            break;
        case COLOR_5:
            returnColor = [UIColor colorWithRed:23/255.0f green:188/255.0f blue:180/255.0f alpha:1];
            break;
        case COLOR_6:
            returnColor = [UIColor colorWithRed:250/255.0f green:105/255.0f blue:0/255.0f alpha:1];
            break;
        case COLOR_7:
            returnColor = [UIColor colorWithRed:243/255.0f green:3/255.0f blue:110/255.0f alpha:1];
            break;
        case COLOR_8:
            returnColor = [UIColor colorWithRed:255/255.0f green:186/255.0f blue:6/255.0f alpha:1];
            break;
        case COLOR_9:
            returnColor = [UIColor colorWithRed:50/255.0f green:176/255.0f blue:152/255.0f alpha:1];
            break;
        case COLOR_10:
            returnColor = [UIColor colorWithRed:171/255.0f green:171/255.0f blue:171/255.0f alpha:1];
            break;
        case COLOR_11:
            returnColor = [UIColor colorWithRed:44/255.0f green:54/255.0f blue:59/255.0f alpha:1];
            break;
        case COLOR_12:
            returnColor = [UIColor colorWithRed:0/255.0f green:0/255.0f blue:0/255.0f alpha:1];
            break;
        case COLOR_13:
            returnColor = [UIColor colorWithRed:237/255.0f green:224/255.0f blue:165/255.0f alpha:1];
            break;
        case COLOR_14:
            returnColor = [UIColor colorWithRed:150/255.0f green:127/255.0f blue:93/255.0f alpha:1];
            break;
        case COLOR_15:
            returnColor = [UIColor colorWithRed:222/255.0f green:222/255.0f blue:222/255.0f alpha:1];
            break;
            
            
        default:
            break;
    }
    
  
    return returnColor;
        
}

+(void)changeColors:(UIView *)theView withTopColor:(UIColor *)topColor withBottomColor:(UIColor *)bottomColor
{		
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = theView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[topColor CGColor], (id)[bottomColor CGColor], nil];
    for (int i = 0; i < [[theView.layer sublayers] count]; i++)
        if ([[[theView.layer sublayers] objectAtIndex:i] class] == [CAGradientLayer class]) 
            [(CAGradientLayer *)[[theView.layer sublayers] objectAtIndex:i] removeFromSuperlayer];
    [theView.layer insertSublayer:gradient atIndex:0];	
}

+ (CalendarEvent *) copyCalendarEvent:(CalendarEvent *)inCalEvent
{
    EKEvent *outEKEvent = [[EventKitManager sharedManager] getNewEKEvent];
    
    EKEvent *inEKEvent = [inCalEvent getEkEventWithParameter:nil];
    
    outEKEvent.allDay = inEKEvent.allDay;
    outEKEvent.availability = inEKEvent.availability;
    outEKEvent.endDate = inEKEvent.endDate;
    outEKEvent.startDate = inEKEvent.startDate;
    
    outEKEvent.calendar = inEKEvent.calendar;
    outEKEvent.title = inEKEvent.title;
    outEKEvent.location = inEKEvent.location;
    
    outEKEvent.timeZone = inEKEvent.timeZone;
    outEKEvent.URL = inEKEvent.URL;
    outEKEvent.notes = inEKEvent.notes;

    //outEKEvent.alarms = inEKEvent.alarms;
    
    for (EKAlarm *alIn in inEKEvent.alarms)
    {
        EKAlarm *alOut = [EKAlarm alarmWithRelativeOffset:alIn.relativeOffset];
        [outEKEvent addAlarm:alOut];
    }
    
    for (EKRecurrenceRule *rrIn in inEKEvent.recurrenceRules)
    {
        EKRecurrenceRule *rrOut = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:rrIn.frequency interval:rrIn.interval daysOfTheWeek:rrIn.daysOfTheWeek daysOfTheMonth:rrIn.daysOfTheMonth 
        monthsOfTheYear:rrIn.monthsOfTheYear weeksOfTheYear:rrIn.weeksOfTheYear daysOfTheYear:rrIn.daysOfTheYear setPositions:rrIn.setPositions end:rrIn.recurrenceEnd];
                
        [outEKEvent addRecurrenceRule:rrOut];        
    }

    CalendarEvent *outCalEvent = [[CalendarEvent alloc] initWithSingleEKEvent:outEKEvent];
    
    outCalEvent.participants = inCalEvent.participants;
    outCalEvent.organizer = inCalEvent.organizer;
    outCalEvent.fbEventID = inCalEvent.fbEventID;
    outCalEvent.validEvent = inCalEvent.validEvent;
    
    return outCalEvent;
}

+ (CalendarEvent *) partialCopyCalendarEvent:(CalendarEvent *)eventToCopy toCalendarEvent:(CalendarEvent *)copyingEvent
{
    // calendar is not assigned here!!!!!!!!!!!!!
    
    EKEvent *ekEventToCopy = [eventToCopy getEkEventWithParameter:nil];
    EKEvent *copyingEKEvent = [copyingEvent getEkEventWithParameter:nil];
    
    copyingEKEvent.allDay = ekEventToCopy.allDay;
    copyingEKEvent.availability = ekEventToCopy.availability;
    copyingEKEvent.endDate = ekEventToCopy.endDate;
    copyingEKEvent.startDate = ekEventToCopy.startDate;
    
    copyingEKEvent.title = ekEventToCopy.title;
    copyingEKEvent.location = ekEventToCopy.location;
    
    copyingEKEvent.timeZone = ekEventToCopy.timeZone;
    copyingEKEvent.URL = ekEventToCopy.URL;
    copyingEKEvent.notes = ekEventToCopy.notes;
    
    //copyingEKEvent.alarms = ekEventToCopy.alarms;
    
    for (EKAlarm *alIn in ekEventToCopy.alarms)
    {
        EKAlarm *alOut = [EKAlarm alarmWithRelativeOffset:alIn.relativeOffset];
        [copyingEKEvent addAlarm:alOut];
    }

    for (EKRecurrenceRule *rrIn in ekEventToCopy.recurrenceRules)
    {
        EKRecurrenceRule *rrOut = [[EKRecurrenceRule alloc] initRecurrenceWithFrequency:rrIn.frequency interval:rrIn.interval daysOfTheWeek:rrIn.daysOfTheWeek daysOfTheMonth:rrIn.daysOfTheMonth 
                                                                        monthsOfTheYear:rrIn.monthsOfTheYear weeksOfTheYear:rrIn.weeksOfTheYear daysOfTheYear:rrIn.daysOfTheYear setPositions:rrIn.setPositions end:rrIn.recurrenceEnd];
        [copyingEKEvent addRecurrenceRule:rrOut];
    }
        
    [copyingEvent setEkObject:copyingEKEvent];
    
    copyingEvent.participants = eventToCopy.participants;
    copyingEvent.organizer = eventToCopy.organizer;
    copyingEvent.fbEventID = eventToCopy.fbEventID;
    copyingEvent.validEvent = eventToCopy.validEvent;
    
    return copyingEvent;
}


+ (UIImage*) hueImageWithImage:(UIImage*) source fixedHue:(CGFloat) hue alpha:(CGFloat) alpha withSaturation:(float)theSaturation withBrigtness:(float)theBrightness
// Note: the hue input ranges from 0.0 to 1.0, both red.  Values outside this range will be clamped to 0.0 or 1.0.
{
    // Find the image dimensions.
    CGSize imageSize = [source size];
    CGRect imageExtent = CGRectMake(0,0,imageSize.width,imageSize.height);
    
    // Create a context containing the image.
    UIGraphicsBeginImageContext(imageSize);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [source drawAtPoint:CGPointMake(0,0)];
    
    // Draw the hue on top of the image.
    CGContextSetBlendMode(context, kCGBlendModeHue);
    [[UIColor colorWithHue:hue saturation:theSaturation brightness:theBrightness alpha:alpha] set];
    UIBezierPath *imagePath = [UIBezierPath bezierPathWithRect:imageExtent];
    [imagePath fill];
    
    // Retrieve the new image.
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return result;
}


+(float)getScreenWidth
{
    float screenWidth = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].bounds.size.width < screenWidth)
        screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    return screenWidth;
}

+(float)getScreenHeight
{
    float screenHeight = [UIScreen mainScreen].bounds.size.height;
    if ([UIScreen mainScreen].bounds.size.width > screenHeight)
        screenHeight = [UIScreen mainScreen].bounds.size.width;
    
    return screenHeight;
}

+(float)getSidebarWidth
{
    return 60;
}


+ (NSString *)urlencode:(NSString *)theString
{
    
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[theString UTF8String];
    unsigned long sourceLen = strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}


+(float)getXInFramePerspective:(float)referenceX
{
    float originalWidth = 375;
    
    float pct = referenceX / originalWidth;
    
    return [Utils getScreenWidth] * pct;
    
    
}


+(float)getYInFramePerspective:(float)referenceY
{
    float originalHeight = 667;
    float pct = referenceY / originalHeight;
    return [Utils getScreenWidth] * pct;
}



@end
