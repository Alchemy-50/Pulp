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
    return [Utils getScreenHeight] * pct;
}



@end
