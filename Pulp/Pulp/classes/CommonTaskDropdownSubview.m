//
//  CommonTaskDropdownSubview.m
//  Calendar
//
//  Created by Josh Klobe on 5/21/13.
//
//

#import "CommonTaskDropdownSubview.h"
#import "EventKitManager.h"
#import "CalendarDragManagerView.h"

@implementation CommonTaskDropdownSubview

@synthesize commonEventContainer, titleLabel, draggingDelegate, parentScrollview;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,frame.size.width, frame.size.height)];
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = [UIColor whiteColor];
        self.titleLabel.font = [UIFont fontWithName:@"Lato-Black" size:16];
        [self addSubview:self.titleLabel];
        
        UITapGestureRecognizer *createEventTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addEvent)];
        createEventTapGestureRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:createEventTapGestureRecognizer];
        
        // Initialization code
    }
    return self;
}

-(void)addEvent
{
    NSLog(@"addEvent");
    [CalendarDragManagerView commonEventContainerTapped:self];
}
-(void)loadViewWithCommentEventContainer:(CommonEventContainer *)theCommonEventContainer
{
    self.commonEventContainer = theCommonEventContainer;
    
    EKCalendar *calendar = [[EventKitManager sharedManager] getEKCalendarWithIdentifier:self.commonEventContainer.referenceCalendarIdentifier];    
    self.backgroundColor = [UIColor colorWithCGColor:calendar.CGColor];
    self.titleLabel.text = [self.commonEventContainer.title uppercaseString];
//    NSLog(@"F$$$$$$ theCommonEventContainer: %@", theCommonEventContainer);
}


- (void)touchesBegan: (NSSet *)touches withEvent:(UIEvent *)event {
    

    [CalendarDragManagerView beginDragWithCommonTaskDropdownSubview:self withTouchesSet:touches];
    
}

- (void)touchesMoved: (NSSet *)touches withEvent:(UIEvent *)event {
    
    if (self.draggingDelegate != nil)
        [self.draggingDelegate touchesDidMoveWithSet:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {

    if (self.draggingDelegate != nil)
        [self.draggingDelegate touchesDidEndWithSet:touches withEvent:event];
}



@end
