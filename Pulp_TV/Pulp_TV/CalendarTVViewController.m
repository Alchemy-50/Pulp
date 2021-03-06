//
//  CalendarTVViewController.m
//  Pulp_TV
//
//  Created by Josh Klobe on 3/3/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "CalendarTVViewController.h"
#import "FullCalendarViewController.h"
#import "UIFocusButton.h"
#import "DailyViewController.h"

@interface CalendarTVViewController ()
@property (nonatomic, retain) UIView *contentView;
@property (nonatomic, retain) FullCalendarViewController *fullCalendarViewController;
@property (nonatomic, retain) DailyViewController *dailyViewController;
@end

@implementation CalendarTVViewController

static CalendarTVViewController *staticVC;

+(CalendarTVViewController *)sharedController
{
    return staticVC;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    staticVC = self;
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    float inset = self.view.frame.size.width * .01;
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(inset, inset, self.view.frame.size.width - 2 * inset, self.view.frame.size.height - 2 * inset)];
    self.contentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.contentView];
    

    
    self.fullCalendarViewController = [[FullCalendarViewController alloc] initWithNibName:nil bundle:nil];
    [self.contentView addSubview:self.fullCalendarViewController.view];
    self.fullCalendarViewController.view.frame = CGRectMake(0, 0, self.contentView.frame.size.width / 2, self.contentView.frame.size.height);
    [self.fullCalendarViewController doLoadViews];
    

    self.dailyViewController = [[DailyViewController alloc] initWithNibName:nil bundle:nil];
    self.dailyViewController.view.frame = CGRectMake(self.fullCalendarViewController.view.frame.size.width, 0, self.contentView.frame.size.width - self.fullCalendarViewController.view.frame.size.width, self.contentView.frame.size.height);
    [self.contentView addSubview:self.dailyViewController.view];
    [self.dailyViewController loadViews];
    
    [[DailyViewController sharedDailyViewController] scrollToDate:[NSDate date]];
    

}

-(void)focusChanged:(BOOL)didFocusTo withReferenceObject:(id)theReferenceObject
{
    NSLog(@"%s, didFocusTo: %d, theReferenceObject: %@", __PRETTY_FUNCTION__, didFocusTo, theReferenceObject);
}



-(void) dataChanged
{
    [self.fullCalendarViewController dataChanged];        
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
