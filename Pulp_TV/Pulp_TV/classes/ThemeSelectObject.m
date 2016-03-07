//
//  ThemeSelectObject.m
//  Calendar
//
//  Created by Josh Klobe on 2/10/16.
//
//

#import "ThemeSelectObject.h"
#import <UIKit/UIKit.h>

@implementation ThemeSelectObject



+(ThemeSelectObject *)getA50Color
{
    ThemeSelectObject *obj = [[ThemeSelectObject alloc] init];
    obj.primaryColor = [UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1];
    obj.secondaryColor = [UIColor colorWithRed:194.0f/255.0f green:166.0f/255.0f blue:82.0f/255.0f alpha:1];
    
    return obj;
}


+(ThemeSelectObject *)getEmeraldColor
{
    ThemeSelectObject *obj = [[ThemeSelectObject alloc] init];
    obj.primaryColor = [UIColor colorWithRed:3.0f/255.0f green:176.0f/255.0f blue:152.0f/255.0f alpha:1];
    obj.secondaryColor = [UIColor colorWithRed:0.0f/255.0f green:255.0f/255.0f blue:212.0f/255.0f alpha:1];
    
    return obj;
}

+(ThemeSelectObject *)getGrapeColor
{
    ThemeSelectObject *obj = [[ThemeSelectObject alloc] init];
    obj.primaryColor = [UIColor colorWithRed:79.0f/255.0f green:7.0f/255.0f blue:49.0f/255.0f alpha:1];
    obj.secondaryColor = [UIColor colorWithRed:198.0f/255.0f green:63.0f/255.0f blue:142.0f/255.0f alpha:1];
    
    return obj;
}



+(ThemeSelectObject *)getCoralColor
{
    ThemeSelectObject *obj = [[ThemeSelectObject alloc] init];
    obj.primaryColor = [UIColor colorWithRed:241.0f/255.0f green:95.0f/255.0f blue:104.0f/255.0f alpha:1];
    obj.secondaryColor = [UIColor colorWithRed:250.0f/255.0f green:144.0f/255.0f blue:151.0f/255.0f alpha:1];
    
    return obj;
}


+(ThemeSelectObject *)getRubyColor
{
    ThemeSelectObject *obj = [[ThemeSelectObject alloc] init];
    obj.primaryColor = [UIColor colorWithRed:190.0f/255.0f green:9.0f/255.0f blue:31.0f/255.0f alpha:1];
    obj.secondaryColor = [UIColor colorWithRed:255.0f/255.0f green:29.0f/255.0f blue:37.0f/255.0f alpha:1];
    
    return obj;
}


+(ThemeSelectObject *)getGoldColor
{
    ThemeSelectObject *obj = [[ThemeSelectObject alloc] init];
    obj.primaryColor = [UIColor colorWithRed:191.0f/255.0f green:128.0f/255.0f blue:10.0f/255.0f alpha:1];
    obj.secondaryColor = [UIColor colorWithRed:255.0f/255.0f green:193.0f/255.0f blue:2.0f/255.0f alpha:1];
    
    return obj;
}


+(ThemeSelectObject *)getSunkistColor
{
    ThemeSelectObject *obj = [[ThemeSelectObject alloc] init];
    obj.primaryColor = [UIColor colorWithRed:241.0f/255.0f green:90.0f/255.0f blue:36.0f/255.0f alpha:1];
    obj.secondaryColor = [UIColor colorWithRed:255.0f/255.0f green:193.0f/255.0f blue:2.0f/255.0f alpha:1];
    
    return obj;
}


+(ThemeSelectObject *)getOceanColor
{
    ThemeSelectObject *obj = [[ThemeSelectObject alloc] init];
    obj.primaryColor = [UIColor colorWithRed:63.0f/255.0f green:169.0f/255.0f blue:245.0f/255.0f alpha:1];
    obj.secondaryColor = [UIColor colorWithRed:63.0f/255.0f green:217.0f/255.0f blue:245.0f/255.0f alpha:1];
    
    return obj;
}




@end
