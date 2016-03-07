//
//  SettingsManager.h
//  Calendar
//
//  Created by Alchemy50 on 6/11/14.
//
//

#import <Foundation/Foundation.h>

@interface SettingsManager : NSObject


+(SettingsManager *)getSharedSettingsManager;

-(BOOL)startWithMonday;
-(BOOL)startTimeInTwentyFour;
-(BOOL)tempInCelcius;
-(NSString *)getDefaultCalendarID;

-(void)setStartWithMonday:(BOOL)val;
-(void)setTimeInTwentyFour:(BOOL)val;
-(void)setTempInCelcius:(BOOL)val;
-(void)setDefaultCalendarID:(NSString *)theDefaultCalendarID;

@end
