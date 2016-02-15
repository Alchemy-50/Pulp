//
//  CalendarTasksDropdownView.m
//  Calendar
//
//  Created by Josh Klobe on 5/21/13.
//
//

#import "CalendarTasksDropdownView.h"
#import "CommonTaskDropdownSubview.h"
#import "CommonEventsManager.h"
#import "EventKitManager.h"

@implementation CalendarTasksDropdownView

static CalendarTasksDropdownView *theStaticCalendarTasksDropdownView;

@synthesize theScrollView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        self.backgroundColor = [UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1];
        
        self.theScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
        self.theScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.theScrollView];
        
        
        theStaticCalendarTasksDropdownView = self;
    }
    return self;
}

+(CalendarTasksDropdownView *)getSharedCalendarTasksDropdownView
{
    return theStaticCalendarTasksDropdownView;
}


-(void)loadCommonTaskSubviews
{
    NSLog(@"loadCommonTaskSubviews called");
    
    NSArray *currentSubviewsArray = [NSArray arrayWithArray:self.theScrollView.subviews];
    
    for (int i = 0; i < [currentSubviewsArray count]; i++)
        [[currentSubviewsArray objectAtIndex:i] removeFromSuperview];
 
    
    NSMutableArray *commonTasksArray = [NSMutableArray arrayWithArray:[[CommonEventsManager sharedEventsManager] getAllCommonTasks]];
    
    
    CommonEventContainer *newContainer = nil;
    CommonEventContainer *todoContainer = nil;
 
    for (int i = 0; i < [commonTasksArray count]; i++)
    {
        CommonEventContainer *theContainer = [commonTasksArray objectAtIndex:i];
        if ([[theContainer.title lowercaseString] compare:@"todo"] == NSOrderedSame)
            todoContainer = theContainer;
        else if ([[theContainer.title lowercaseString] compare:@"new"] == NSOrderedSame)
            newContainer = theContainer;
    }
    
    if (newContainer != nil)
    {
        [commonTasksArray removeObject:newContainer];
        [commonTasksArray insertObject:newContainer atIndex:0];
    }
    if (todoContainer != nil)
    {
        [commonTasksArray removeObject:todoContainer];
        [commonTasksArray insertObject:todoContainer atIndex:0];
    }
    
    float height = self.frame.size.height * .8;

    float spacer = 4.2;
    
    
    float lastWidth = 0;
    
    for (int i = 0; i < [commonTasksArray count]; i++)
    {
        CommonEventContainer *commonEventContainer = [commonTasksArray objectAtIndex:i];
        
        UIFont *subviewFont = [UIFont fontWithName:@"Lato-Black" size:16];
        
        CGSize stringSize = [commonEventContainer.title sizeWithAttributes:@{ NSFontAttributeName : subviewFont }];
        
        CommonTaskDropdownSubview *subview = [[CommonTaskDropdownSubview alloc] initWithFrame:CGRectMake(spacer + lastWidth, (self.frame.size.height - height) / 2, stringSize.width + 15 , height)];
        subview.parentScrollview = self.theScrollView;
        [subview loadViewWithCommentEventContainer:[commonTasksArray objectAtIndex:i]];
        [self.theScrollView addSubview:subview];
        [subview release];
        
        self.theScrollView.contentSize = CGSizeMake(subview.frame.origin.x + subview.frame.size.width + 7, 0);
        
        lastWidth = subview.frame.origin.x + subview.frame.size.width;
    }

    
    if (self.theScrollView.contentSize.width < self.theScrollView.frame.size.width)
        self.theScrollView.contentSize = CGSizeMake(self.theScrollView.frame.size.width + 10, 0);
    

}



@end
