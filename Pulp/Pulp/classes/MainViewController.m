//
//  MainViewController.m
//  Calendar
//
//  Created by Josh Klobe on 2/11/16.
//
//

#import "MainViewController.h"
#import "SidebarView.h"
#import "CenterViewController.h"
#import "FullCalendarViewController.h"
#import "Utils.h"
#import "CoverScrollView.h"
#import "AppSettingsViewController.h"
#import "ContainerTodosViewController.h"
#import "SidebarButtonView.h"

@interface MainViewController ()
@property (nonatomic, retain) SidebarView *sidebarView;
@property (nonatomic, retain) FullCalendarViewController *fullCalendarViewController;
@property (nonatomic, retain) ContainerTodosViewController *containerTodosViewController;

@property (nonatomic, retain) CoverScrollView *coverScrollView;
@property (nonatomic, retain) CenterViewController *centerViewController;

@property (nonatomic, assign) BOOL initialized;
@end


@implementation MainViewController

static MainViewController *staticVC;

+(MainViewController *)sharedMainViewController
{
    return staticVC;
}


-(void)toggleToTodos
{
    [self.fullCalendarViewController.view removeFromSuperview];
    
    if (self.containerTodosViewController.view.superview == nil)
        [self.view insertSubview:self.containerTodosViewController.view belowSubview:self.coverScrollView];
    
}


-(void)toggleToCalendar
{
    [self.containerTodosViewController.view removeFromSuperview];
    
    if (self.fullCalendarViewController.view.superview == nil)
        [self.view insertSubview:self.fullCalendarViewController.view belowSubview:self.coverScrollView];
}



- (void)viewDidLoad {
    
    staticVC = self;
    
    [super viewDidLoad];

    float barWidth = 60;
    
    self.sidebarView = [[SidebarView alloc] initWithFrame:CGRectMake(0, 0, barWidth, self.view.frame.size.height)];
    [self.view addSubview:self.sidebarView];

    
    self.fullCalendarViewController = [[FullCalendarViewController alloc] initWithNibName:@"FullCalendarViewController" bundle:nil];
    [self.view addSubview:self.fullCalendarViewController.view];
    self.fullCalendarViewController.view.frame = CGRectMake(barWidth, 0, [Utils getScreenWidth] - barWidth, [Utils getScreenHeight]);
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
    
    self.centerViewController = [[CenterViewController alloc] initWithNibName:nil bundle:nil];
    self.centerViewController.centerSidebarView = self.sidebarView;
    self.centerViewController.view.frame = CGRectMake(width, 0, width, self.view.frame.size.height);
    [self.coverScrollView addSubview:self.centerViewController.view];
    [self.centerViewController loadViews];
   
    self.coverScrollView.contentSize = CGSizeMake(self.centerViewController.view.frame.size.width * 2, 0);
    [self.coverScrollView setContentOffset:CGPointMake(self.centerViewController.view.frame.origin.x, 0) animated:NO];
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(resetCover)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.coverScrollView addGestureRecognizer:swipeGestureRecognizer];
    [self.view addGestureRecognizer:swipeGestureRecognizer];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x > self.centerViewController.view.frame.size.width)
        scrollView.contentOffset = CGPointMake(self.centerViewController.view.frame.origin.x, 0);
}

-(void)resetCover
{
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
        [self.centerViewController processPositioningWithScrollView:self.centerViewController.contentScrollView];
    }
    
    self.initialized = YES;

}


-(void)dailyViewAddEventButtonHit:(NSDate *)referenceDate
{
    EventManagerViewController *createEventViewController = [[EventManagerViewController alloc] initWithNibName:@"EventManagerViewController" bundle:nil];
    createEventViewController.theParentViewController = self;
    createEventViewController.calendarReferenceDate = referenceDate;
    [createEventViewController createNewEventWithReferenceDate];

    [self presentViewController:createEventViewController animated:YES completion:nil];
    createEventViewController.view.frame = CGRectMake(0, 0, [Utils getScreenWidth], [Utils getScreenHeight]);
}


- (void) presentSettingsViewController
{
    AppSettingsViewController *appSettingsViewController = [[AppSettingsViewController alloc] initWithNibName:@"AppSettingsViewController" bundle:nil];
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:appSettingsViewController] animated:YES completion:nil];
}

- (void) dismissSettingsViewController
{
    [self dismissViewControllerAnimated:YES completion:^{
         [self dataChanged];
     }];
}



-(void)createEventExitButtonHitWithController:(EventManagerViewController *)theController withEvent:(EKEvent *)theEvent withAction:(EKEventEditViewAction)theAction
{
    NSLog(@"createEventExitButtonHitWithController");
    
    if (theAction == EKEventEditViewActionSaved)
        if (theEvent != nil)
            if (theEvent.title != nil)
            {
                [self.fullCalendarViewController.contentContainerViewController spoofCalendarDayViewWithEvent:theEvent withAction:theAction];
                [self.centerViewController spoofAddEventWithEvent:theEvent withAction:theAction];
                [self dataChanged];
                
            }
    
        [self dismissViewControllerAnimated:YES completion:^(void){
            
        }];
}


- (void) dayViewTapped:(CalendarDayView *)tappedDay
{    
    [self.fullCalendarViewController.contentContainerViewController dayViewSelected:tappedDay];
}

-(void)dailyEventSelected:(EKEvent *)theEvent
{
    if (theEvent != nil)
    {
        
        EventManagerViewController *createEventViewController = [[EventManagerViewController alloc] initWithNibName:@"EventManagerViewController" bundle:nil];
        createEventViewController.theParentViewController = self;
        createEventViewController.ekObjectReference = theEvent;
        [self presentViewController:createEventViewController animated:YES completion: ^(void) {  [createEventViewController displayEvent]; }];
        
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}


@end
