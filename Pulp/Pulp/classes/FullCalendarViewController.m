//
//  FullCalendarViewController.m
//  Calendar
//
//  Created by Alchemy50 on 5/27/14.
//
//

#import "FullCalendarViewController.h"
#import "GroupDataManager.h"
#import "AppDelegate.h"
#import "Defs.h"
#import "ThemeManager.h"
#import "AllCalendarButtonView.h"
#import "CalendarManagementViewController.h"
#import "Utils.h"


@interface FullCalendarViewController ()

@property (nonatomic, retain) UILabel *calendarsLabel;
@end

@implementation FullCalendarViewController

@synthesize contentContainerViewController;
@synthesize zoomingImageView;

float theTransitionTime = .22;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



-(void)doLoadViews
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
        [self setNeedsStatusBarAppearanceUpdate];
    
    [[ThemeManager sharedThemeManager] registerPrimaryObject:self];
    [[ThemeManager sharedThemeManager] registerAdvisoryObject:self];
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 25, self.view.frame.size.height)];
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
    [self.view addSubview:coverView];



    self.contentContainerViewController = [[ContentContainerViewController alloc] initWithNibName:nil bundle:nil];
    self.contentContainerViewController.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentContainerViewController.view];
    self.contentContainerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.contentContainerViewController doLoadViews];

    
    UIView *sharedButtonView = [AllCalendarButtonView sharedButtonView];
    [self.view addSubview:sharedButtonView];
    
    UIButton *calButton = [UIButton buttonWithType:UIButtonTypeCustom];
    calButton.backgroundColor = [UIColor clearColor];
    [calButton addTarget:self action:@selector(calButtonHit) forControlEvents:UIControlEventTouchUpInside];
    calButton.frame = CGRectMake(sharedButtonView.frame.origin.x, 0, sharedButtonView.frame.size.width, sharedButtonView.frame.origin.y + sharedButtonView.frame.size.height + 5);
    [self.view addSubview:calButton];
    
}

-(void)calButtonHit
{
    [[CalendarManagementViewController sharedCalendarManagementViewController] handleDisplay:YES];
}


-(void)adviseThemeUpdateWithPrimaryColor:(UIColor *)thePrimaryColor withSecondaryColor:(UIColor *)theSecondaryColor
{
}



-(void) dataChanged
{
    [[GroupDataManager sharedManager] loadCache];
    [self.contentContainerViewController calendarDataChanged];
}








@end
