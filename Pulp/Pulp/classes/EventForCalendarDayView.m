//
//  EventForCalendarDayView.m
//  Calendar
//
//  Created by Josh Klobe on 6/6/13.
//
//

#import "EventForCalendarDayView.h"
#import "CalendarEvent.h"


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

    float height = 2.5;
    
    
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
        


        float yPos = self.frame.size.height - (([eventsArray count] - i) * height) - 5;                
    
        UIView *eventRepresentationView = [[UIView alloc] initWithFrame:CGRectMake(0, yPos, self.frame.size.width, height)];
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
            [subview removeFromSuperview];
            [subview release];
            subview = nil;
    }
}


@end
