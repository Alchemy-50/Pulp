//
//  CalendarDragManagerView.m
//  Calendar
//
//  Created by Josh Klobe on 5/21/13.
//
//

#import "CalendarDragManagerView.h"
#import "AppDelegate.h"



@implementation CalendarDragManagerView


@synthesize originalDragViewReference, draggingView, originalRect;
@synthesize trashImageView;

//static float sizeFactor = 1.5;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        float diam = 100;
        self.trashImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - diam / 2, self.frame.size.height - diam, diam, diam)];
        self.trashImageView.image = [UIImage imageNamed:@"shitty_trash.png"];
        [self addSubview:self.trashImageView];
        
        // Initialization code
    }
    return self;
}


+(void)commonEventContainerTapped:(CommonTaskDropdownSubview *)theContainer
{
    NSLog(@"do implement commonEventContainerTapped");

}


+(void)beginDragWithCommonTaskDropdownSubview:(CommonTaskDropdownSubview *)commonTaskDropdownSubview withTouchesSet:(NSSet *)theSet
{
    commonTaskDropdownSubview.parentScrollview.scrollEnabled = NO;
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;

    
    CalendarDragManagerView *dragManagerView = [[CalendarDragManagerView alloc] initWithFrame:CGRectMake(0, 0, del.window.frame.size.width, del.window.frame.size.height)];
    dragManagerView.backgroundColor = [UIColor clearColor];
    [del.window addSubview:dragManagerView];
    
    dragManagerView.originalDragViewReference = commonTaskDropdownSubview;
    
    commonTaskDropdownSubview.draggingDelegate = dragManagerView;
    
    UITouch *touch = [theSet anyObject];
    CGPoint currentPosition = [touch locationInView:touch.window];
    dragManagerView.originalRect = CGRectMake(currentPosition.x - dragManagerView.originalDragViewReference.frame.size.width / 2, currentPosition.y - dragManagerView.originalDragViewReference.frame.size.height / 2, dragManagerView.originalDragViewReference.frame.size.width, dragManagerView.originalDragViewReference.frame.size.height);
    
    
}

-(void)touchesDidMoveWithSet:(NSSet *)theSet withEvent:(UIEvent *)theEvent
{
    
    NSLog(@"do implement %@ touches did move with set", self);
    
    
    /*
    if (self.draggingView == nil)
    {
        self.draggingView = [[CommonTaskDropdownSubview alloc] initWithFrame:self.originalDragViewReference.frame];
        [draggingView loadViewWithCommentEventContainer:self.originalDragViewReference.commonEventContainer];
        [self addSubview:draggingView];
    }
    

    
    UITouch *touch = [theSet anyObject];
    CGPoint currentPosition = [touch locationInView:touch.window];
    
    self.draggingView.frame = CGRectMake(currentPosition.x - (originalRect.size.width * sizeFactor / 2), currentPosition.y - (originalRect.size.height * sizeFactor / 2), originalRect.size.width * sizeFactor, originalRect.size.height * sizeFactor);

    self.draggingView.titleLabel.frame = CGRectMake(0, 0, self.draggingView.frame.size.width, self.draggingView.frame.size.height);
    
    CalendarDayView *selectedDayView = [self draggedToCalendarDayViewWithTouchSet:theSet];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppViewController *appViewController = delegate.appController;
    MainViewController *calendarRootViewController = appViewController.mainViewController;
 
    if (selectedDayView != nil)
        [calendarRootViewController dayViewHovered:selectedDayView];
    

    
    
//    NSLog(@"selectedDayView: %@", selectedDayView);
 */
}

-(void)touchesComplete
{
    self.originalDragViewReference.parentScrollview.scrollEnabled = YES;
    [self.draggingView removeFromSuperview];
    [self removeFromSuperview];
}




-(void)touchesDidEndWithSet:(NSSet *)theSet withEvent:(UIEvent *)theEvent
{
    CalendarDayView *selectedDayView = [self draggedToCalendarDayViewWithTouchSet:theSet];
    [self handleSelectedView:selectedDayView];
}

-(void)handleSelectedView:(CalendarDayView *)theView
{
    NSLog(@"DO IMPLEMENT %@ handleSelectedView", self);
    /*
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppViewController *appViewController = delegate.appController;
    MainViewController *calendarRootViewController = appViewController.mainViewController;
    
    if (theView != nil)
    {
        if (theView == self.trashImageView)
            [calendarRootViewController callDeleteCommonEventContainerWithCommonEventContainer:self.originalDragViewReference.commonEventContainer];
        else
            [calendarRootViewController callAddEventPopupWithCommonEventContainer:self.originalDragViewReference.commonEventContainer withCalendarDayView:theView];
        
        [self touchesComplete];
    }
    else
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.35];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(touchesComplete)];
        self.draggingView.frame = self.originalRect;
        [UIView commitAnimations];
    }
     
     */
}

-(CalendarDayView *)draggedToCalendarDayViewWithTouchSet:(NSSet *)theSet
{
    NSLog(@"DO IMPLEMENT %@, draggedToCalendarDayViewWithTouchSet", self);
    /*
    UITouch *touch = [theSet anyObject];
    
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    AppViewController *appViewController = delegate.appController;
    MainViewController *calendarRootViewController = appViewController.mainViewController;
    ContentContainerViewController *calendarViewController = calendarRootViewController.contentContainerViewController;
    CalendarMonthScrollViewController *calendarMonthScrollViewController = calendarViewController.calendarMonthScrollViewController;
    
    UIScrollView *calendarMonthScrollView = calendarMonthScrollViewController.theScrollView;
    float yOffset = calendarMonthScrollView.contentOffset.y;
    CGPoint currentPosition = [touch locationInView:calendarMonthScrollView];
    

    CalendarMonthView *topViewInScope = calendarMonthScrollViewController.currentMonthDisplayedView;
    CalendarDayView *selectedDayView = nil;
    
    NSDictionary *topViewDaysDictionary = topViewInScope.calendarDayViewDictionary;
    
    NSArray *keysArray = [topViewDaysDictionary allKeys];
    NSMutableArray *viewsArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i < [keysArray count]; i++)
        [viewsArray addObject:[topViewDaysDictionary objectForKey:[keysArray objectAtIndex:i]]];
    
    
    
    for (int i = 0; i < [viewsArray count]; i++)
    {
        CalendarDayView *dayView = [viewsArray objectAtIndex:i];
        CGRect dayViewFrame = CGRectMake(dayView.frame.origin.x, dayView.frame.origin.y + yOffset - (yOffset - topViewInScope.frame.origin.y), dayView.frame.size.width, dayView.frame.size.height);
        
        if (currentPosition.x > dayViewFrame.origin.x && currentPosition.x < dayViewFrame.origin.x + dayViewFrame.size.width)
            if (currentPosition.y > dayViewFrame.origin.y && currentPosition.y < dayViewFrame.origin.y + dayViewFrame.size.height)
                selectedDayView = dayView;
        
    }
    
    CGRect trashRect = CGRectMake(self.trashImageView.frame.origin.x, 395, self.trashImageView.frame.size.width, 461);
    
    currentPosition.y -= topViewInScope.frame.origin.y;    
    
    if (currentPosition.x > trashRect.origin.x && currentPosition.x < trashRect.origin.x + trashRect.size.width)
        if (currentPosition.y > trashRect.origin.y && currentPosition.y < trashRect.origin.y + trashRect.size.height)
        {
            selectedDayView = self.trashImageView;
        }

    
    
    return selectedDayView;
     */
    
    return nil;
}
@end
