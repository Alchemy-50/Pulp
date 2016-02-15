//
//  FullCalendarViewController.m
//  Calendar
//
//  Created by Alchemy50 on 5/27/14.
//
//

#import "FullCalendarViewController.h"
#import "GroupDataManager.h"
#import "EventManagerViewController.h"
#import "AppDelegate.h"
#import "Defs.h"
#import "ThemeManager.h"


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
    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 25, self.view.frame.size.height)];
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
    [self.view addSubview:coverView];


    float footerHeight = 40;
    
    self.contentContainerViewController = [[ContentContainerViewController alloc] initWithNibName:nil bundle:nil];
    self.contentContainerViewController.view.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.contentContainerViewController.view];
    self.contentContainerViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - footerHeight);
    [self.contentContainerViewController doLoadViews];
    
    [self.contentContainerViewController calendarDataChanged];
 
    float inset = self.view.frame.size.width * .08;
    
    
    UIView *calLabelBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(inset, self.contentContainerViewController.view.frame.size.height, self.view.frame.size.width - 2 * inset, footerHeight * .9)];
    [[ThemeManager sharedThemeManager] registerPrimaryObject:calLabelBackgroundView];
    [self.view addSubview:calLabelBackgroundView];
    
    coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, calLabelBackgroundView.frame.size.width, calLabelBackgroundView.frame.size.height)];
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:.75];
    [calLabelBackgroundView addSubview:coverView];
    
    UIButton *calButton = [UIButton buttonWithType:UIButtonTypeCustom];
    calButton.backgroundColor = [UIColor clearColor];
    [calButton addTarget:self action:@selector(calButtonHit) forControlEvents:UIControlEventTouchUpInside];
    calButton.frame = CGRectMake(0, 0, calLabelBackgroundView.frame.size.width, calLabelBackgroundView.frame.size.height);
    [calLabelBackgroundView addSubview:calButton];
    
    
    self.calendarsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, calLabelBackgroundView.frame.size.width, calLabelBackgroundView.frame.size.height)];
    self.calendarsLabel.backgroundColor = [UIColor clearColor];
    self.calendarsLabel.textAlignment = NSTextAlignmentCenter;
    self.calendarsLabel.font = [UIFont fontWithName:@"Lato-Regular" size:self.calendarsLabel.frame.size.height / 2];
    self.calendarsLabel.text = @"All Calendars";
    [calLabelBackgroundView addSubview:self.calendarsLabel];
    
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.calendarsLabel];
}



-(void) dataChanged
{
//    [self.calendarHeaderView loadTitleLabel];
    [[GroupDataManager sharedManager] loadCache];
    [self.contentContainerViewController calendarDataChanged];
}




-(void)createEventExitButtonHitWithController:(EventManagerViewController *)theController withEvent:(EKEvent *)theEvent withAction:(EKEventEditViewAction)theAction
{

    if (theAction == EKEventEditViewActionSaved)
        if (theEvent != nil)
            if (theEvent.title != nil)
                [self.contentContainerViewController spoofCalendarDayViewWithEvent:theEvent withAction:theAction];
    
    if ([[theController.view superview] isKindOfClass:[UIWindow class]])
    {    
        [[MainViewController sharedMainViewController] dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    
    
    UIView *spoofView = [[UIView alloc] initWithFrame:theController.view.frame];
    spoofView.backgroundColor = theController.view.backgroundColor;
    [self.parentViewController.view addSubview:spoofView];
    
    
    [theController.view removeFromSuperview];
    
    [UIView beginAnimations:@"asdf" context:spoofView];
    [UIView setAnimationDuration:theTransitionTime];
    [UIView setAnimationDelegate:self];
    spoofView.frame = theController.startEndRect;
    [UIView setAnimationDidStopSelector:@selector(createEventViewDidFinish:finished:context:)];
    [UIView commitAnimations];
    
    
    
    CGAffineTransform tr = CGAffineTransformIdentity;
    [UIView animateWithDuration:theTransitionTime delay:0 options:0 animations:^{
        self.zoomingImageView.transform = tr;
        self.zoomingImageView.frame = CGRectMake(0,0,self.view.frame.size.width, self.view.frame.size.height);
        //        self.zoomingIheImageView.center = CGPointMake(self.view.frame.size.width, 0);
    } completion:^(BOOL finished) { [self.zoomingImageView removeFromSuperview];}];
    
    
}

-(void)createEventViewDidFinish:(id)object finished:(id)finished context:(UIView *)context
{
    [context removeFromSuperview];
}

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








@end
