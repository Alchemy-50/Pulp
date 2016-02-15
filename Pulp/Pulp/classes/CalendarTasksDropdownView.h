//
//  CalendarTasksDropdownView.h
//  Calendar
//
//  Created by Josh Klobe on 5/21/13.
//
//

#import <UIKit/UIKit.h>

@interface CalendarTasksDropdownView : UIView


-(void)loadCommonTaskSubviews;
+(CalendarTasksDropdownView *)getSharedCalendarTasksDropdownView;


@property (nonatomic, retain) UIScrollView *theScrollView;
@end
