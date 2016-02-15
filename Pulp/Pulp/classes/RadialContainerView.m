//
//  RadialContainerView.m
//  Calendar
//
//  Created by Josh Klobe on 6/24/13.
//
//

#import "RadialContainerView.h"
#import "TimeView.h"
#import "EventManagerViewController.h"

@interface PointIndexObject : NSObject

@property (nonatomic, assign) CGPoint indexPoint;
@property (nonatomic, assign) int indexPosition;

@end

@implementation PointIndexObject
@end


@implementation RadialContainerView

@synthesize delegate;

@synthesize outerCircleView;
@synthesize innerCircleView;

@synthesize draggableCircle;
@synthesize radialArray;
@synthesize timeViewsArray;
@synthesize timeType;


static float draggableSize = 15;

- (id)initWithFrame:(CGRect)frame withSpacingFactor:(float)factor withRingFillColor:(UIColor *)theFillColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.outerCircleView = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.outerCircleView.fillColor = theFillColor;
        self.outerCircleView.backgroundColor = [UIColor clearColor];
        [self addSubview:outerCircleView];
        
        self.innerCircleView = [[CircleView alloc] initWithFrame:CGRectMake(self.frame.size.width * factor, self.frame.size.height * factor, self.frame.size.width - (2 * self.frame.size.width * factor), self.frame.size.height - (2 * self.frame.size.height * factor))];
        self.innerCircleView.backgroundColor = [UIColor clearColor];
        [self addSubview:innerCircleView];
        
        
        UIColor *yellowColor = [UIColor colorWithRed:255.0f/255.0f green:187.0f/255.0f blue:0 alpha:1];
        
        self.draggableCircle = [[CircleView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - draggableSize / 2, self.frame.size.height / 2 - self.frame.size.height / 2 + draggableSize / 4, draggableSize, draggableSize)];
        self.draggableCircle.fillColor = yellowColor;
        self.draggableCircle.strokeColor = yellowColor;
        self.draggableCircle.backgroundColor = [UIColor clearColor];
        [self addSubview:self.draggableCircle];

        
        
    }
    return self;
}

