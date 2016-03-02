//
//  AppSettingsViewController.h
//  Calendar
//
//  Created by Alchemy50 on 6/11/14.
//
//

#import <UIKit/UIKit.h>

@class AppViewController;
@class EKCalendar;
@interface AppSettingsViewController : UIViewController

-(IBAction)switchValueChanged:(UISwitch *)theSwitch;
-(IBAction)defaultCalendarButtonHit;
-(IBAction)themeColorButtonHit;
-(void)defaultCalendarSelected:(EKCalendar *)theSelectedCalendar;


@property (nonatomic, retain) IBOutlet UISwitch *twelveTwentyfourSwitch;
@property (nonatomic, retain) IBOutlet UISwitch *mondaySwitch;
@property (nonatomic, retain) IBOutlet UISwitch *celciusSwitch;
@property (nonatomic, retain) IBOutlet UILabel *defaultCalendarLabel;
@property (nonatomic, retain) IBOutlet UILabel *defaultCalendarKeyLabel;


@property (nonatomic, retain) IBOutlet UILabel *twentryFourLabel;
@property (nonatomic, retain) IBOutlet UILabel *startMondaysLabel;
@property (nonatomic, retain) IBOutlet UILabel *celciusLabel;
@property (nonatomic, retain) IBOutlet UILabel *themeColorLabel;




@end
