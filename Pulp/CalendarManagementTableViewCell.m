//
//  CalendarManagementTableViewCell.m
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "CalendarManagementTableViewCell.h"
#import "ThemeManager.h"
#import "PulpFAImageView.h"
#import "EventKitManager.h"
#import "GroupDiskManager.h"


@interface CalendarManagementTableViewCell ()


@property (nonatomic, retain) UILabel *sourceLabel;
@property (nonatomic, retain) PulpFAImageView *checkBoxImageView;
@property (nonatomic, retain) UIButton *checkButton;
@property (nonatomic, retain) UIView *stripeView;
@property (nonatomic, retain) UILabel *calendarNameLabel;
@property (nonatomic, retain) PulpFAImageView *cogImageView;
@property (nonatomic, retain) UIView *strokeView;

@property (nonatomic, retain) CalendarRepresentation *referenceCalendar;

@end

@implementation CalendarManagementTableViewCell


-(void) initialize
{
    float eyeDesiredHeight = self.frame.size.height * .85;
    
    NSString *eyeLookupString = @"fa-eye";
    
    CGSize actualSize = [PulpFAImageView getImageSizeFromString:eyeLookupString withDesiredHeight:eyeDesiredHeight];
    
    self.checkBoxImageView = [[PulpFAImageView alloc] initWithFrame:CGRectMake(18,9.5, actualSize.width / 2, actualSize.height / 2)];
    self.checkBoxImageView.desiredHeight = eyeDesiredHeight;
    self.checkBoxImageView.referenceString = eyeLookupString;
    [self addSubview:self.checkBoxImageView];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.checkBoxImageView];
    

    
    self.checkButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    self.checkButton.frame = CGRectMake(0, 0, self.checkBoxImageView.frame.origin.x + self.checkBoxImageView.frame.size.width + 3, self.frame.size.height);
    [self.checkButton addTarget:self action:@selector(checkButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.checkButton];
    
    float inset = self.frame.size.height * .05;
    self.stripeView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width * ( 53.0f / 375.0f), inset, 3, self.frame.size.height - 2 * inset)];
    self.stripeView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.stripeView];
    
    
    
    self.calendarNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 0, self.frame.size.width - 80, self.frame.size.height)];
    self.calendarNameLabel.backgroundColor = [UIColor clearColor];
    self.calendarNameLabel.textAlignment = NSTextAlignmentLeft;
    self.calendarNameLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    self.calendarNameLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.calendarNameLabel];

    
    self.sourceLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, self.frame.size.height / 2, self.frame.size.width, self.frame.size.height / 2)];
    self.sourceLabel.backgroundColor = [UIColor clearColor];
    self.sourceLabel.textAlignment = NSTextAlignmentLeft;
    self.sourceLabel.font = [UIFont fontWithName:@"Lato-Bold" size:11];
    self.sourceLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.sourceLabel];

    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.sourceLabel];
    
    
    float desiredHeight = self.frame.size.height * .45;
    NSString *lookupString = @"fa-cog";
    actualSize = [PulpFAImageView getImageSizeFromString:lookupString withDesiredHeight:desiredHeight];
    
    self.cogImageView = [[PulpFAImageView alloc] initWithFrame:CGRectMake(self.frame.size.width * (335.0f / 375.0f), self.frame.size.height / 2 - actualSize.height / 2, actualSize.width, actualSize.height)];
    self.cogImageView.desiredHeight = desiredHeight;
    self.cogImageView.referenceString = lookupString;
    [self addSubview:self.cogImageView];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.cogImageView];
    
    
    self.strokeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height -1 , self.frame.size.width, 1)];
    self.strokeView.backgroundColor = [UIColor colorWithWhite:0 alpha:.15];
    [self addSubview:self.strokeView];
    
    
}

-(void) cleanViews
{
    self.sourceLabel.text = @"";
    self.calendarNameLabel.text = @"";

    self.cogImageView.alpha = 0;
    self.stripeView.alpha = 0;
    
    self.referenceCalendar = nil;
    self.checkBoxImageView.alpha = 0;
}

-(void) loadWithSource:(SourceRepresentation *)theSource
{
    self.sourceLabel.text = [theSource getTitle];

}

-(void) loadWithCalendar:(CalendarRepresentation *)theCalendar
{
    self.referenceCalendar = theCalendar;
    
    self.stripeView.alpha = 1;
    self.cogImageView.alpha = 1;
    self.checkBoxImageView.alpha = 1;
    
    self.calendarNameLabel.text = [theCalendar getTitle];
    self.stripeView.backgroundColor = [theCalendar getColor];
    
    [self setCheckBoxImageViewState];
}


-(void)checkButtonHit
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY]];
    BOOL val = [[dict objectForKey:[self.referenceCalendar getTheCalendarIdentifier]] boolValue];
    val = !val;
    
    [dict setObject:[NSNumber numberWithBool:val] forKey:[self.referenceCalendar getTheCalendarIdentifier]];
    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:dict withKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY];
    
    [self setCheckBoxImageViewState];
}



-(void)setCheckBoxImageViewState
{    
    NSDictionary *dict = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY];
    if ([[dict objectForKey:[self.referenceCalendar getTheCalendarIdentifier]] boolValue])
    {
        self.checkBoxImageView.referenceString = @"fa-eye";
    }
    else
    {
        self.checkBoxImageView.referenceString = @"fa-eye-slash";
    }
    
    [self.checkBoxImageView loadWithColor:self.checkBoxImageView.referenceColor];
}




@end
