//
//  UIFocusButton.m
//  Pulp_TV
//
//  Created by Josh Klobe on 3/5/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "UIFocusButton.h"
#import "FocusHandlerProtocol.h"

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
    if (self.focusDelegate != nil)        
        [self.focusDelegate focusChanged:(self == context.nextFocusedView) withReferenceObject:self.referenceObject];
}

-(void)removeFromSuperview
{
    [super removeFromSuperview];
//    NSLog(@"%s", __PRETTY_FUNCTION__);
}


@end
