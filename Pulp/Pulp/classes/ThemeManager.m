//
//  ThemeManager.m
//  Calendar
//
//  Created by Josh Klobe on 2/9/16.
//
//

#import "ThemeManager.h"
#import "PulpFAImageView.h"
#import "ThemeSelectObject.h"
#import "SidebarButtonView.h"



#define THEME_PRIMARY_COLOR_KEY @"THEME_PRIMARY_COLOR_KEY"
#define THEME_SECONDARY_COLOR_KEY @"THEME_SECONDARY_COLOR_KEY"

@interface ThemeManager ()
@property (nonatomic, retain) NSMutableArray *primaryReferenceArray;
@property (nonatomic, retain) NSMutableArray *secondaryReferenceArray;
@property (nonatomic, retain) NSMutableArray *advisoryReferenceArray;
@end

@implementation ThemeManager

static ThemeManager *theStaticManager;

+(ThemeManager *)sharedThemeManager
{
    if (theStaticManager == nil)
    {
        theStaticManager = [[ThemeManager alloc] init];
        theStaticManager.primaryReferenceArray = [[NSMutableArray alloc] initWithCapacity:0];
        theStaticManager.secondaryReferenceArray = [[NSMutableArray alloc] initWithCapacity:0];
        theStaticManager.secondaryReferenceArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        id obj = [[NSUserDefaults standardUserDefaults] objectForKey:THEME_PRIMARY_COLOR_KEY];
        if (obj == nil)
        {
            ThemeSelectObject *themeSelectObject = [ThemeSelectObject getA50Color];

        NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:themeSelectObject.primaryColor];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:THEME_PRIMARY_COLOR_KEY];
        
        colorData = [NSKeyedArchiver archivedDataWithRootObject:themeSelectObject.secondaryColor];
        [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:THEME_SECONDARY_COLOR_KEY];
        }

        
    }
    
    
    return theStaticManager;
}



-(void)registerPrimaryObject:(id)theObj
{
    if (![self.primaryReferenceArray containsObject:theObj])
        [self.primaryReferenceArray addObject:theObj];
    
    [self updatePrimaryObject:theObj];
    
    
}


-(void)updatePrimaryObject:(id)obj
{
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:THEME_PRIMARY_COLOR_KEY];
    UIColor *theColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    
    if ([obj isKindOfClass:[UIViewController class]])
    {
        UIViewController *vc = (UIViewController *)obj;
        vc.view.backgroundColor = theColor;
    }
    else if ([obj isKindOfClass:[PulpFAImageView class]])
    {
        PulpFAImageView *theView = (PulpFAImageView *)obj;
        [theView loadWithColor:theColor];
        
    }
    else if ([obj isKindOfClass:[UIView class]])
    {
        UIView *theView = (UIView *)obj;
        theView.backgroundColor = theColor;
    }
}




-(void)registerSecondaryObject:(id)theObj
{
    if (![self.secondaryReferenceArray containsObject:theObj])
        [self.secondaryReferenceArray addObject:theObj];
    
    [self updateSecondaryObject:theObj];
    
    
}


-(void)updateSecondaryObject:(id)obj
{
    NSData *colorData = [[NSUserDefaults standardUserDefaults] objectForKey:THEME_SECONDARY_COLOR_KEY];
    UIColor *theColor = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
    
    
    if ([obj isKindOfClass:[UIViewController class]])
    {
        UIViewController *vc = (UIViewController *)obj;
        vc.view.backgroundColor = theColor;
    }
    else if ([obj isKindOfClass:[PulpFAImageView class]])
    {
        PulpFAImageView *theView = (PulpFAImageView *)obj;
        [theView loadWithColor:theColor];
    
    }
    else if ([obj isKindOfClass:[UILabel class]])
    {
        UILabel *theLabel = (UILabel *)obj;
        theLabel.textColor = theColor;
    }
    else if ([obj isKindOfClass:[UITextField class]])
    {
        UITextField *theTextField = (UITextField *)obj;
        theTextField.textColor = theColor;
    }
    else if ([obj isKindOfClass:[UIView class]])
    {
        UIView *theView = (UIView *)obj;
        theView.backgroundColor = theColor;
    }

}


-(void)registerAdvisoryObject:(id)theObj
{
    if (![self.advisoryReferenceArray containsObject:theObj])
        [self.advisoryReferenceArray addObject:theObj];
    
    [self updateAdvisoryObject:theObj];
    
    
}


-(void)updateAdvisoryObject:(id)obj
{
    NSData *primaryColorData = [[NSUserDefaults standardUserDefaults] objectForKey:THEME_PRIMARY_COLOR_KEY];
    UIColor *primaryColor = [NSKeyedUnarchiver unarchiveObjectWithData:primaryColorData];
    
    NSData *secondaryColorData = [[NSUserDefaults standardUserDefaults] objectForKey:THEME_SECONDARY_COLOR_KEY];
    UIColor *secondaryColor = [NSKeyedUnarchiver unarchiveObjectWithData:secondaryColorData];
 
    
    [obj adviseThemeUpdateWithPrimaryColor:primaryColor withSecondaryColor:secondaryColor];
    
}


-(void)removeThemeObject:(id)obj
{
    [self.primaryReferenceArray removeObject:obj];
    [self.secondaryReferenceArray removeObject:obj];
    [self.advisoryReferenceArray removeObject:obj];
}



-(void)updateThemeColorWithPrimaryColor:(UIColor *)primaryColor withSecondaryColor:(UIColor *)secondaryColor
{
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:primaryColor];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:THEME_PRIMARY_COLOR_KEY];
    
    colorData = [NSKeyedArchiver archivedDataWithRootObject:secondaryColor];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:THEME_SECONDARY_COLOR_KEY];
    
    for (int i = 0; i < [self.primaryReferenceArray count]; i++)
    {
        [self updatePrimaryObject:[self.primaryReferenceArray objectAtIndex:i]];
    }
    
    for (int i = 0; i < [self.secondaryReferenceArray count]; i++)
    {
        [self updateSecondaryObject:[self.secondaryReferenceArray objectAtIndex:i]];
    }
    
    for (int i = 0; i < [self.advisoryReferenceArray count]; i++)
    {
        [self updateAdvisoryObject:[self.advisoryReferenceArray objectAtIndex:i]];
    }
    
}

+(void)addCoverViewToView:(UIView *)theView
{
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, theView.frame.size.width, theView.frame.size.height)];
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
    [theView addSubview:coverView];

}


@end
