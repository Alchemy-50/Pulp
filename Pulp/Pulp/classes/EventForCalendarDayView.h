//
//  EventForCalendarDayView.h
//  Calendar
//
//  Created by Josh Klobe on 6/6/13.
//
//

#import <UIKit/UIKit.h>

@interface EventForCalendarDayView : UIView

-(void)loadViewsWithEvents:(NSArray *)eventsArray;
-(void)destroy;

@end
