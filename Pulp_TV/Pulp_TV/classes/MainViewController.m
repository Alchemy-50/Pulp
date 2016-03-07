//
//  MainViewController.m
//  Calendar
//
//  Created by Josh Klobe on 2/11/16.
//
//

#import "MainViewController.h"
#import "SidebarView.h"
#import "DailyViewController.h"
#import "FullCalendarViewController.h"
#import "Utils.h"
#import "CoverScrollView.h"
#import "AppSettingsViewController.h"
#import "ContainerTodosViewController.h"
#import "SidebarButtonView.h"
#import "CalendarManagementViewController.h"
#import "EventsDigester.h"
#import "AlarmNotificationHandler.h"
#import "SettingsManager.h"
#import "UpdatingCoverView.h"


@interface MainViewController ()
@property (nonatomic, retain) SidebarView *sidebarView;
@property (nonatomic, retain) FullCalendarViewController *fullCalendarViewController;
@property (nonatomic, retain) ContainerTodosViewController *containerTodosViewController;
@property (nonatomic, retain) CoverScrollView *coverScrollView;
@property (nonatomic, retain) DailyViewController *centerViewController;
@property (nonatomic, assign) BOOL initialized;
@property (nonatomic, assign) int theSecondaryState;

@property (nonatomic, retain) UpdatingCoverView *updatingCoverView;
@end


@implementation MainViewController

static MainViewController *staticVC;

+(MainViewController *)sharedMainViewController
{
    return staticVC;
}



- (void)viewDidLoad {
    
    staticVC = self;
    [super viewDidLoad];
    
    
    
    self.sidebarView = [[SidebarView alloc] initWithFrame:CGRectMake(0, 0, [Utils getSidebarWidth], self.view.frame.size.height)];
    [self.view addSubview:self.sidebarView];
    
    
    self.fullCalendarViewController = [[FullCalendarViewController alloc] initWithNibName:nil bundle:nil];
    [self.view addSubview:self.fullCalendarViewController.view];
    self.fullCalendarViewController.view.frame = CGRectMake([Utils getSidebarWidth], 0, [Utils getScreenWidth] - [Utils getSidebarWidth], [Utils getScreenHeight]);
    [self.fullCalendarViewController doLoadViews];
    
    
    self.containerTodosViewController = [[ContainerTodosViewController alloc] initWithNibName:nil bundle:nil];
    self.containerTodosViewController.view.frame = self.fullCalendarViewController.view.frame;
    
    
    
    
    
    self.coverScrollView = [[CoverScrollView alloc] initWithFrame:self.fullCalendarViewController.view.frame];
    self.coverScrollView.showsHorizontalScrollIndicator = NO;
    self.coverScrollView.delegate = self;
    self.coverScrollView.scrollEnabled = YES;
    self.coverScrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.coverScrollView];
    
    
    float width =  [Utils getScreenWidth] - self.sidebarView.frame.size.width;
    
    self.centerViewController = [[DailyViewController alloc] initWithNibName:nil bundle:nil];
    self.centerViewController.centerSidebarView = self.sidebarView;
    self.centerViewController.view.frame = CGRectMake(width, 0, width, self.view.frame.size.height);
    [self.coverScrollView addSubview:self.centerViewController.view];
    [self.centerViewController loadViews];
    
    self.coverScrollView.contentSize = CGSizeMake(self.centerViewController.view.frame.size.width * 2, 0);
    [self.coverScrollView setContentOffset:CGPointMake(self.centerViewController.view.frame.origin.x, 0) animated:NO];
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > self.centerViewController.view.frame.size.width)
        scrollView.contentOffset = CGPointMake(self.centerViewController.view.frame.origin.x, 0);
    
    if (scrollView.contentOffset.x == self.centerViewController.view.frame.origin.x)
    {
        [self.sidebarView updateButtonStateWithSelected:self.theSecondaryState withShowEnabled:NO];
    }
    else
    {
        [self.sidebarView updateButtonStateWithSelected:self.theSecondaryState withShowEnabled:YES];
    }
}

-(void)swipeGestureRecognizerTriggered
{
    [self resetCoverScrollToDate:nil];
}

-(void)resetCoverScrollToDate:(NSDate *)theDate
{
    if (theDate != nil)
        [self.centerViewController scrollToDate:theDate];
    
    [self.coverScrollView setContentOffset:CGPointMake(self.centerViewController.view.frame.origin.x, 0) animated:YES];
}




