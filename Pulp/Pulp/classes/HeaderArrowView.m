//
//  HeaderArrowView.m
//  Calendar
//
//  Created by Alchemy50 on 7/14/14.
//
//

#import "HeaderArrowView.h"

@implementation HeaderArrowView

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
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(ctx);
    CGContextMoveToPoint   (ctx, 0, 0);
    CGContextAddLineToPoint(ctx, self.frame.size.width, self.frame.size.height / 2);
    CGContextAddLineToPoint(ctx, 0, self.frame.size.height);
    CGContextAddLineToPoint(ctx, 0, 0);
    CGContextClosePath(ctx);
    
    CGContextSetRGBFillColor(ctx, 1, 1, 1, 1);
    CGContextFillPath(ctx);
}


@end
