//
//  EditCalendarManagementViewController.h
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface EditCalendarManagementViewController : UIViewController


@property (nonatomic, retain) id theParentController;
-(IBAction)cancelButtonHit;
-(IBAction)doneButtonHit;
-(void)loadWithCalendar:(EKCalendar *)theCalendar;
-(void)colorPickerSelectedWithColor:(UIColor *)theColor;

@property (nonatomic, retain) IBOutlet UILabel *cancelLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *doneLabel;


@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIView *nameEntryBackgroundView;
@property (nonatomic, retain) UITextField *nameEntryTextField;


@property (nonatomic, retain) IBOutlet UILabel *shareWithLabel;
@property (nonatomic, retain) IBOutlet UIView *shareWithBackroundView;
@property (nonatomic, retain) UILabel *shareWithEntryLabel;

@property (nonatomic, retain) IBOutlet UILabel *colorLabel;
@property (nonatomic, retain) IBOutlet UILabel *calendarDisplayColorLabel;
@property (nonatomic, retain) IBOutlet UIView *displayColorView;

@property (nonatomic, retain) IBOutlet UILabel *notificationsLabel;
@property (nonatomic, retain) IBOutlet UILabel *eventsAlertsLabelOne;
@property (nonatomic, retain) IBOutlet UILabel *eventsAlertsLabelTwo;
@property (nonatomic, retain) IBOutlet UISwitch *notificationsSwitch;


@property (nonatomic, retain) IBOutlet UILabel *publicLabel;
@property (nonatomic, retain) IBOutlet UILabel *publicSublabelOne;
@property (nonatomic, retain) IBOutlet UILabel *publicSublabelTwo;
@property (nonatomic, retain) IBOutlet UISwitch *publicSwitch;

@property (nonatomic, retain) IBOutlet UIView *deleteCalendarBackgroundView;
@property (nonatomic, retain) UILabel *deleteCalendarLabel;
@property (nonatomic, retain) UIButton *deleteCalendarButton;


@property (nonatomic, retain) IBOutlet UIView *strikeLineOne;
@property (nonatomic, retain) IBOutlet UIView *strikeLineTwo;
@property (nonatomic, retain) IBOutlet UIView *strikeLineThree;
@property (nonatomic, retain) IBOutlet UIView *strikeLineFour;
@property (nonatomic, retain) IBOutlet UIView *strikeLineFive;
@property (nonatomic, retain) IBOutlet UIView *strikeLineSix;




@end
