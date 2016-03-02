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
    
    NSString *defaultCalendarID = [[SettingsManager getSharedSettingsManager] getDefaultCalendarID];
    if (defaultCalendarID == nil)
        self.defaultCalendarLabel.text = @"None";
    else
    {
        CalendarRepresentation *theCalendar = [[EventKitManager sharedManager] getEKCalendarWithIdentifier:defaultCalendarID];
        self.defaultCalendarLabel.text = [theCalendar getTitle];
    }
    

    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:[MainViewController sharedMainViewController]  action:@selector(dismissSettingsViewController)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    
    UIColor *labelColor = [UIColor whiteColor];
    
    self.twentryFourLabel.textColor = labelColor;
    self.startMondaysLabel.textColor = labelColor;
    self.celciusLabel.textColor = labelColor;
    self.themeColorLabel.textColor = labelColor;
    self.defaultCalendarLabel.textColor = labelColor;
    self.defaultCalendarKeyLabel.textColor = labelColor;
    
    //self.navigationController.navigationBarHidden = YES;
    
    
    
}


-(IBAction)defaultCalendarButtonHit
{
    DefaultCalendarSelectTableViewController *defaultCalendarSelectTableViewController = [[DefaultCalendarSelectTableViewController alloc] initWithNibName:nil bundle:nil];
    defaultCalendarSelectTableViewController.parentAppSettingsViewController = self;

    [self.navigationController pushViewController:defaultCalendarSelectTableViewController animated:YES];
}


-(void)defaultCalendarSelected:(CalendarRepresentation *)theSelectedCalendar
{
    [[SettingsManager getSharedSettingsManager] setDefaultCalendarID:[theSelectedCalendar getTheCalendarIdentifier]];
    
    NSLog(@"??[[SettingsManager getSharedSettingsManager] getDefaultCalendarID];: %@", [[SettingsManager getSharedSettingsManager] getDefaultCalendarID]);
    self.defaultCalendarLabel.text = [theSelectedCalendar getTitle];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)themeColorButtonHit
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"self.navigatonController: %@", self.navigationController);
    
    ThemeSelectViewController *themeSelectViewController = [[ThemeSelectViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:themeSelectViewController animated:YES];
    
}

@end
