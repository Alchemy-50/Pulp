//
//  CalendarDoubleDayView.m
//  Calendar
//
//  Created by jay canty on 2/9/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "CalendarDoubleDayView.h"
#import "Circle.h"
#import "CalendarMonthView.h"

#import "DateFormatManager.h"
#import "Utils.h"
#import "AppDelegate.h"

@implementation CalendarDoubleDayView

@synthesize theDate2, dayLabel2, dragPoint, top;

- (id)initWithFrame:(CGRect)frame withParentView:(CalendarMonthView *)parent
{
    self = [super initWithFrame:frame withParentView:parent];
    if (self) {
        // Initialization code
        
        self.dayLabel.frame = CGRectMake(2, 3, 28, 20);
        self.dayLabel.backgroundColor = [UIColor clearColor];
        
		self.dayLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width / 2,self.frame.size.height / 2 + 1,23,20)];
		self.dayLabel2.backgroundColor = [UIColor clearColor];
		self.dayLabel2.textColor = self.dayLabel.textColor;
		self.dayLabel2.textAlignment = NSTextAlignmentCenter;        
 		self.dayLabel2.font = self.dayLabel.font;
		[self addSubview:self.dayLabel2];    
        
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureFired)];
        singleTap.numberOfTapsRequired = 1;
        [self addGestureRecognizer:singleTap];
        [singleTap release];
        
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapGestureFired)];
        doubleTap.numberOfTapsRequired = 2;
        [self addGestureRecognizer:doubleTap];
        [doubleTap release];
        
        [singleTap requireGestureRecognizerToFail:doubleTap];
        
        
        top = NO;
        
    }
    return self;
}

- (void)singleTapGestureFired
{
    NSLog(@"%@ singleTapGestureFired", self);
/*
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppViewController *appViewController = appDelegate.appController;
    
//    [appViewController.mainViewController dayViewTapped:self];
 */

}

-(void) doubleTapGestureFired
{
    NSLog(@"%@ doubleTapGestureFired", self);
    /*
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppViewController *appViewController = appDelegate.appController;
    
    [appViewController.rootViewController callAddEventPopupWithCalendarDayView:self];
     */
}


-(void)loadEvents:(NSArray *)eventsArray
{
    float xStart = 3.0;
    float yStart = 5.0;
    
    for (CalendarEvent *calEvent in eventsArray)
    {
        UIColor *eColor = [[calEvent getCalendar] getColor];
        
        Circle *circle = [[Circle alloc] initWithFrame:CGRectMake(xStart, yStart, 10, 10) withUnitArea:1.0 andFillColor:eColor andStrokeColor:eColor withStrokeThickness:0];
        [self addSubview:circle];
        
        yStart += 11.0;
        
        if (yStart > self.frame.size.height - 10)
        {            
            yStart = 5.0;
            xStart += 11.0;
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1);
    CGContextBeginPath (context);
    CGContextMoveToPoint(context, 10, self.frame.size.height - 10);
    CGContextAddLineToPoint(context, self.frame.size.width - 10, 10);
    CGContextStrokePath(context);
}


@end
