//
//  CalendarHeaderView.h
//  AlphaRow
//
//  Created by jay canty on 11/7/11.
//  Copyright (c) 2011 A 50. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FullCalendarViewController;

@interface CalendarHeaderView : UIView {

	FullCalendarViewController *fullCalendarparentController;
    UILabel *calendarTitleLabel;
    UISwipeGestureRecognizer *swipeToDismissFullTableRecognizer;
}

-(void) loadTitleLabel;


@property (nonatomic, retain) FullCalendarViewController *fullCalendarparentController;
@property (nonatomic, retain) UILabel *calendarTitleLabel;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeToDismissFullTableRecognizer;

@end

