//
//  EventCalendarSelectTableViewCell.m
//  Calendar
//
//  Created by Alchemy50 on 6/6/14.
//
//

#import "EventCalendarSelectTableViewCell.h"

@implementation EventCalendarSelectTableViewCell

@synthesize backgroundView;
@synthesize calendarLabel;
@synthesize separatorView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


-(void)loadWithCalendar:(EKCalendar *)theCalendar
{
    if (self.backgroundView == nil)
    {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundView];
    }
    
    if (self.calendarLabel == nil)
    {
        float inset = 10;
        self.calendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset, 0, self.frame.size.width - inset, self.frame.size.height)];
        self.calendarLabel.backgroundColor = [UIColor clearColor];
        self.calendarLabel.textColor = [UIColor whiteColor];
        self.calendarLabel.textAlignment = NSTextAlignmentLeft;
        self.calendarLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
        [self addSubview:self.calendarLabel];
    }
    
    if (self.separatorView == nil)
    {
        self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        self.separatorView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.separatorView];
    }
    
    self.backgroundView.backgroundColor = [UIColor colorWithCGColor:theCalendar.CGColor];
    self.calendarLabel.text = theCalendar.title;
    
}

@end
