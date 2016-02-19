//
//  CalendarManagementViewController.m
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "CalendarManagementViewController.h"
#import "ThemeManager.h"
#import "Utils.h"
#import "CalendarManagementTableViewController.h"
#import "MainViewController.h"



@interface CalendarManagementViewController ()
@property (nonatomic, retain) CalendarManagementTableViewController *calendarManagementTableViewController;
@end

@implementation CalendarManagementViewController


static CalendarManagementViewController *theStaticVC;

+(CalendarManagementViewController *)sharedCalendarManagementViewController
{
    if (theStaticVC == nil)
    {
        theStaticVC = [[CalendarManagementViewController alloc] initWithNibName:nil bundle:nil];
        theStaticVC.view.frame = CGRectMake(0, 0, [Utils getScreenWidth], [Utils getScreenHeight]);
        [theStaticVC initialize];
    }
    
    return theStaticVC;
}

-(void)handleDisplay:(BOOL)doPresent
{
    if (doPresent)
    {
        [[MainViewController sharedMainViewController] presentViewController:self animated:YES completion:nil];
    }
    
}

-(void)initialize
{
    [[ThemeManager sharedThemeManager] registerPrimaryObject:self];
    
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
    [self.view addSubview:coverView];

    
    float yStart = 99;
    self.calendarManagementTableViewController = [[CalendarManagementTableViewController alloc] initWithNibName:nil bundle:nil];
    self.calendarManagementTableViewController.theParentController = self;
    self.calendarManagementTableViewController.view.backgroundColor = [UIColor clearColor];
    self.calendarManagementTableViewController.view.frame = CGRectMake(0, yStart, self.view.frame.size.width, self.view.frame.size.height - yStart);
    [self.view addSubview:self.calendarManagementTableViewController.view];
    
    UILabel *doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(318, 17, 40, 15)];
    doneLabel.backgroundColor = [UIColor clearColor];
    doneLabel.textAlignment = NSTextAlignmentLeft;
    doneLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12.0f];
    doneLabel.text = @"DONE";
    [self.view addSubview:doneLabel];
    
    [[ThemeManager sharedThemeManager] registerSecondaryObject:doneLabel];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.backgroundColor = [UIColor clearColor];
    doneButton.frame = CGRectMake(doneLabel.frame.origin.x - 15, 0, doneLabel.frame.size.width + 30, doneLabel.frame.origin.y + doneLabel.frame.size.height + 15);
    [doneButton addTarget:self action:@selector(doneButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    
    
    UIView *checkAllLabelBackGroundView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width * (80.0f / 375.0f), 46.0f, self.view.frame.size.width * (212.0f / 375.0f), 38)];
    checkAllLabelBackGroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:.15];
    [self.view addSubview:checkAllLabelBackGroundView];
    
    UILabel *checkAllLabel = [[UILabel alloc] initWithFrame:checkAllLabelBackGroundView.frame];
    checkAllLabel.backgroundColor = [UIColor clearColor];
    checkAllLabel.textAlignment = NSTextAlignmentCenter;
    checkAllLabel.textColor = [UIColor whiteColor];
    checkAllLabel.text = @"Check All";
    checkAllLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    [self.view addSubview:checkAllLabel];
    
    
    UIButton *checkAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    checkAllButton.backgroundColor = [UIColor clearColor];
    checkAllButton.frame = checkAllLabelBackGroundView.frame;
    [checkAllButton addTarget:self.calendarManagementTableViewController action:@selector(checkAllButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:checkAllButton];
    
}



-(void)doneButtonHit
{
    [[MainViewController sharedMainViewController] dismissViewControllerAnimated:YES completion:nil];
}






@end
