//
//  CenterSidebarView.m
//  Calendar
//
//  Created by Josh Klobe on 2/9/16.
//
//

#import "SidebarView.h"
#import "ThemeManager.h"
#import "SidebarInstanceView.h"
#import "PulpFAImageView.h"
#import "AppDelegate.h"

#import "AppSettingsViewController.h"
#import "SidebarButtonView.h"
#import "DailyViewController.h"


@interface SidebarView ()
@property (nonatomic, retain) UIScrollView *containerScrollView;

@property (nonatomic, retain) SidebarButtonView *chevronButtonView;
@property (nonatomic, retain) SidebarButtonView *checkSquareButtonView;
@property (nonatomic, retain) SidebarButtonView *calendarButtonView;
@property (nonatomic, retain) SidebarButtonView *cogButtonView;


@property (nonatomic, retain) UIButton *cogButton;
@property (nonatomic, assign) BOOL isDraggingHere;
@end




@implementation SidebarView


static SidebarView *theStaticSidebarView;

+(SidebarView *)sharedSidebarView
{
    return theStaticSidebarView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        theStaticSidebarView = self;
        [[ThemeManager sharedThemeManager] registerPrimaryObject:self];
        self.referencePointContainerDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        
        [self initialize];
    }
    
    return self;
}


-(void)initialize
{
    self.containerScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.containerScrollView.backgroundColor = [UIColor clearColor];
    self.containerScrollView.delegate = self;
    self.containerScrollView.scrollEnabled = NO;
    [self addSubview:self.containerScrollView];
    
    
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    
    SidebarInstanceView *sidebarInstanceView = nil;
    
    float lastY = 0.0f;
    for (int i = -365; i < 365; i++)
    {
        [comps setDay:i];
        
        NSDate *theDate = [gregorian dateByAddingComponents:comps  toDate:[NSDate date] options:0];
        
        sidebarInstanceView = [[SidebarInstanceView alloc] initWithFrame:CGRectMake(0, lastY, self.containerScrollView.frame.size.width, self.containerScrollView.frame.size.height)];
        [sidebarInstanceView loadWithDate:theDate withReferenceIndex:i];
        [self.containerScrollView addSubview:sidebarInstanceView];
        
        [self.referencePointContainerDictionary setObject:sidebarInstanceView forKey:[NSNumber numberWithFloat:sidebarInstanceView.frame.origin.y]];
        
        
        self.containerScrollView.contentSize = CGSizeMake(3, sidebarInstanceView.frame.origin.y + sidebarInstanceView.frame.size.height);
        
        lastY = sidebarInstanceView.frame.origin.y + sidebarInstanceView.frame.size.height;
    }

    
    float height = self.frame.size.width * .65;
    float spacer = 10;
    
    self.chevronButtonView = [[SidebarButtonView alloc] initWithFrame:CGRectMake(0, self.frame.size.height * .7, self.frame.size.width, height)];
    [self addSubview:self.chevronButtonView];
    [self.chevronButtonView loadWithType:SIDEBAR_BUTTON_TYPE_CHEVRON];
    

    self.checkSquareButtonView = [[SidebarButtonView alloc] initWithFrame:CGRectMake(0, self.chevronButtonView.frame.origin.y + self.chevronButtonView.frame.size.height + spacer, self.chevronButtonView.frame.size.width, self.chevronButtonView.frame.size.height)];
    [self addSubview:self.checkSquareButtonView];
    [self.checkSquareButtonView loadWithType:SIDEBAR_BUTTON_TYPE_CHECKSQUARE];
    
    
    self.calendarButtonView = [[SidebarButtonView alloc] initWithFrame:CGRectMake(0, self.checkSquareButtonView.frame.origin.y + self.checkSquareButtonView.frame.size.height + spacer, self.chevronButtonView.frame.size.width, self.chevronButtonView.frame.size.height)];
    [self addSubview:self.calendarButtonView];
    [self.calendarButtonView loadWithType:SIDEBAR_BUTTON_TYPE_CALENDAR];
    
    
    self.cogButtonView = [[SidebarButtonView alloc] initWithFrame:CGRectMake(0, self.calendarButtonView.frame.origin.y + self.calendarButtonView.frame.size.height + spacer, self.chevronButtonView.frame.size.width, self.chevronButtonView.frame.size.height)];
    [self addSubview:self.cogButtonView];
    [self.cogButtonView loadWithType:SIDEBAR_BUTTON_TYPE_COG];
}

-(void)updateButtonStateWithSelected:(int)selectedStateInt withShowEnabled:(BOOL)showEnabled
{
    if (!showEnabled)
        [SidebarButtonView toggleButtonStatesWithSelectedButton:nil];
    else if (selectedStateInt == SECONDARY_VIEW_STATE_CALENDAR)
        [SidebarButtonView toggleButtonStatesWithSelectedButton:self.calendarButtonView];
    else if (selectedStateInt == SECONDARY_VIEW_STATE_TODOS)
        [SidebarButtonView toggleButtonStatesWithSelectedButton:self.checkSquareButtonView];
    
}

-(void)chevronButtonHit
{
    NSLog(@"chevronButtonHit");
//    [[DailyViewController sharedCenterViewController] scrollToDate:[NSDate date]];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    float fmod1 = fmod(self.containerScrollView.contentOffset.y, self.containerScrollView.frame.size.height);
    
    float theAlpha = 0.0f;
    if (fmod1 < 1.0f)
    {
        theAlpha = 1.0f;
    }
    
    if (self.chevronButtonView.alpha != theAlpha)
    {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.05];
        [UIView setAnimationDelegate:self];
        self.chevronButtonView.alpha = theAlpha;
        self.checkSquareButtonView.alpha = theAlpha;
        self.calendarButtonView.alpha = theAlpha;
        self.cogButtonView.alpha = theAlpha;
        [UIView commitAnimations];
    }
    
    if (self.isDraggingHere)
    {
    //    [[CenterViewController sharedCenterViewController] sidebarDidScroll:scrollView.contentOffset.y / scrollView.contentSize.height];
    }
    
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.isDraggingHere = YES;
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    self.isDraggingHere = NO;
}


-(void)dailyScrollViewDidScrollWithOffset:(float)theOffset
{
    [self.containerScrollView setContentOffset:CGPointMake(0, theOffset * self.containerScrollView.contentSize.height)];
}

-(void)updateWeatherData
{
    NSArray *subviewsArray = [self.containerScrollView subviews];
    for (int i = 0; i < [subviewsArray count]; i++)
    {
        SidebarInstanceView *theView = [subviewsArray objectAtIndex:i];
        if ([theView isKindOfClass:[SidebarInstanceView class]])
            [theView updateWeather];
    }
}



@end
