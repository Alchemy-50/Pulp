//
//  EditCalendarManagementViewController.m
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "EditCalendarManagementViewController.h"
#import "ThemeManager.h"
#import "CalendarManagementViewController.h"
#import "ColorPickerViewController.h"
#import "Utils.h"
#import "EventKitManager.h"
#import "CalendarManagementTableViewController.h"


@interface EditCalendarManagementViewController ()
@property (nonatomic,retain) EKCalendar *referenceCalendar;
@end

@implementation EditCalendarManagementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[ThemeManager sharedThemeManager] registerPrimaryObject:self];
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 25, self.view.frame.size.height)];
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
    [self.view insertSubview:coverView atIndex:0];
    
    
    
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

    
    self.shareWithLabel.backgroundColor = [UIColor clearColor];
    self.shareWithLabel.textAlignment = NSTextAlignmentLeft;
    self.shareWithLabel.text = @"SHARE WITH";
    self.shareWithLabel.font = [UIFont fontWithName:@"Lato-Bold" size:11.0f];
    [self.view addSubview:self.shareWithLabel];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.shareWithLabel];
    
    
    self.shareWithBackroundView.layer.cornerRadius = 5.f;
    self.shareWithBackroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
    [self.view addSubview:self.shareWithBackroundView];
    
    
    self.shareWithEntryLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.frame.origin.x, self.nameEntryBackgroundView.frame.size.height / 2 - 15 / 2, self.nameEntryBackgroundView.frame.size.width - 2 * self.nameLabel.frame.origin.x, 15)];
    self.nameEntryTextField.backgroundColor = [UIColor clearColor];
    self.shareWithEntryLabel.textColor = [UIColor lightGrayColor];
    self.shareWithEntryLabel.font = [UIFont fontWithName:@"Lato-Semibold" size:14.0f];
    self.shareWithEntryLabel.text = @"Add Person...";
    [self.shareWithBackroundView addSubview:self.shareWithEntryLabel];

    
    
    self.colorLabel.backgroundColor = [UIColor clearColor];
    self.colorLabel.textAlignment = NSTextAlignmentLeft;
    self.colorLabel.text = @"COLOR:";
    self.colorLabel.font = [UIFont fontWithName:@"Lato-Bold" size:11.0f];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.colorLabel];
    
    
    self.calendarDisplayColorLabel.backgroundColor = [UIColor clearColor];
    self.calendarDisplayColorLabel.textColor = [UIColor whiteColor];
    self.calendarDisplayColorLabel.textAlignment = NSTextAlignmentLeft;
    self.calendarDisplayColorLabel.text = @"Calendar Display Color:";
    self.calendarDisplayColorLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0f];


    self.notificationsLabel.backgroundColor = [UIColor clearColor];
    self.notificationsLabel.textAlignment = NSTextAlignmentLeft;
    self.notificationsLabel.text = @"NOTIFICATIONS:";
    self.notificationsLabel.font = [UIFont fontWithName:@"Lato-Bold" size:11.0f];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.notificationsLabel];


    self.eventsAlertsLabelOne.backgroundColor = [UIColor clearColor];
    self.eventsAlertsLabelOne.textColor = [UIColor whiteColor];
    self.eventsAlertsLabelOne.textAlignment = NSTextAlignmentLeft;
    self.eventsAlertsLabelOne.text = @"Event Alerts";
    self.eventsAlertsLabelOne.font = [UIFont fontWithName:@"Lato-Semibold" size:14.0f];

    
    self.eventsAlertsLabelTwo.backgroundColor = [UIColor clearColor];
    self.eventsAlertsLabelTwo.textColor = [UIColor colorWithRed:196.0f/255.0f green:196.0f/255.0f blue:196.0f/255.0f alpha:1];
    self.eventsAlertsLabelTwo.textAlignment = NSTextAlignmentLeft;
    self.eventsAlertsLabelTwo.text = @"Allow events on this calendar to display alerts";
    self.eventsAlertsLabelTwo.font = [UIFont fontWithName:@"Lato-Regular" size:11.0f];

    


    
    
    
    self.publicLabel.backgroundColor = [UIColor clearColor];
    self.publicLabel.textAlignment = NSTextAlignmentLeft;
    self.publicLabel.text = @"PUBLIC:";
    self.publicLabel.font = [UIFont fontWithName:@"Lato-Bold" size:11.0f];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.publicLabel];
    
    
    self.publicSublabelOne.backgroundColor = [UIColor clearColor];
    self.publicSublabelOne.textColor = [UIColor whiteColor];
    self.publicSublabelOne.textAlignment = NSTextAlignmentLeft;
    self.publicSublabelOne.text = @"Make my Calendar Public";
    self.publicSublabelOne.font = [UIFont fontWithName:@"Lato-Semibold" size:14.0f];
    
    
    self.publicSublabelTwo.backgroundColor = [UIColor clearColor];
    self.publicSublabelTwo.textColor = [UIColor colorWithRed:196.0f/255.0f green:196.0f/255.0f blue:196.0f/255.0f alpha:1];
    self.publicSublabelTwo.textAlignment = NSTextAlignmentLeft;
    self.publicSublabelTwo.text = @"Allow anyone to subscribe to a read-only version";
    self.publicSublabelTwo.font = [UIFont fontWithName:@"Lato-Regular" size:11.0f];
    
    
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.publicSwitch];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.notificationsSwitch];
    
  
    
    //    @property (nonatomic, retain) IBOutlet UISwitch *publicSwitch;
    
    self.strikeLineOne.backgroundColor = [UIColor colorWithWhite:1 alpha:.15];
    self.strikeLineTwo.backgroundColor = self.strikeLineOne.backgroundColor;
    self.strikeLineThree.backgroundColor = self.strikeLineOne.backgroundColor;
    self.strikeLineFour.backgroundColor = self.strikeLineOne.backgroundColor;
    self.strikeLineFive.backgroundColor = self.strikeLineOne.backgroundColor;
    self.strikeLineSix.backgroundColor = self.strikeLineOne.backgroundColor;
    

    UIButton *colorPickerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    colorPickerButton.frame = self.displayColorView.frame;
    [colorPickerButton addTarget:self action:@selector(colorPickerButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:colorPickerButton];

    
    self.deleteCalendarBackgroundView.backgroundColor = [UIColor colorWithRed:190.0f/255.0f green:9.0f/255.0f blue:31.0f/255.0f alpha:1];
    
    
    self.deleteCalendarLabel = [[UILabel alloc] initWithFrame:self.deleteCalendarBackgroundView.frame];
    self.deleteCalendarLabel.backgroundColor = [UIColor clearColor];
    self.deleteCalendarLabel.textAlignment = NSTextAlignmentCenter;
    self.deleteCalendarLabel.text = @"Delete Calendar";
    self.deleteCalendarLabel.textColor = [UIColor whiteColor];
    self.deleteCalendarLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14.0f];
    [self.view addSubview:self.deleteCalendarLabel];
    
    
    self.deleteCalendarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.deleteCalendarButton.frame = self.deleteCalendarLabel.frame;
    self.deleteCalendarButton.backgroundColor = [UIColor clearColor];
    [self.deleteCalendarButton addTarget:self action:@selector(deleteCalendarButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.deleteCalendarButton];
    
}


