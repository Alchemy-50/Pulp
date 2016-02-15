//
//  RadialContainerView.h
//  Calendar
//
//  Created by Josh Klobe on 6/24/13.
//
//

#import <UIKit/UIKit.h>
#import "CircleView.h"

#define CONTAINER_VIEW_TIME_TYPE_HOURS 0
#define CONTAINER_VIEW_TIME_TYPE_MINUTES 1


@class RadialEventDateController;
@interface RadialContainerView : UIView
{
    RadialEventDateController *delegate;
    
    CircleView *outerCircleView;
    CircleView *innerCircleView;
    
    CircleView *draggableCircle;
    NSMutableArray *radialArray;
    NSMutableArray *timeViewsArray;
    
    int timeType;
}


- (id) initWithFrame:(CGRect)frame withSpacingFactor:(float)factor withRingFillColor:(UIColor *)theFillColor;
- (void) loadWithLabelsArray:(NSArray *)labelsArray;
- (void) setTimeCircleWithString:(NSString *)theString;

@property (nonatomic, retain) RadialEventDateController *delegate;

@property (nonatomic, retain) CircleView *outerCircleView;
@property (nonatomic, retain) CircleView *innerCircleView;

@property (nonatomic, retain) CircleView *draggableCircle;

@property (nonatomic, retain) NSMutableArray *radialArray;
@property (nonatomic, retain) NSMutableArray *timeViewsArray;

@property (nonatomic, assign) int timeType;

@end
