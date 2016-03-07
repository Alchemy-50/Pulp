//
//  FullCalendarScrollView.m
//  Pulp_TV
//
//  Created by Josh Klobe on 3/5/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "FullCalendarScrollView.h"

@implementation FullCalendarScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(UIView *)preferredFocusedView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return self;
}

@end