-(void)deleteCalendarButtonHit
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Delete?"
                                  message:[NSString stringWithFormat:@"Are you sure you want to delete %@", self.referenceCalendar.title]
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:nil];
    
    
    
    UIAlertAction* yes = [UIAlertAction
                         actionWithTitle:@"YES"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             //Do some thing here
                             [self dismissViewControllerAnimated:YES completion:^(void) {
                                 
                                 [[EventKitManager sharedManager] deleteCalendar:self.referenceCalendar];
                                 [self.theParentController calendarContentChanged];
                                 
                                 
                                 }];                             
                         }];
    [alert addAction:yes];
  
    UIAlertAction* no = [UIAlertAction
                          actionWithTitle:@"NO"
                          style:UIAlertActionStyleDefault
                          handler:^(UIAlertAction * action)
                          {
                              //Do some thing here
                              [self dismissViewControllerAnimated:YES completion:nil];
                              
                          }];
    [alert addAction:no];
    
    
}

-(void)loadWithCalendar:(EKCalendar *)theCalendar
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    self.referenceCalendar = theCalendar;
    
    self.nameEntryTextField.text = theCalendar.title;
    self.displayColorView.backgroundColor = [UIColor colorWithCGColor:theCalendar.CGColor];
}


-(void)colorPickerButtonHit
{
    ColorPickerViewController *vc = [[ColorPickerViewController alloc] initWithNibName:nil bundle:nil];
    vc.theParentController = self;
    vc.view.frame = CGRectMake(0, 0, [Utils getScreenWidth], [Utils getScreenHeight]);
    [self presentViewController:vc animated:YES completion:nil];
    
    [vc loadWithColor:self.displayColorView.backgroundColor];
}

-(void)colorPickerSelectedWithColor:(UIColor *)theColor
{
    [self dismissViewControllerAnimated:YES completion:nil];
    self.displayColorView.backgroundColor = theColor;
}



-(IBAction)cancelButtonHit
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[CalendarManagementViewController sharedCalendarManagementViewController] dismissViewControllerAnimated:YES completion:nil];
}

-(void)doneButtonHit
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[CalendarManagementViewController sharedCalendarManagementViewController] dismissViewControllerAnimated:YES completion:nil];
    
    self.referenceCalendar.title = self.nameEntryTextField.text;
    self.referenceCalendar.CGColor = self.displayColorView.backgroundColor.CGColor;
    [[EventKitManager sharedManager] saveCalendar:self.referenceCalendar];
    
    [self.theParentController calendarContentChanged];
}



@end
