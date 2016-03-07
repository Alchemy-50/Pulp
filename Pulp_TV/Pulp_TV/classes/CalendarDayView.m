//
//  CalendarDayView.m
//  AlphaRow
//
//  Created by Josh Klobe on 10/27/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CalendarDayView.h"
#import "Defs.h"
#import "Circle.h"
#import "CalendarMonthView.h"
#import "DateFormatManager.h"
#import "Utils.h"
#import "EventForCalendarDayView.h"
#import "AppDelegate.h"
#import "ThemeManager.h"
#import "CalendarDaySelectedOverview.h"
#import "UIFocusButton.h"

@implementation CalendarDayView

@synthesize eventForCalendarDayView;

@synthesize theDate;
@synthesize dayLabel;
@synthesize parentView;
@synthesize drawLock;

- (id)initWithFrame:(CGRect)frame withParentView:(CalendarMonthView *)parent {
    
    self = [super initWithFrame:frame];
    if (self) {
        
        if (parent != nil)
            self.parentView = parent;
        self.dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,  self.frame.size.width,self.frame.size.height)];
        self.dayLabel.backgroundColor = [UIColor clearColor];
        self.dayLabel.textColor = [UIColor whiteColor];
        self.dayLabel.textAlignment = NSTextAlignmentCenter;
        self.dayLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
        [self addSubview:dayLabel];
        
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureFired)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
       
        
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureFired)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
       
        
        UILongPressGestureRecognizer *touchAndHoldRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureFired:)];
        touchAndHoldRecognizer.minimumPressDuration = 0.45;
        [self addGestureRecognizer:touchAndHoldRecognizer];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        
        self.theMaskView = [[MaskView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:self.theMaskView];
    }
    
    return self;
}


- (void)singleTapGestureFired
{
    NSLog(@"singleTapGestureFired");
    //    [[FlowControlHandler sharedFlowControlHandler] dayViewTapped:self];
    
    [[MainViewController sharedMainViewController] dayViewTapped:self];
}

-(void) doubleTapGestureFired
{
    NSLog(@"doubleTapGestureFired");
    //    [[FlowControlHandler sharedFlowControlHandler] dayViewDoubleTapped:self];
    
    [[MainViewController sharedMainViewController] resetCoverScrollToDate:self.theDate];
}


-(void) longPressGestureFired:(UIGestureRecognizer *)theGestureRecognizer
{
    
    switch (theGestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
            NSLog(@"UIGestureRecognizerStateBegan");
            //            [[FlowControlHandler sharedFlowControlHandler] dayViewLongPressed:self];
            break;
            
        case UIGestureRecognizerStateChanged:
            //            NSLog(@"UIGestureRecognizerStateChanged");
            break;
            
        case UIGestureRecognizerStateEnded:
            //            NSLog(@"UIGestureRecognizerStateEnded");
            
            break;
            
        case UIGestureRecognizerStateCancelled:
            //            NSLog(@"UIGestureRecognizerStateCancelled");
            break;
            
        default:
            break;
    }
    
}


-(void)loadEvents:(NSArray *)eventsArray
{
    if (self.drawLock == nil)
        self.drawLock = [[NSLock alloc] init];
    
    NSMutableArray *ar = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < [eventsArray count]; i++)
    {
        CalendarEvent *calendarEvent = [eventsArray objectAtIndex:i];
        
        //if (![[[calendarEvent getCalendar] getTitle] compare:@"TODO"] == NSOrderedSame)
            [ar addObject:[eventsArray objectAtIndex:i]];
    }
    
    
    
    [self.drawLock lock];
    
    if (self.eventForCalendarDayView != nil)
    {
        [self.eventForCalendarDayView removeFromSuperview];
        self.eventForCalendarDayView = nil;
    }
    
    if (self.eventForCalendarDayView == nil)
        self.eventForCalendarDayView = [[EventForCalendarDayView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    
    [self addSubview:self.eventForCalendarDayView];
    
    
    self.eventForCalendarDayView.backgroundColor = [UIColor clearColor];
    
    
    [self.eventForCalendarDayView loadViewsWithEvents:ar];
    [self.drawLock unlock];
    
    [self bringSubviewToFront:self.theMaskView];
    [self bringSubviewToFront:self.dayLabel];
    
    
}



-(void)clearEvents
{
    for (int i = 0; i < [[self subviews] count]; i++)
        if ([[[self subviews] objectAtIndex:i] isKindOfClass:[Circle class]])
            [[[self subviews] objectAtIndex:i] removeFromSuperview];
}

-(void) setUnselected
{
    if (self.calendarDaySelectedOverview != nil)
    {
        [self.calendarDaySelectedOverview removeFromSuperview];
        self.calendarDaySelectedOverview = nil;
    }
    
    /*
    NSDate *today = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init ];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    if ([[dateFormatter stringFromDate:today] compare:[dateFormatter stringFromDate:self.theDate]] != NSOrderedSame)
    {
        //        self.layer.borderColor = [UIColor clearColor].CGColor;
        //      self.layer.borderWidth = 0.0f;
        
        if (self.calendarDaySelectedOverview != nil)
        {
            [self.calendarDaySelectedOverview removeFromSuperview];
            self.calendarDaySelectedOverview = nil;
        }
    }
     */
    
    
    
}


-(void) setSelected
{
    //    self.layer.borderColor = [Utils getAppColor:COLOR_5].CGColor;
    //    self.layer.borderWidth = 3.5f;
    
    if (self.calendarDaySelectedOverview == nil)
    {
        self.calendarDaySelectedOverview = [[CalendarDaySelectedOverview alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.calendarDaySelectedOverview.backgroundColor = [UIColor clearColor];
        [self addSubview:self.calendarDaySelectedOverview];
        self.calendarDaySelectedOverview.backgroundColor = [UIColor clearColor];
    }
}



- (void)drawRect:(CGRect)rect
{

    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(currentContext, 1);
    //    CGContextSetRGBStrokeColor(currentContext, 19.0f/255.0f,103.0f/255.0f,88.0f/255.0f, 1.0f);
    CGContextSetRGBStrokeColor(currentContext, 19.0f/255.0f,103.0f/255.0f,88.0f/255.0f, 0.0f);
    CGContextBeginPath(currentContext);
    CGContextMoveToPoint(currentContext, 0, 0);
    CGContextAddLineToPoint(currentContext, rect.size.width, 0);
    CGContextAddLineToPoint(currentContext, rect.size.width, rect.size.height);
    CGContextAddLineToPoint(currentContext, 0, rect.size.height);
    CGContextAddLineToPoint(currentContext, 0, 0);
    CGContextStrokePath(currentContext);
    
    [super drawRect:rect];
    
    
}

-(void)destroyViews
{
    if (self.theMaskView != nil)
    {
        [self.theMaskView destroyViews];
        [self.theMaskView removeFromSuperview];

        self.theMaskView = nil;
    }
    
    if (self.focusButton != nil)
    {
        [self.focusButton removeFromSuperview];
        self.focusButton = nil;
    }
        
}



@end
