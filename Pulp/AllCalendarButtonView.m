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
#import "PulpFAImageView.h"


@interface AllCalendarButtonView ()
@property (nonatomic, retain) UILabel *calendarsLabel;
@property (nonatomic, retain) PulpFAImageView *cogImageView;
@end


@implementation AllCalendarButtonView


static AllCalendarButtonView *theStaticView;

+(AllCalendarButtonView *)sharedButtonView
{
    if (theStaticView == nil)
    {
        theStaticView = [[AllCalendarButtonView alloc] initWithFrame:CGRectMake([Utils getXInFramePerspective:253] - [Utils getSidebarWidth], 14, [Utils getXInFramePerspective:189], 15)];
        [theStaticView initialize];
    }
    
    return theStaticView;
}


-(void)initialize
{
    self.backgroundColor = [UIColor clearColor];
    
    self.calendarsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [Utils getXInFramePerspective:85], self.frame.size.height)];
    self.calendarsLabel.backgroundColor = [UIColor clearColor];
    self.calendarsLabel.textAlignment = NSTextAlignmentRight;
    self.calendarsLabel.font = [UIFont fontWithName:@"Lato-Regular" size:14];
    self.calendarsLabel.text = @"All Calendars";
    [self addSubview:self.calendarsLabel];
    
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.calendarsLabel];
    
    
    float desiredHeight = self.frame.size.height;
    NSString *lookupString = @"fa-cog";
    CGSize actualSize = [PulpFAImageView getImageSizeFromString:lookupString withDesiredHeight:desiredHeight];
    
    self.cogImageView = [[PulpFAImageView alloc] initWithFrame:CGRectMake(self.calendarsLabel.frame.origin.x + self.calendarsLabel.frame.size.width + 11, 0, actualSize.width, actualSize.height)];
    self.cogImageView.desiredHeight = desiredHeight;
    self.cogImageView.referenceString = lookupString;
    [self addSubview:self.cogImageView];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.cogImageView];
    
}

-(void)turnOn
{
    if (self.alpha == 0)
        self.alpha = 1;
}

-(void)turnOff
{
    if (self.alpha == 1)
        self.alpha = 0;
}

@end
