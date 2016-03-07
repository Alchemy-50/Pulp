//
//  CoverScrollView.m
//  Calendar
//
//  Created by Josh Klobe on 2/11/16.
//
//

#import "CoverScrollView.h"

@interface CoverScrollView ()
@property (nonatomic, assign) BOOL trapHit;
@end

@implementation CoverScrollView


-(UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    self.trapHit = NO;
//    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSEnumerator *reverseE = [self.subviews reverseObjectEnumerator];
    UIView *iSubView;
    
    while ((iSubView = [reverseE nextObject])) {
        
    //    NSLog(@"iSubview: %@", iSubView);
        UIView *viewWasHit = [iSubView hitTest:[self convertPoint:point toView:iSubView] withEvent:event];
//        NSLog(@"viewWasHit: %@", viewWasHit);
  //      NSLog(@" ");
        if(viewWasHit) {
            self.trapHit = YES;
            //return viewWasHit;
        }
        
    }
    return [super hitTest:point withEvent:event];
}



-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
//    NSLog(@"%s", __PRETTY_FUNCTION__);
//    NSLog(@"trap hit: %d", self.trapHit);
    return self.trapHit;
    /*
    BOOL ret = YES;
    
    
    NSLog(@"subviews!: %@", self.subviews);
    NSLog(@"point!: %@", NSStringFromCGPoint(point));
    
    for (int i =  0; i < [self.subviews count]; i++)
    {
        UIView *subView = [self.subviews objectAtIndex:i];
        BOOL pointInsideSubview = [subView pointInside:point withEvent:event];
        NSLog(@"pointInsideSubview: %d", pointInsideSubview);
        
        
        UITouch *touch = [event.allTouches anyObject];
        CGPoint touchPoint = [touch locationInView:subView];
        NSLog(@"touchPoint!: %@", NSStringFromCGPoint(touchPoint));
        
    }
    
    
    NSLog(@"ret: %d", ret);
    NSLog(@" ");
    NSLog(@" ");
    
    
    
    return NO;
     */
     
}
@end
