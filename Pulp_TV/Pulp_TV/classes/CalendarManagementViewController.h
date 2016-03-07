//
//  CalendarManagementViewController.h
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarManagementViewController : UIViewController

+(CalendarManagementViewController *)sharedCalendarManagementViewController;
-(void)doPresent;
@end
