//
//  ThemeManager.h
//  Calendar
//
//  Created by Josh Klobe on 2/9/16.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeManager : NSObject


+(ThemeManager *)sharedThemeManager;
-(void)registerPrimaryObject:(id)theObj;
-(void)registerSecondaryObject:(id)theObj;
-(void)registerAdvisoryObject:(id)theObj;
-(void)updateThemeColorWithPrimaryColor:(UIColor *)primaryColor withSecondaryColor:(UIColor *)secondaryColor;
@end
