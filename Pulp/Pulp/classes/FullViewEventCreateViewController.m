//
//  FullViewEventCreateViewController.m
//  Calendar
//
//  Created by Josh Klobe on 6/5/14.
//
//

#import "FullViewEventCreateViewController.h"
#import "FullCalendarViewController.h"


@interface FullViewEventCreateViewController ()

@end

@implementation FullViewEventCreateViewController

@synthesize theParentViewController;
@synthesize containerScrollView;
@synthesize exitButton;
@synthesize eventCalendarSelectViewController;
@synthesize eventTaskSelectViewController;
@synthesize referenceCalendarDayView;

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
    
    
    self.containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.containerScrollView.backgroundColor = [UIColor clearColor];
    self.containerScrollView.delegate = self;
    [self.view addSubview:self.containerScrollView];
    
    self.exitButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    self.exitButton.backgroundColor = [UIColor clearColor];
    [self.exitButton addTarget:self action:@selector(exitButtonHit) forControlEvents:UIControlEventTouchUpInside];
    self.exitButton.frame = CGRectMake(0, 0, self.view.frame.size.width * 2, self.view.frame.size.height);
    [self.containerScrollView addSubview:self.exitButton];
    self.exitButton.alpha = .4;
    
}

-(void)exitButtonHit
{
    NSLog(@"IMPLEMENT HERE exitButtonHit");
//    [self.theParentViewController runAddEventShouldDismiss:YES];
}
-(void)present
{

    if (self.eventCalendarSelectViewController != nil)
    {
        [self.eventCalendarSelectViewController.view removeFromSuperview];
        [self.eventCalendarSelectViewController release];
        self.eventCalendarSelectViewController = nil;
    }
    
    
    self.eventCalendarSelectViewController = [[EventCalendarSelectViewController alloc] initWithNibName:nil bundle:nil];
    self.eventCalendarSelectViewController.parentFullViewEventCreateViewController = self;
    self.eventCalendarSelectViewController.view.backgroundColor = [UIColor clearColor];
    self.eventCalendarSelectViewController.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.containerScrollView addSubview:self.eventCalendarSelectViewController.view];
    [self.eventCalendarSelectViewController loadTheViews];
    
}

-(void)presentEventtaskSelectViewControllerWithSelectedCalendar:(EKCalendar *)theSelectedCalendar
{
    /*
     UIButton *calendarSelectCoverExitButton = [UIButton buttonWithType:UIButtonTypeCustom];
     calendarSelectCoverExitButton.backgroundColor = [UIColor clearColor];
     [calendarSelectCoverExitButton addTarget:self action:@selector(calendarSelectCoverExitButtonHit:) forControlEvents:UIControlEventTouchUpInside];
     calendarSelectCoverExitButton.frame = CGRectMake(0, 0, self.eventCalendarSelectViewController.view.frame.size.width, self.eventCalendarSelectViewController.view.frame.size.height);
     [self.eventCalendarSelectViewController.view addSubview:calendarSelectCoverExitButton];
     */
    
    NSLog(@"presentEventtaskSelectViewControllerWithSelectedCalendar");
    
    self.eventTaskSelectViewController = [[EventTaskSelectViewController alloc] initWithNibName:nil bundle:nil];
    self.eventTaskSelectViewController.parentFullViewEventCreateViewController = self;
    self.eventTaskSelectViewController.view.backgroundColor = [UIColor clearColor];
    self.eventTaskSelectViewController.view.frame = CGRectMake(self.eventCalendarSelectViewController.view.frame.origin.x + self.eventCalendarSelectViewController.view.frame.size.width + 5, 0, self.eventCalendarSelectViewController.view.frame.size.width, self.eventCalendarSelectViewController.view.frame.size.height);
    [self.containerScrollView addSubview:self.eventTaskSelectViewController.view];
    [self.eventTaskSelectViewController loadTheViewsWithCalendar:theSelectedCalendar];
    self.eventTaskSelectViewController.view.alpha = 0;
    
    self.containerScrollView.scrollEnabled = YES;
    self.containerScrollView.contentSize = CGSizeMake(400, 0);
    
    if (self.containerScrollView.contentOffset.x == 80)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:FullViewEventCreateViewControllerTransitionTime];
        self.eventTaskSelectViewController.view.alpha = 1;
        [UIView commitAnimations];
    }
    else
        [self.containerScrollView setContentOffset:CGPointMake(170, 0) animated:YES];
}


- (void)eventTaskSelectViewControllerDidHide:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {

    NSLog(@"eventTaskSelectViewControllerDidHide");
    [self.eventTaskSelectViewController.view removeFromSuperview];
    [self.eventTaskSelectViewController release];
    self.eventTaskSelectViewController = nil;
    
    [self presentEventtaskSelectViewControllerWithSelectedCalendar:(EKCalendar *)context];
    
}


-(void)calendarSelected:(EKCalendar *)selectedCalendar
{
    NSLog(@"calendarSelected");
    [self.eventCalendarSelectViewController hideCalendarLabels];
 
    if (self.eventTaskSelectViewController != nil)
    {
        [UIView beginAnimations:nil context:selectedCalendar];
        [UIView setAnimationDuration:.22];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(eventTaskSelectViewControllerDidHide:finished:context:)];
        self.eventTaskSelectViewController.view.alpha = 0;
        [UIView commitAnimations];
                
    }
    else
        [self presentEventtaskSelectViewControllerWithSelectedCalendar:selectedCalendar];
    
//    [self.eventCalendarSelectViewController
}

-(void)calendarSelectCoverExitButtonHit:(UIButton *)theButton
{
    [theButton removeFromSuperview];
    
    
    NSLog(@"calendarSelectCoverExitButtonHit");
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:FullViewEventCreateViewControllerTransitionTime];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(eventTaskDidHide)];
    self.eventTaskSelectViewController.view.alpha = 0;
    [UIView commitAnimations];
}

-(void)eventTaskDidHide
{
    [self.containerScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    self.containerScrollView.scrollEnabled = NO;
 
    if (scrollView.contentOffset.x > 0)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:FullViewEventCreateViewControllerTransitionTime];
        self.eventTaskSelectViewController.view.alpha = 1;
        [UIView commitAnimations];
    }
    
}

-(void)commonTaskSelected:(CommonEventContainer *)selectedCommonEventContainer
{
    NSLog(@"commonTaskSelected commonTaskSelected commonTaskSelected commonTaskSelected commonTaskSelected");
    NSDate *theDate = self.referenceDate;
    if (self.referenceCalendarDayView != nil)
        theDate = self.referenceCalendarDayView.theDate;
    
//    [[FlowControlHandler sharedFlowControlHandler] runAddEventDidSelectCommonEvent:selectedCommonEventContainer withCalendarDayDate:theDate];
}

@end
