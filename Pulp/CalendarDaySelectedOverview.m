//
//  CalendarDaySelectedOverview.m
//  Pulp
//
//  Created by Josh Klobe on 2/17/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "CalendarDaySelectedOverview.h"
#import "ThemeManager.h"

@interface CalendarDaySelectedOverview ()

@property (nonatomic, retain) UIColor *theColor;
@end

@implementation CalendarDaySelectedOverview


- (id)initWithFrame:(CGRect)fram
{
    self = [super initWithFrame:fram];
    
    [[ThemeManager sharedThemeManager] registerAdvisoryObject:self];
    
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}



- (void)drawRect:(CGRect)rect
{
    float insetOne = 1.7f;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    

    [self.theColor set];
    
    CGContextSetLineWidth(context, 1.25);
    CGContextStrokeEllipseInRect (context, CGRectMake(insetOne, insetOne, self.frame.size.width - 2 * insetOne, self.frame.size.height - 2 * insetOne));
    
}


-(void)adviseThemeUpdateWithPrimaryColor:(UIColor *)thePrimaryColor withSecondaryColor:(UIColor *)theSecondaryColor
{
    self.theColor = theSecondaryColor;
    [self setNeedsDisplay];
    [self setNeedsLayout];
    
}



@end
