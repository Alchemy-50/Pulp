//
//  CalendarDoubleDayView.h
//  Calendar
//
//  Created by jay canty on 2/9/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarDayView.h"

@interface CalendarDoubleDayView : CalendarDayView {
    
    NSDate *theDate2;
    UILabel *dayLabel2;
    
    CGPoint dragPoint;
    BOOL top;
}

-(id) initWithFrame:(CGRect)frame withParentView:(CalendarMonthView *)parent;


@property (nonatomic, retain) NSDate *theDate2;
@property (nonatomic, retain) UILabel *dayLabel2;

@property (nonatomic, retain) UIView *dayView;

@property (nonatomic, assign) CGPoint dragPoint;
@property (nonatomic, assign) BOOL top;

@end
