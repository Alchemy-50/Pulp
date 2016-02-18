//
//  CalendarManagementTableViewCell.m
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "CalendarManagementTableViewCell.h"

@interface CalendarManagementTableViewCell ()
@property (nonatomic, retain) UIView *strokeView;
@property (nonatomic, retain) UIView *bottomStrokeView;

@property (nonatomic, retain) UILabel *calendarNameLabel;
@property (nonatomic, retain) UIImageView *cogImageView;
@end

@implementation CalendarManagementTableViewCell


-(void) initialize
{
    self.strokeView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height -1 , self.frame.size.width, 1)];
    self.strokeView.backgroundColor = [UIColor colorWithWhite:0 alpha:15];
    [self addSubview:self.strokeView];
    
    
    self.calendarNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(68, 0, self.frame.size.width - 80, self.frame.size.height)];
    self.calendarNameLabel.backgroundColor = [UIColor clearColor];
    self.calendarNameLabel.textAlignment = NSTextAlignmentLeft;
    self.calendarNameLabel.font = [UIFont fontWithName:@"Lato-Semibold" size:14];
    self.calendarNameLabel.textColor = [UIColor whiteColor];
    [self addSubview:self.calendarNameLabel];
    
    
    
}

-(void) cleanViews
{
    self.calendarNameLabel.text = @"";
}

-(void) loadWithCalendar:(EKCalendar *)theCalendar
{
    self.calendarNameLabel.text = theCalendar.title;
}
@end
