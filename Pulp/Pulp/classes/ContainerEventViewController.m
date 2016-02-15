//
//  ContainerEventViewController.m
//  Calendar
//
//  Created by Josh Klobe on 3/13/14.
//
//

#import "ContainerEventViewController.h"
#import <EventKit/EventKit.h>
#import "EventKitManager.h"
#import <EventKitUI/EventKitUI.h>
#import "EventManagerViewController.h"
#import "EditEventNavigationViewController.h"

#import "AppDelegate.h"


@interface ContainerEventViewController ()

@end

@implementation ContainerEventViewController

@synthesize theEvent;
@synthesize eventViewContainer;
@synthesize eventEditController;
@synthesize parentController;

@synthesize eKEventViewController;


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

    
    
    self.eventViewContainer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.eventViewContainer.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.eventViewContainer];
    
    self.eventViewContainer.backgroundColor = [UIColor colorWithCGColor:self.theEvent.calendar.CGColor];
    self.view.backgroundColor = self.eventViewContainer.backgroundColor;
    
    self.eKEventViewController = [[EKEventViewController alloc] initWithNibName:nil bundle:nil];
    self.eKEventViewController.event = self.theEvent;
    self.eKEventViewController.allowsEditing = YES;
    self.eKEventViewController.delegate = self;
    
    /*    self.eKEventViewController.view.frame = CGRectMake(0, 60, eKEventViewController.view.frame.size.width, eKEventViewController.view.frame.size.height-80);
     [self.view addSubview:eKEventViewController.view];
     self.eKEventViewController.view.frame = CGRectMake(0, 60, self.view.frame.size.width, self.view.frame.size.height - 80);
     */
    
    EditEventNavigationViewController *navigationController = [[EditEventNavigationViewController alloc] initWithRootViewController:self.eKEventViewController];

    /*
    NSArray *navigationControllerSubviews = [navigationController.view subviews];
    for (int i = 0; i < [navigationControllerSubviews count]; i++)
    {
        UIView *aView = [navigationControllerSubviews objectAtIndex:i];
        if ([aView isKindOfClass:[UINavigationBar class]])
            [aView removeFromSuperview];
    }
     */
    
    UIColor *buttonColor = [UIColor colorWithRed:75.0f/255.0f green:160.0f/255.0f blue:250.0f/255.0f alpha:1];
    buttonColor = [UIColor whiteColor];
    
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(4, 0, 80, 44);
    [leftButton setTitle:@"Cancel" forState:UIControlStateNormal];
    [leftButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(cancelButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [navigationController.view addSubview:leftButton];
    
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(self.view.frame.size.width - 80, leftButton.frame.origin.y, leftButton.frame.size.width, leftButton.frame.size.height);
    [rightButton setTitle:@"Edit" forState:UIControlStateNormal];
    [rightButton setTitleColor:buttonColor forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(rightButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [navigationController.view addSubview:rightButton];
    
    
    
    
    
    
    
    [self.eventViewContainer addSubview:navigationController.view];

          
    
          
          
          /*
    NSArray *subviewsArray = [eKEventViewController.view subviews];
//    NSLog(@"subviewsArray: %@", subviewsArray);
    
    for (int i = 0; i < [subviewsArray count]; i++)
    {
        id aView = [subviewsArray objectAtIndex:i];
//        NSLog(@"aView[%d]: %@", i, aView);
        
        if ([aView isKindOfClass:[UITableView class]])
        {
            UITableView *theTableView = (UITableView *)aView;
//            NSLog(@"theTableView: %@", theTableView);
//            NSLog(@"theTableView.dataSource: %@", theTableView.dataSource);
//            theTableView.dataSource = self;
            [theTableView reloadData];
            
        }
    }
           */
}





-(void)cancelButtonHit
{
    [self.parentController eventViewCancelButtonHit];
}

-(void)rightButtonHit
{
    NSLog(@"rightButtonHit");
    self.eventEditController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    self.eventEditController.view.frame = CGRectMake(self.view.frame.size.width, 20, self.eventEditController.view.frame.size.width, self.eventEditController.view.frame.size.height);
    self.eventEditController.eventStore = [EventKitManager sharedManager].eventStore;
    self.eventEditController.event = self.theEvent;
    self.eventEditController.editViewDelegate = self;
    [self.view addSubview:self.eventEditController.view];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.33];
    self.eventEditController.view.frame = CGRectMake(0, self.eventEditController.view.frame.origin.y, self.eventEditController.view.frame.size.width, self.eventEditController.view.frame.size.height);
    self.eventViewContainer.frame = CGRectMake(-self.view.frame.size.width, self.eventViewContainer.frame.origin.y, self.eventViewContainer.frame.size.width, self.eventViewContainer.frame.size.height);
    [UIView commitAnimations];
}

- (void)eventViewController:(EKEventViewController *)controller didCompleteWithAction:(EKEventViewAction)action __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_4_2)
{
    NSLog(@"%s, here!", __PRETTY_FUNCTION__);
    if (action == EKEventViewActionDeleted)
    {
        [[MainViewController sharedMainViewController] dismissViewControllerAnimated:YES completion:nil];
        
    }

    
}


- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    NSLog(@"didCompleteWithAction");
    [self.parentController eventEditViewController:controller didCompleteWithAction:action];
}









/*



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"numberOfSectionsInTableView called !!!!!!!!!!!!!!!!");
    
    int retVal = [self.eKEventViewController numberOfSectionsInTableView:tableView];
    NSLog(@"retVal: %d", retVal);
    
    
    return retVal;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"numberOfRowsInSection called !!!!!!!!!!!!!!!!");
    
    int retVal = [self.eKEventViewController tableView:tableView numberOfRowsInSection:section];
    NSLog(@"retVal: %d", retVal);
    
    
    return retVal;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.eKEventViewController tableView:tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == 0)
        cell.backgroundColor = [UIColor redColor];
    else
        cell.backgroundColor = [UIColor blueColor];
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float height = [self.eKEventViewController tableView:tableView heightForRowAtIndexPath:indexPath];
    return height;
}


 */

@end
