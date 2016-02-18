//
//  EditCalendarManagementViewController.m
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "EditCalendarManagementViewController.h"
#import "ThemeManager.h"


@interface EditCalendarManagementViewController ()

@end

@implementation EditCalendarManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[ThemeManager sharedThemeManager] registerPrimaryObject:self];
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 25, self.view.frame.size.height)];
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
    [self.view addSubview:coverView];
    
    
    
    self.cancelLabel.backgroundColor = [UIColor clearColor];
    self.cancelLabel.text = @"CANCEL";
    self.cancelLabel.textAlignment = NSTextAlignmentLeft;
    self.cancelLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12.0f];
    [self.view addSubview:self.cancelLabel];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.cancelLabel];
    
    

    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.text = @"Edit Calendar";
    self.titleLabel.font = [UIFont fontWithName:@"Lato-Semibold" size:14];
    self.titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:self.titleLabel];
    
    
    
    self.doneLabel.backgroundColor = [UIColor clearColor];
    self.doneLabel.text = @"DONE";
    self.doneLabel.textAlignment = NSTextAlignmentLeft;
    self.doneLabel.font = self.cancelLabel.font;
    [self.view addSubview:self.doneLabel];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.doneLabel];
    
    
    
    
    
    self.nameLabel.backgroundColor = [UIColor clearColor];
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    self.nameLabel.text = @"NAME";
    self.nameLabel.font = [UIFont fontWithName:@"Lato-Bold" size:11.0f];
    [self.view addSubview:self.nameLabel];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.nameLabel];
    

    self.nameEntryBackgroundView.layer.cornerRadius = 5.f;
    self.nameEntryBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
    [self.view addSubview:self.nameEntryBackgroundView];
    
    
    self.nameEntryTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, self.nameEntryBackgroundView.frame.size.height / 2 - 15 / 2, self.nameEntryBackgroundView.frame.size.width - 2 * self.nameLabel.frame.origin.x, 15)];
    self.nameEntryTextField.delegate = self;
    self.nameEntryTextField.backgroundColor = [UIColor clearColor];
    self.nameEntryTextField.textColor = [UIColor whiteColor];
    self.nameEntryTextField.font = [UIFont fontWithName:@"Lato-Semibold" size:14.0f];
    [self.nameEntryTextField setReturnKeyType:UIReturnKeyDone];
    [self.nameEntryBackgroundView addSubview:self.nameEntryTextField];

    
    
}



-(void)loadWithCalendar:(EKCalendar *)theCalendar
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    self.nameEntryTextField.text = theCalendar.title;
}

-(void)cancelButtonHit
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(void)doneButtonHit
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}



@end
