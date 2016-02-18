//
//  AllCalendarButtonView.m
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "AllCalendarButtonView.h"
#import "Utils.h"
#import "ThemeManager.h"
#import "CalendarManagementViewController.h"


@interface AllCalendarButtonView ()
@property (nonatomic, retain) UILabel *calendarsLabel;
@end


@implementation AllCalendarButtonView


static AllCalendarButtonView *theStaticView;

+(AllCalendarButtonView *)sharedButtonView
{
    if (theStaticView == nil)
    {
        theStaticView = [[AllCalendarButtonView alloc] initWithFrame:CGRectMake([Utils getScreenWidth] / 2, 0, [Utils getScreenWidth] / 2 - 60, 40)];
        [theStaticView initialize];
    }
    
    return theStaticView;
}


-(void)initialize
{

    self.backgroundColor = [UIColor clearColor];
    
    
    UIButton *calButton = [UIButton buttonWithType:UIButtonTypeCustom];
    calButton.backgroundColor = [UIColor clearColor];
    [calButton addTarget:self action:@selector(calButtonHit) forControlEvents:UIControlEventTouchUpInside];
    calButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [self addSubview:calButton];
    
    
    self.calendarsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.calendarsLabel.backgroundColor = [UIColor clearColor];
    self.calendarsLabel.textAlignment = NSTextAlignmentCenter;
    self.calendarsLabel.font = [UIFont fontWithName:@"Lato-Regular" size:self.calendarsLabel.frame.size.height / 4];
    self.calendarsLabel.text = @"All Calendars";
    [self addSubview:self.calendarsLabel];
    
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.calendarsLabel];
    
    NSLog(@"calendarsLabel: %@", self.calendarsLabel);
    
}


-(void)calButtonHit
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[CalendarManagementViewController sharedCalendarManagementViewController] handleDisplay:YES];
}



@end
