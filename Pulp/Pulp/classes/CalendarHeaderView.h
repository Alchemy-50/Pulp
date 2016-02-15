//
//  CalendarHeaderView.h
//  AlphaRow
//
//  Created by jay canty on 11/7/11.
//  Copyright (c) 2011 A 50. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HeaderArrowView.h"

@class FullCalendarViewController;

@interface CalendarHeaderView : UIView {

	FullCalendarViewController *fullCalendarparentController;
    UILabel *calendarTitleLabel;
    UISwipeGestureRecognizer *swipeToDismissFullTableRecognizer;
}

-(void) loadTitleLabel;
-(void) transformNormal;
-(void) transformDown;

@property (nonatomic, retain) FullCalendarViewController *fullCalendarparentController;
@property (nonatomic, retain) UILabel *calendarTitleLabel;
@property (nonatomic, retain) UISwipeGestureRecognizer *swipeToDismissFullTableRecognizer;
@property (nonatomic, retain) HeaderArrowView *headerArrowView;

@end


