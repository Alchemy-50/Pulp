//
//  SidebarButtonView.m
//  Calendar
//
//  Created by Josh Klobe on 2/11/16.
//
//

#import "SidebarButtonView.h"
#import "PulpFAImageView.h"
#import "ThemeManager.h"
#import "MainViewController.h"


@interface SidebarButtonView ()
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, assign) int referenceType;
@property (nonatomic, retain) PulpFAImageView *theImageView;

@property (nonatomic, retain) UIColor *referencePrimaryColor;
@property (nonatomic, retain) UIColor *referenceSecondaryColor;
@end

@implementation SidebarButtonView


static NSMutableArray *allButtonsArray;

-(void)loadWithType:(int)theType
{
    if (allButtonsArray == nil)
        allButtonsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    if (![allButtonsArray containsObject:self])
        [allButtonsArray addObject:self];
    
    
    self.backgroundColor = [UIColor clearColor];
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.backgroundView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.backgroundView];
    
    self.referenceType = theType;
    
    NSString *lookupString = @"";
    switch (theType) {
        case SIDEBAR_BUTTON_TYPE_CHEVRON:
            lookupString = @"fa-chevron-circle-up";
            break;
            
        case SIDEBAR_BUTTON_TYPE_CHECKSQUARE:
            lookupString = @"fa-check-square";
            break;
            
        case SIDEBAR_BUTTON_TYPE_CALENDAR:
            lookupString = @"fa-calendar";
            break;
            
        case SIDEBAR_BUTTON_TYPE_COG:
            lookupString = @"fa-cog";
            break;
            
            
            
            
        default:
            break;
    }
    
    
    float desiredHeight = self.frame.size.height * .70;
    float spacer = 22.0f;
    
    CGSize actualSize = [PulpFAImageView getImageSizeFromString:lookupString withDesiredHeight:desiredHeight];
    
    self.theImageView = [[PulpFAImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - actualSize.width /2, self.frame.size.height * .7175 - spacer, actualSize.width, actualSize.height)];
    self.theImageView.desiredHeight = desiredHeight;
    self.theImageView.referenceString = lookupString;
    [self addSubview:self.theImageView];
    
    if (theType == SIDEBAR_BUTTON_TYPE_CHEVRON)
        self.theImageView.transform = CGAffineTransformMakeRotation(45 * M_PI/180);
    
    UIButton *theButton = [UIButton buttonWithType:UIButtonTypeCustom];
    theButton.backgroundColor = [UIColor clearColor];
    theButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [theButton addTarget:self action:@selector(theButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:theButton];

    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.theImageView];
    [[ThemeManager sharedThemeManager] registerAdvisoryObject:self];
}

-(void)adviseThemeUpdateWithPrimaryColor:(UIColor *)thePrimaryColor withSecondaryColor:(UIColor *)theSecondaryColor
{
    self.referencePrimaryColor = thePrimaryColor;
    self.referenceSecondaryColor = theSecondaryColor;
}

-(void)theButtonHit
{    
    switch (self.referenceType) {
        case SIDEBAR_BUTTON_TYPE_CHEVRON:

            [[MainViewController sharedMainViewController] resetCoverScrollToDate:[NSDate date]];
            break;
            
        case SIDEBAR_BUTTON_TYPE_CHECKSQUARE:
            [SidebarButtonView toggleButtonStatesWithSelectedButton:self];
            [[MainViewController sharedMainViewController] toggleToTodos];
            break;
            
            
        case SIDEBAR_BUTTON_TYPE_CALENDAR:
            [SidebarButtonView toggleButtonStatesWithSelectedButton:self];
            [[MainViewController sharedMainViewController] toggleToCalendar];
            break;
            
        case SIDEBAR_BUTTON_TYPE_COG:
            [[MainViewController sharedMainViewController] presentSettingsViewController];
            break;
            
            
        default:
            break;
    }
}

+(void)toggleButtonStatesWithSelectedButton:(SidebarButtonView *)theSelectedButton
{
 
    
    for (int i = 0; i < [allButtonsArray count]; i++)
    {
        SidebarButtonView *theButtonView = [allButtonsArray objectAtIndex:i];
        if (theSelectedButton == nil)
            theButtonView.backgroundView.backgroundColor = [UIColor clearColor];
        
        else if (theButtonView == theSelectedButton)
            theButtonView.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
                 
        else
            theButtonView.backgroundView.backgroundColor = [UIColor clearColor];
    }
}

@end

