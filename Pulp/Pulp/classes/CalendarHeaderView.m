//
//  CalendarHeaderView.m
//  AlphaRow
//
//  Created by jay canty on 11/7/11.
//  Copyright (c) 2011 A 50. All rights reserved.
//

#import "CalendarHeaderView.h"

#import <QuartzCore/QuartzCore.h>
#import "Utils.h"
#import "GroupDataManager.h"

#import "AppDelegate.h"
#import "FullCalendarViewController.h"
#import "AppSettingsViewController.h"
#import "AppDelegate.h"
#import "ThemeManager.h"

@implementation CalendarHeaderView

@synthesize fullCalendarparentController, calendarTitleLabel, swipeToDismissFullTableRecognizer;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.calendarTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 2, self.frame.size.width, self.frame.size.height)];
        self.calendarTitleLabel.textColor = [UIColor whiteColor];
        self.calendarTitleLabel.backgroundColor = [UIColor clearColor];
        self.calendarTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.calendarTitleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14];
        [self addSubview:self.calendarTitleLabel];
        
        [[ThemeManager sharedThemeManager] registerSecondaryObject:self.calendarTitleLabel];
        
        UIButton *calButton = [UIButton buttonWithType:UIButtonTypeCustom];
        calButton.frame = CGRectMake(0, 0, 250, self.frame.size.height);
        calButton.backgroundColor = [UIColor clearColor];
        [calButton addTarget:self action:@selector(calButtonHit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:calButton];
        
        
        self.swipeToDismissFullTableRecognizer = [[UISwipeGestureRecognizer alloc] init];
        self.swipeToDismissFullTableRecognizer.direction = UISwipeGestureRecognizerDirectionDown;
        [self addGestureRecognizer:self.swipeToDismissFullTableRecognizer];
                
    }
    
    [self loadTitleLabel];
    return self;
}



-(void)calButtonHit
{
    NSLog(@"%@ calButtonHit do IMPLEMENT", self);
    [self.fullCalendarparentController topCalButtonHit:NO];
}

-(void)calendarSettingsButtonHit
{
    /*
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppViewController *appViewController = delegate.appController;
    [appViewController cogButtonHit];
     */
}

-(void)loadTitleLabel
{
    self.calendarTitleLabel.text = @"All Calendars";
    AppDelegate *theDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (theDelegate.currentSelectedCalendar != nil)
        self.calendarTitleLabel.text = theDelegate.currentSelectedCalendar.title;
    
    
    
    CGSize maximumLabelSize = CGSizeMake(99999,self.calendarTitleLabel.frame.size.height);
    
    
    CGSize expectedLabelSize = [self.calendarTitleLabel.text boundingRectWithSize:maximumLabelSize
                                                                          options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin
                                                                       attributes:@{NSFontAttributeName:self.calendarTitleLabel.font}
                                                                          context:nil].size;
    
    
    self.calendarTitleLabel.frame = CGRectMake(self.calendarTitleLabel.frame.origin.x, self.calendarTitleLabel.frame.origin.y, expectedLabelSize.width, self.calendarTitleLabel.frame.size.height);
    
    
}




@end
