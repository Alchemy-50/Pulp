//
//  MonthContainerView.h
//  Calendar
//
//  Created by Josh Klobe on 2/11/16.
//
//

#import <UIKit/UIKit.h>
#import "CalendarMonthView.h"
@interface MonthContainerView : UIView


@property (nonatomic, retain) CalendarMonthView *theCalendarMonthView;
@property (nonatomic, retain) NSDate *firstOfMonthDateReference;
@end
