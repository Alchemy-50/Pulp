//
//  EditCalendarManagementViewController.h
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface EditCalendarManagementViewController : UIViewController


@property (nonatomic, retain) IBOutlet UILabel *cancelLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *doneLabel;


@property (nonatomic, retain) IBOutlet UILabel *nameLabel;
@property (nonatomic, retain) IBOutlet UIView *nameEntryBackgroundView;
@property (nonatomic, retain) UITextField *nameEntryTextField;


-(void)loadWithCalendar:(EKCalendar *)theCalendar;
@end
