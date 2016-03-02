//
//  CalendarManagementTableViewController.h
//  Calendar
//
//  Created by Alchemy50 on 7/11/14.
//
//

#import <UIKit/UIKit.h>


@interface CalendarManagementTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) id theParentController;

-(void)initialize;
-(void)reload;
-(void)checkAllButtonHit;
-(void)calendarContentChanged;
@end
