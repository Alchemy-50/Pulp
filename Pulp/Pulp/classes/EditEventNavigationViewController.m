//
//  EditEventNavigationViewController.m
//  Calendar
//
//  Created by Alchemy50 on 6/3/14.
//
//

#import "EditEventNavigationViewController.h"


#import <EventKit/EventKit.h>
#import "EventKitManager.h"
#import <EventKitUI/EventKitUI.h>



@interface EditEventNavigationViewController ()

@end

@implementation EditEventNavigationViewController

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
    /*
    NSLog(@"!!!!!!!!!!!!!!!!! subviews: %@", [self.view subviews]);
    
    NSArray *ar = [self.view subviews];
    for (int i = 0; i < [ar count]; i++)
    {
        NSLog(@"ar[%d]: %@", i, [ar objectAtIndex:i]);
        NSLog(@"subviews: %@", [[ar objectAtIndex:i] subviews]);
        NSLog(@" ");
    }
*/
    [super viewDidLoad];
    [self.navigationBar removeFromSuperview];

}

- (id)initWithRootViewController:(UIViewController *)rootViewController; // Convenience method pushes the root view controller without animation.
{
    return [super initWithRootViewController:rootViewController];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (![viewController isKindOfClass:[EKEventViewController class]])
        [self.view addSubview:self.navigationBar];
    
    [super pushViewController:viewController animated:animated];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    [self.navigationBar removeFromSuperview];
    return [super popViewControllerAnimated:animated];
}




@end
