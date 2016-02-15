//
//  SettingsManager.m
//  Calendar
//
//  Created by Alchemy50 on 6/11/14.
//
//

#import "SettingsManager.h"
#import "AppDelegate.h"
#import "ContentContainerViewController.h"


#define STORED_PROPERTIES_DICTIONARY_KEY @"STORED_PROPERTIES_DICTIONARY_KEY"

#define PROPERTY_START_WITH_MONDAY @"PROPERTY_START_WITH_MONDAY"
#define PROPERTY_TIME_IN_TWENTY_FOUR @"PROPERTY_TIME_IN_TWENTY_FOUR"
#define PROPERTY_TEMPERATURE_IN_CELCIUS @"PROPERTY_TEMPERATURE_IN_CELCIUS"
#define PROPERTY_DEFAULT_CALENDER_ID @"PROPERTY_DEFAULT_CALEfNDER_ID"



@implementation SettingsManager

static SettingsManager *theStaticSettingsManager;


+(SettingsManager *)getSharedSettingsManager
{
    if (theStaticSettingsManager == nil)
    {
        theStaticSettingsManager = [[SettingsManager alloc] init];
    
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        id obj = [defaults objectForKey:PROPERTY_START_WITH_MONDAY];
        if (obj == nil)
        {
            [defaults setObject:[NSNumber numberWithBool:NO] forKey:PROPERTY_START_WITH_MONDAY];
            [defaults setObject:[NSNumber numberWithBool:NO] forKey:PROPERTY_TIME_IN_TWENTY_FOUR];
            [defaults setObject:[NSNumber numberWithBool:NO] forKey:PROPERTY_TEMPERATURE_IN_CELCIUS];
            [defaults synchronize];
        }
    }
    
    
    return theStaticSettingsManager;
}


-(BOOL)startWithMonday
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:PROPERTY_START_WITH_MONDAY] boolValue];
}

-(BOOL)startTimeInTwentyFour
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:PROPERTY_TIME_IN_TWENTY_FOUR] boolValue];
}

-(BOOL)tempInCelcius
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [[defaults objectForKey:PROPERTY_TEMPERATURE_IN_CELCIUS] boolValue];
}

-(NSString *)getDefaultCalendarID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:PROPERTY_DEFAULT_CALENDER_ID];
}


-(void)setStartWithMonday:(BOOL)val
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:val] forKey:PROPERTY_START_WITH_MONDAY];
    [defaults synchronize];
    

    [[ContentContainerViewController sharedContainerViewController] reloadViews];
}


-(void)setTimeInTwentyFour:(BOOL)val
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:val] forKey:PROPERTY_TIME_IN_TWENTY_FOUR];
    [defaults synchronize];
    
    [[MainViewController sharedMainViewController] refreshContent];
}

-(void)setTempInCelcius:(BOOL)val
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSNumber numberWithBool:val] forKey:PROPERTY_TEMPERATURE_IN_CELCIUS];
    [defaults synchronize];
    
    [[MainViewController sharedMainViewController] refreshContent];
}

-(void)setDefaultCalendarID:(NSString *)theDefaultCalendarID
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:theDefaultCalendarID forKey:PROPERTY_DEFAULT_CALENDER_ID];
    [defaults synchronize];
    
    [[MainViewController sharedMainViewController] refreshContent];
}


@end
