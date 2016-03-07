//
//  TimeView.m
//  RadialControl
//
//  Created by Josh Klobe on 6/21/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "TimeView.h"

@implementation TimeView


@synthesize label;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.label = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont systemFontOfSize:self.frame.size.width-2];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.label];
        
        UIButton *theButton = [UIButton buttonWithType:UIButtonTypeCustom];
        theButton.backgroundColor = [UIColor clearColor];
        theButton.frame = CGRectMake(0,0,self.frame.size.width, self.frame.size.height);
        [theButton addTarget:self action:@selector(theButtonHit) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:theButton];
    }
    return self;
}

-(void)theButtonHit
{
    NSLog(@"self.label.text: %@", self.label.text);
}



@end
