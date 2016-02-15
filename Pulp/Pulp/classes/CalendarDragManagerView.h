//
//  CalendarDragManagerView.h
//  Calendar
//
//  Created by Josh Klobe on 5/21/13.
//
//

#import <UIKit/UIKit.h>
#import "CommonTaskDropdownSubview.h"


@interface CalendarDragManagerView : UIView
{
    CommonTaskDropdownSubview *originalDragViewReference;
    CommonTaskDropdownSubview *draggingView;
    
    CGRect originalRect;
    
    UIImageView *trashImageView;
    
}

+(void)commonEventContainerTapped:(CommonTaskDropdownSubview *)theContainer;
+(void)beginDragWithCommonTaskDropdownSubview:(CommonTaskDropdownSubview *)commonTaskDropdownSubview withTouchesSet:(NSSet *)touches;
-(void)touchesDidMoveWithSet:(NSSet *)theSet withEvent:(UIEvent *)theEvent;
-(void)touchesDidEndWithSet:(NSSet *)theSet withEvent:(UIEvent *)theEvent;


@property (nonatomic, retain) CommonTaskDropdownSubview *originalDragViewReference;
@property (nonatomic, retain) CommonTaskDropdownSubview *draggingView;

@property (nonatomic, assign) CGRect originalRect;

@property (nonatomic, retain) UIImageView *trashImageView;
@end
