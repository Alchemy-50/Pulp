//
//  CalendarAccountManagerTableViewController.h
//  AlphaRow
//
//  Created by Josh Klobe on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalendarComponentViewController;

@interface CalendarAccountManagerTableViewController : UITableViewController
{
    CalendarComponentViewController *parent;
    NSMutableArray *calendarsArray;

}


-(void)loadCalendars;
@property (nonatomic, retain) CalendarComponentViewController *parent;;
@property (nonatomic, retain) NSMutableArray *calendarsArray;
@end