-(void)loadWithLabelsArray:(NSArray *)labelsArray
{
    
    self.timeViewsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSUInteger max = [labelsArray count];
    for (int i = 0; i < max; i++)
    {
        
        float cx = self.outerCircleView.frame.origin.x + self.outerCircleView.frame.size.width / 2;
        float cy = self.outerCircleView.frame.origin.y + self.outerCircleView.frame.size.height / 2;
        float r = self.outerCircleView.frame.size.height / 2 - draggableSize / 1.35;
        
        float rads = i * ((2 * M_PI) / max) + (9 * ((2 * M_PI) / max));
        
        //float rads = degrees  * 0.0174532925;
        float x = cx + r * cos(rads);
        float y = cy + r * sin(rads);
        
        TimeView *theView = [[TimeView alloc] initWithFrame:CGRectMake(x - draggableSize / 2, y - draggableSize / 2, draggableSize, draggableSize)];
        [self addSubview:theView];
        
        theView.label.text = [labelsArray objectAtIndex:i];
        
        [self.timeViewsArray addObject:theView];
        
    }
    
    max = 360;
    
    self.radialArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (int i = 0; i < max; i++)
    {
        float cx = self.outerCircleView.frame.origin.x + self.outerCircleView.frame.size.width / 2;
        float cy = self.outerCircleView.frame.origin.y + self.outerCircleView.frame.size.height / 2;
        float r = self.outerCircleView.frame.size.height / 2 - draggableSize / 1.35;
        
        float rads = i * ((2 * M_PI) / max) + (9 * ((2 * M_PI) / max));
        
        //float rads = degrees  * 0.0174532925;
        float x = cx + r * cos(rads);
        float y = cy + r * sin(rads);
        
        [self.radialArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
    }

    
}

-(void)manageTouch:(CGPoint )touchPoint
{
    
    if (touchPoint.x > self.outerCircleView.frame.origin.x)
        if (touchPoint.x < self.outerCircleView.frame.origin.x + self.outerCircleView.frame.size.width)
            if (touchPoint.y > self.outerCircleView.frame.origin.y)
                if (touchPoint.y < self.outerCircleView.frame.origin.y + self.outerCircleView.frame.size.height)
                {
                    PointIndexObject *pointIndexObject = [self getClosestTrackPointFromTouchPoint:touchPoint withPointsArray:self.radialArray];
                    self.draggableCircle.frame = CGRectMake(pointIndexObject.indexPoint.x - self.draggableCircle.frame.size.width / 2, pointIndexObject.indexPoint.y - self.draggableCircle.frame.size.height / 2, self.draggableCircle.frame.size.width, self.draggableCircle.frame.size.height);
                }
    
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    RadialEventDateController *parent = delegate;
    AddEditEventViewController *controller = parent.delegate;
    [controller radialDidBeginDrag];
    
    UITouch *theTouch = [[touches allObjects] objectAtIndex:0];
    [self manageTouch:[theTouch locationInView:self]];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *theTouch = [[touches allObjects] objectAtIndex:0];
    [self manageTouch:[theTouch locationInView:self]];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    RadialEventDateController *parent = delegate;
    AddEditEventViewController *controller = parent.delegate;
    [controller radialDidEndDrag];

    
    UITouch *theTouch = [[touches allObjects] objectAtIndex:0];
    
    PointIndexObject *pointIndexObject = [self getClosestTrackPointFromTouchPoint:[theTouch locationInView:self] withPointsArray:self.timeViewsArray];
            
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.15];
    [self setDraggableCirclePositionWithCGPoint:pointIndexObject.indexPoint];
    [UIView commitAnimations];
    
    TimeView *theTimeView = [self.timeViewsArray objectAtIndex:pointIndexObject.indexPosition];
    if (self.timeType == CONTAINER_VIEW_TIME_TYPE_HOURS)
        [self.delegate hourDidChangeWithString:theTimeView.label.text];
    else
        [self.delegate minuteDidChangeWithString:theTimeView.label.text];
}

- (void) setTimeCircleWithString:(NSString *)theString
{
    for (int i = 0; i < [self.timeViewsArray count]; i++)
        if ([((TimeView *)[self.timeViewsArray objectAtIndex:i]).label.text intValue] == [theString intValue])
            [self setDraggableCirclePositionWithCGPoint:((TimeView *)[self.timeViewsArray objectAtIndex:i]).frame.origin];
}

-(void)setDraggableCirclePositionWithCGPoint:(CGPoint)thePoint
{
    self.draggableCircle.frame = CGRectMake(thePoint.x, thePoint.y, self.draggableCircle.frame.size.width, self.draggableCircle.frame.size.height);
}


-(PointIndexObject *)getClosestTrackPointFromTouchPoint:(CGPoint)touchPoint withPointsArray:(NSArray *)theArray
{
    PointIndexObject *obj = [[PointIndexObject alloc] init];
    
    float distance = 100000;
       
    for (int i = 0; i < [theArray count]; i++)
    {
        CGPoint arrayPoint;
        
        if ([[theArray objectAtIndex:i] isKindOfClass:[TimeView class]])
        {
            TimeView *theView = [theArray objectAtIndex:i];
            arrayPoint = CGPointMake(theView.frame.origin.x, theView.frame.origin.y);
        }
        else
            arrayPoint = [[theArray objectAtIndex:i] CGPointValue];
        
        double thisDistance = sqrt(pow((touchPoint.x - arrayPoint.x), 2) + pow((touchPoint.y - arrayPoint.y), 2));
        
        if (thisDistance < distance)
        {
            distance = thisDistance;
            
            obj.indexPosition = i;
            obj.indexPoint = arrayPoint;
        }
    }

    return obj;
    
}

@end
