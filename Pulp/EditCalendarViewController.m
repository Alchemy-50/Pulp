//
//  EditCalendarViewController.m
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "EditCalendarViewController.h"
#import "ThemeManager.h"

@interface EditCalendarViewController ()

@end

@implementation EditCalendarViewController

- (void)initialize
{
    [[ThemeManager sharedThemeManager] registerPrimaryObject:self];
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 25, self.view.frame.size.height)];
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
    [self.view addSubview:coverView];
    
    
    UILabel *cancelLabel = [[UILabel alloc] initWithFrame:CGRectMake(14, 17, 60, 15)];
    cancelLabel.backgroundColor = [UIColor clearColor];
    cancelLabel.text = @"CANCEL";
    cancelLabel.textAlignment = NSTextAlignmentLeft;
    cancelLabel.font = [UIFont fontWithName:@"Lato-Bold" size:12.0f];
    [self.view addSubview:cancelLabel];
    
    
    float titleWidth = 120;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2 - titleWidth / 2, cancelLabel.frame.origin.y, titleWidth, cancelLabel.frame.size.height)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.text = @"Edit Calendar";
    titleLabel.font = [UIFont fontWithName:@"Lato-Semibold" size:14];
    titleLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:titleLabel];

    
    UILabel *doneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width * (318.0f / 375.0f), cancelLabel.frame.origin.y, cancelLabel.frame.size.width, cancelLabel.frame.size.height)];
    doneLabel.backgroundColor = [UIColor clearColor];
    doneLabel.text = @"DONE";
    doneLabel.textAlignment = NSTextAlignmentLeft;
    doneLabel.font = cancelLabel.font;
    [self.view addSubview:doneLabel];
    
    [[ThemeManager sharedThemeManager] registerSecondaryObject:cancelLabel];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:doneLabel];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.backgroundColor = [UIColor clearColor];
    cancelButton.frame = CGRectMake(0, 0, cancelLabel.frame.size.width + cancelLabel.frame.origin.x, cancelLabel.frame.origin.y + cancelLabel.frame.size.height + 10);
    [cancelButton addTarget:self action:@selector(cancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelButton];
    
    
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    doneButton.backgroundColor = [UIColor clearColor];
    doneButton.frame = CGRectMake(doneLabel.frame.origin.x, 0, cancelLabel.frame.size.width + cancelLabel.frame.origin.x, cancelLabel.frame.origin.y + cancelLabel.frame.size.height + 10);
    [doneButton addTarget:self action:@selector(doneButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doneButton];
    
    
    // Do any additional setup after loading the view.
}

-(void)loadWithCalendar:(EKCalendar *)theCalendar
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
