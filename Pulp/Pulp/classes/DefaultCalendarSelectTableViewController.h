//
//  DefaultCalendarSelectTableViewController.h
//  Calendar
//
//  Created by Alchemy50 on 6/11/14.
//
//

#import <UIKit/UIKit.h>
#import "AppSettingsViewController.h"

@interface DefaultCalendarSelectTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>


@property (nonatomic, retain) AppSettingsViewController *parentAppSettingsViewController;
@end
