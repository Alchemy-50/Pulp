//
//  EditCalendarViewController.h
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface EditCalendarViewController : UIViewController

- (void)initialize;
-(void)loadWithCalendar:(EKCalendar *)theCalendar;
@end
