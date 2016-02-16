//
//  CalendarDayView.h
//  AlphaRow
//
//  Created by Josh Klobe on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CalendarEvent.h"
#import "EventForCalendarDayView.h"
#import "MaskView.h"


@class CalendarMonthView;

@interface CalendarDayView : UIView {

}

-(id) initWithFrame:(CGRect)frame withParentView:(CalendarMonthView *)parent;
-(void) loadEvents:(NSArray *)eventsArray;
-(void) clearEvents;
-(void) setSelected;
-(void) setUnselected;
-(void) destroyViews;

@property (nonatomic, retain) CalendarMonthView *parentView;
@property (nonatomic, retain) EventForCalendarDayView *eventForCalendarDayView;
@property (nonatomic, retain) NSDate *theDate;
@property (nonatomic, retain) UILabel *dayLabel;
@property (nonatomic, retain) NSLock *drawLock;
@property (nonatomic, retain) MaskView *theMaskView;
@end
