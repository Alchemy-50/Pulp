//
//  EventForCalendarDayView.m
//  Calendar
//
//  Created by Josh Klobe on 6/6/13.
//
//

#import "EventForCalendarDayView.h"
#import "CalendarEvent.h"
#import "EventRepresentationView.h"


@implementation EventForCalendarDayView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor blackColor];
    }
    return self;
}

-(void)loadViewsWithEvents:(NSArray *)eventsArray
{
    [self destroy];
    
    for (int i = 0; i < [eventsArray count]; i++)
    {
        CalendarEvent *calendarEvent = [eventsArray objectAtIndex:i];

        EKEvent *calendarEKEvent = calendarEvent.ekObject;
        
        if ([calendarEvent.ekObject isKindOfClass:[NSArray class]])
        {
            NSArray *theArray = (NSArray *)calendarEKEvent;
            if ([theArray count] > 0)
                calendarEKEvent = [theArray objectAtIndex:0];
        }
        
        EKCalendar *calendarEKEventCalendar = calendarEKEvent.calendar;
        
        UIColor *eventColor = [UIColor colorWithCGColor:calendarEKEventCalendar.CGColor];
        
        float width = 2.5;
                
        EventRepresentationView *eventRepresentationView = [[EventRepresentationView alloc] initWithFrame:CGRectMake(width, 1.5 + i * width, self.frame.size.width - 2 * width, width)];
        eventRepresentationView.backgroundColor = eventColor;
        [self addSubview:eventRepresentationView];
                                                               
    }
}


-(void)destroy
{
    NSArray *subviewsArray = [self subviews];
    for (int i = 0; i < [subviewsArray count]; i++)
    {
        UIView *subview = [subviewsArray objectAtIndex:i];
        if ([subview isKindOfClass:[EventRepresentationView class]])
        {
            [subview removeFromSuperview];
            [subview release];
            subview = nil;
        }
    }
}


@end
