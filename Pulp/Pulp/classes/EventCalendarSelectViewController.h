//
//  EventCalendarSelectViewController.h
//  Calendar
//
//  Created by Josh Klobe on 6/5/14.
//
//

#import <UIKit/UIKit.h>

@class FullViewEventCreateViewController;

@interface EventCalendarSelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

-(void)loadTheViews;

-(void)hideCalendarLabels;
-(void)showCalendarLabels;

@property (nonatomic, retain) FullViewEventCreateViewController *parentFullViewEventCreateViewController;
@property (nonatomic, retain) NSMutableArray *calendarsArray;
@property (nonatomic, retain) UITableView *theTableView;
@property (nonatomic, retain) NSMutableArray *labelsArray;
@end
