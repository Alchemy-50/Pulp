//
//  ThemeSelectObject.h
//  Calendar
//
//  Created by Josh Klobe on 2/10/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeSelectObject : NSObject

@property (nonatomic, retain) UIColor *primaryColor;
@property (nonatomic, retain) UIColor *secondaryColor;

+(ThemeSelectObject *)getA50Color;
+(ThemeSelectObject *)getEmeraldColor;
+(ThemeSelectObject *)getGrapeColor;
+(ThemeSelectObject *)getCoralColor;
+(ThemeSelectObject *)getRubyColor;
+(ThemeSelectObject *)getGoldColor;
+(ThemeSelectObject *)getSunkistColor;
+(ThemeSelectObject *)getOceanColor;

@end
