//
//  CalendarManagementTableViewCell.h
//  Calendar
//
//  Created by Alchemy50 on 7/11/14.
//
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@class CalendarManagementTableViewController;
@interface BAKCalendarManagementTableViewCell : UITableViewCell


-(void)loadWithCalendar:(EKCalendar *)theCalendar;
-(void) loadForAddCalendar;
-(void) cleanViews;

@property (nonatomic, retain) CalendarManagementTableViewController *parentCalendarManagementTableViewController;
@property (nonatomic, retain) EKCalendar *referenceCalendar;


@property (nonatomic, retain) UILabel *calendarNameLabel;
@property (nonatomic, retain) UILabel *sourceNameLabel;
@property (nonatomic, retain) UIImageView *cogImageView;

@property (nonatomic, retain) UIView *addBackgroundView;
@property (nonatomic, retain) UILabel *addCalendarLabel;

@property (nonatomic, retain) UIView *separatorView;

@property (nonatomic, retain) UIImageView *checkBoxImageView;
@property (nonatomic, retain) UIButton *checkButton;
@end