-(void)dataChanged
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    
    [self.fullCalendarViewController dataChanged];
    [self.centerViewController refreshContent];
    [self.containerTodosViewController.todosViewController reloadTodos];
    
    if (!self.initialized)
    {
        self.initialized = YES;
        //[self.centerViewController processPositioningWithScrollView:self.centerViewController.contentScrollView];
        [self.fullCalendarViewController navigateToToday];
        [EventsDigester run];
    }
    
    [self dismissUpdatingCoverView];
}




- (void) presentSettingsViewController
{
    AppSettingsViewController *appSettingsViewController = [[AppSettingsViewController alloc] initWithNibName:nil bundle:nil];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:appSettingsViewController] animated:YES completion:nil];
}

- (void) dismissSettingsViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self dataChanged];
    }];
}



- (void) dayViewTapped:(CalendarDayView *)tappedDay
{
    [self.fullCalendarViewController dayViewSelected:tappedDay];
}


-(void)dailyViewAddEventButtonHit:(NSDate *)referenceDate
{
/*
    ContainerEKEventEditViewController *containerEKEventEditViewController = [[ContainerEKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    containerEKEventEditViewController.containerParentController = self;
    [containerEKEventEditViewController loadForNewEventWithStartDate:referenceDate];
    containerEKEventEditViewController.view.frame = CGRectMake(0, 0, [Utils getScreenWidth], [Utils getScreenHeight]);
    [self presentViewController:containerEKEventEditViewController animated:YES completion:nil];
*/
}



-(void)dailyEventSelected:(CalendarEvent *)theEvent
{
    /*
    if (theEvent != nil)
    {
        ContainerEKEventEditViewController *containerEKEventEditViewController = [[ContainerEKEventEditViewController alloc] initWithNibName:nil bundle:nil];
        containerEKEventEditViewController.containerParentController = self;
        [containerEKEventEditViewController loadWithExistingCalendarEvent:theEvent];
        containerEKEventEditViewController.view.frame = CGRectMake(0, 0, [Utils getScreenWidth], [Utils getScreenHeight]);
        [self presentViewController:containerEKEventEditViewController animated:YES completion:nil];
    }
     */
}




-(void)launchUpdatingCoverView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (self.updatingCoverView == nil)
    {
        self.updatingCoverView = [[UpdatingCoverView alloc] initWithFrame:CGRectMake(0, 0, [Utils getScreenWidth], [Utils getScreenHeight])];
        self.updatingCoverView.alpha = 0;
        [self.view addSubview:self.updatingCoverView];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.22];
        self.updatingCoverView.alpha = 1;
        [UIView commitAnimations];
    }
}

-(void)dismissUpdatingCoverView
{
    NSLog(@"eventStoreChangedTimerComplete");

    
    if (self.updatingCoverView != nil)
    {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.22];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(updatingCoverViewDidFade)];
    self.updatingCoverView.alpha = 1;
    [UIView commitAnimations];

    }
}

-(void)updatingCoverViewDidFade
{
    NSLog(@"updatingCoverViewDidFade");
    if (self.updatingCoverView != nil)
    {
        [self.updatingCoverView removeFromSuperview];
        self.updatingCoverView = nil;
    }
}


- (BOOL)prefersStatusBarHidden
{
    return YES;
}


-(int)getSecondaryState
{
    return self.theSecondaryState;
}

-(void)toggleToTodos
{
    if (self.theSecondaryState == SECONDARY_VIEW_STATE_TODOS)
    {
        if (self.coverScrollView.contentOffset.x == 0)
            [self.coverScrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        else
            [self.coverScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
    
    
    self.theSecondaryState = SECONDARY_VIEW_STATE_TODOS;
    [self.fullCalendarViewController.view removeFromSuperview];
    
    if (self.containerTodosViewController.view.superview == nil)
        [self.view insertSubview:self.containerTodosViewController.view belowSubview:self.coverScrollView];
    
    [self.coverScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}


-(void)toggleToCalendar
{
    if (self.theSecondaryState == SECONDARY_VIEW_STATE_CALENDAR)
    {
        if (self.coverScrollView.contentOffset.x == 0)
            [self.coverScrollView setContentOffset:CGPointMake(self.view.frame.size.width, 0) animated:YES];
        else
            [self.coverScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        
    }
    else
    {
        
        self.theSecondaryState = SECONDARY_VIEW_STATE_CALENDAR;
        
        [self.containerTodosViewController.view removeFromSuperview];
        
        if (self.fullCalendarViewController.view.superview == nil)
            [self.view insertSubview:self.fullCalendarViewController.view belowSubview:self.coverScrollView];
        
        [self.coverScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    }
}







@end
