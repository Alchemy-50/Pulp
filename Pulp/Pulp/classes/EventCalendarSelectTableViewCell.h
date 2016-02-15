//
//  EventCalendarSelectTableViewCell.h
//  Calendar
//
//  Created by Alchemy50 on 6/6/14.
//
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@interface EventCalendarSelectTableViewCell : UITableViewCell

-(void)loadWithCalendar:(EKCalendar *)theCalendar;

@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UILabel *calendarLabel;
@property (nonatomic, retain) UIView *separatorView;
@end
