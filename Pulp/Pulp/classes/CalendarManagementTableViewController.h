//
//  CalendarManagementTableViewController.h
//  Calendar
//
//  Created by Alchemy50 on 7/11/14.
//
//

#import <UIKit/UIKit.h>

@class FullCalendarViewController;

@interface CalendarManagementTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>

-(void)reload;

@property (nonatomic, retain) NSMutableArray *calendarsArray;
@property (nonatomic, retain) FullCalendarViewController *parentFullCalendarViewController;

@property (nonatomic, retain) NSString *theNewCalendarString;
@property (nonatomic, retain) UIView *bgView;
@property (nonatomic, retain) UITableView *theTableView;
@end
