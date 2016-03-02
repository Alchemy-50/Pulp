//
//  AppSettingsViewController.m
//  Calendar
//
//  Created by Alchemy50 on 6/11/14.
//
//

#import "AppSettingsViewController.h"
#import "SettingsManager.h"
#import "DefaultCalendarSelectTableViewController.h"

#import "AppDelegate.h"
#import "ThemeSelectViewController.h"
#import "ThemeManager.h"
@interface AppSettingsViewController ()

@end

@implementation AppSettingsViewController


@synthesize twelveTwentyfourSwitch;
@synthesize mondaySwitch;
@synthesize celciusSwitch;
@synthesize defaultCalendarLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[ThemeManager sharedThemeManager] registerPrimaryObject:self];
    
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 65, self.view.frame.size.height * 2)];
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
    [self.view insertSubview:coverView atIndex:0];
    
    
    // Do any additional setup after loading the view from its nib.
    
    self.twelveTwentyfourSwitch.on = [[SettingsManager getSharedSettingsManager] startTimeInTwentyFour];
    self.mondaySwitch.on = [[SettingsManager getSharedSettingsManager] startWithMonday];
    self.celciusSwitch.on = [[SettingsManager getSharedSettingsManager] tempInCelcius];

    NSString *defaultCalendarID = [[SettingsManager getSharedSettingsManager] getDefaultCalendarID];
    if (defaultCalendarID == nil)
        self.defaultCalendarLabel.text = @"None";
    else
    {
        EKCalendar *theCalendar = [[EventKitManager sharedManager] getEKCalendarWithIdentifier:defaultCalendarID];
        self.defaultCalendarLabel.text = theCalendar.title;
    }
    

    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:[MainViewController sharedMainViewController]  action:@selector(dismissSettingsViewController)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];
    
    UIColor *labelColor = [UIColor whiteColor];
    
    self.twentryFourLabel.textColor = labelColor;
    self.startMondaysLabel.textColor = labelColor;
    self.celciusLabel.textColor = labelColor;
    self.themeColorLabel.textColor = labelColor;
    self.defaultCalendarLabel.textColor = labelColor;
    self.defaultCalendarKeyLabel.textColor = labelColor;
    
    //self.navigationController.navigationBarHidden = YES;
    
    
    
}




-(IBAction)switchValueChanged:(UISwitch *)theSwitch
{
    if (theSwitch == self.twelveTwentyfourSwitch)
    {
        [[SettingsManager getSharedSettingsManager] setTimeInTwentyFour:self.twelveTwentyfourSwitch.on];
        
        AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        [appDelegate runBackgroundTasks];
    }
    else if (theSwitch == self.mondaySwitch)
        [[SettingsManager getSharedSettingsManager] setStartWithMonday:self.mondaySwitch.on];
    else if (theSwitch == self.celciusSwitch)
        [[SettingsManager getSharedSettingsManager] setTempInCelcius:self.celciusSwitch.on];
    
}

-(IBAction)defaultCalendarButtonHit
{
    DefaultCalendarSelectTableViewController *defaultCalendarSelectTableViewController = [[DefaultCalendarSelectTableViewController alloc] initWithNibName:nil bundle:nil];
    defaultCalendarSelectTableViewController.parentAppSettingsViewController = self;

    [self.navigationController pushViewController:defaultCalendarSelectTableViewController animated:YES];
}


-(void)defaultCalendarSelected:(EKCalendar *)theSelectedCalendar
{
    [[SettingsManager getSharedSettingsManager] setDefaultCalendarID:theSelectedCalendar.calendarIdentifier];
    
    NSLog(@"??[[SettingsManager getSharedSettingsManager] getDefaultCalendarID];: %@", [[SettingsManager getSharedSettingsManager] getDefaultCalendarID]);
    self.defaultCalendarLabel.text = theSelectedCalendar.title;
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)themeColorButtonHit
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"self.navigatonController: %@", self.navigationController);
    
    ThemeSelectViewController *themeSelectViewController = [[ThemeSelectViewController alloc] initWithNibName:@"ThemeSelectViewController" bundle:nil];
    [self.navigationController pushViewController:themeSelectViewController animated:YES];
    
}

@end
