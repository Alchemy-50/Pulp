//
//  layeredBorderView.m
//  Calendar
//
//  Created by jay canty on 2/24/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "LayeredBorderView.h"

@implementation LayeredBorderView

@synthesize top, middle, bottom;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        top = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/4)];
        [self addSubview:top];
        middle = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2)];
        [self addSubview:middle];
        bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/4)];
        [self addSubview:bottom];
        
    }
    return self;
}


-(void) repositionViews
{
    top.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/4);
    middle.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/2);
    bottom.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height/4);
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end