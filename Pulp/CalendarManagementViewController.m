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

    
    self.calendarManagementTableViewController = [[CalendarManagementTableViewController alloc] initWithNibName:nil bundle:nil];
    self.calendarManagementTableViewController.theParentController = self;
    self.calendarManagementTableViewController.view.backgroundColor = [UIColor clearColor];
    self.calendarManagementTableViewController.view.frame = CGRectMake(0, self.view.frame.size.height / 2, self.view.frame.size.width, self.view.frame.size.height / 2);
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
    
}

-(void)doneButtonHit
{
    [[MainViewController sharedMainViewController] dismissViewControllerAnimated:YES completion:nil];
}






/*
- (void) calButtonHit
{
    [self topCalButtonHit:NO];
}

- (void) topCalButtonHit:(BOOL)refresh
{
    //   [self.calendarDropdownViewController loadCalendars];
    
    if (self.calendarManagementTableViewController == nil)
    {
        
        
        self.calendarManagementTableViewController = [[CalendarManagementTableViewController alloc] initWithNibName:nil bundle:nil];
        self.calendarManagementTableViewController.parentFullCalendarViewController = self;
        self.calendarManagementTableViewController.view.backgroundColor = [UIColor clearColor];
        self.calendarManagementTableViewController.view.frame = CGRectMake(0, 0, 280, self.view.frame.size.height);
        self.calendarManagementTableViewController.theTableView.frame = CGRectMake(0, 0, self.calendarManagementTableViewController.theTableView.frame.size.width, self.calendarManagementTableViewController.theTableView.frame.size.height);
        self.calendarManagementTableViewController.bgView.frame = CGRectMake(0, 0, self.calendarManagementTableViewController.bgView.frame.size.width, self.calendarManagementTableViewController.bgView.frame.size.height);
        [self.view addSubview:self.calendarManagementTableViewController.view];
        
        self.calendarManagementTableViewController.view.frame = CGRectMake(0, 0, 280, 0);
        self.calendarManagementTableViewController.theTableView.frame = CGRectMake(0, 0, self.calendarManagementTableViewController.theTableView.frame.size.width, 0);
        self.calendarManagementTableViewController.bgView.frame = CGRectMake(0, 0, self.calendarManagementTableViewController.bgView.frame.size.width, 0);
    }
    
    if (self.calendarManagementTableViewController.view.frame.size.height == 0)
    {
        [self.calendarManagementTableViewController reload];
        float height = self.view.frame.size.height * .8;
        
        float numHeight = ([[[EventKitManager sharedManager] getEKCalendars:NO] count] + 1) * 44;
        
        if (numHeight < height)
            height = numHeight;
        
        height = self.view.frame.size.height;
        
        
        [self.calendarManagementTableViewController reload];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:theTransitionTime];
        self.calendarManagementTableViewController.view.frame = CGRectMake(0, 0, 280, self.view.frame.size.height);
        self.calendarManagementTableViewController.theTableView.frame = CGRectMake(0, 0, self.calendarManagementTableViewController.theTableView.frame.size.width, self.calendarManagementTableViewController.view.frame.size.height);
        self.calendarManagementTableViewController.bgView.frame = CGRectMake(0, 0, self.calendarManagementTableViewController.bgView.frame.size.width, self.calendarManagementTableViewController.view.frame.size.height);
        [UIView commitAnimations];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:theTransitionTime];
        self.calendarManagementTableViewController.view.frame = CGRectMake(0, 0, 280, 0);
        self.calendarManagementTableViewController.theTableView.frame = CGRectMake(0, 0, self.calendarManagementTableViewController.theTableView.frame.size.width, 0);
        self.calendarManagementTableViewController.bgView.frame = CGRectMake(0, 0, self.calendarManagementTableViewController.bgView.frame.size.width, 0);
        [UIView commitAnimations];
    }
    
}

 */





@end
