//
//  CircleView.m
//  RadialControl
//
//  Created by Josh Klobe on 6/21/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import "CircleView.h"

@implementation CircleView


@synthesize strokeColor;
@synthesize fillColor;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    if (self.strokeColor == nil)
        self.strokeColor = [UIColor colorWithRed:64.0f/255.0f green:64.0f/255.0f blue:64.0f/255.0f alpha:1];
    
    // Get the contextRef
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // Set the border width
    CGContextSetLineWidth(contextRef, 1.0);
    
    CGContextSetStrokeColorWithColor(contextRef, strokeColor.CGColor);
        
    if (self.fillColor != nil)
        CGContextSetFillColorWithColor(contextRef, fillColor.CGColor);
    
    CGContextFillEllipseInRect(contextRef, rect);
    
    // Draw the circle border
    CGContextStrokeEllipseInRect(contextRef, rect);
    
}



@end
