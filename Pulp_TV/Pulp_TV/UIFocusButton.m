//
//  UIFocusButton.m
//  Pulp_TV
//
//  Created by Josh Klobe on 3/5/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "UIFocusButton.h"
#import "CalendarDayView.h"

@implementation UIFocusButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)didUpdateFocusInContext:(UIFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"self: %@", self);
    NSLog(@"context.previousFocusView: %@", context.previouslyFocusedView);
    NSLog(@"context.nextFocusView: %@", context.nextFocusedView);
    
    if (self == context.nextFocusedView)
    {
        if (self.referenceParentView != nil)
            [self.referenceParentView focusChanged:YES];
    }
    else
    {
        if (self.referenceParentView != nil)
            [self.referenceParentView focusChanged:NO];
    }
    
    
    NSLog(@" ");
    NSLog(@" ");
    NSLog(@" ");
    
    
}



@end
