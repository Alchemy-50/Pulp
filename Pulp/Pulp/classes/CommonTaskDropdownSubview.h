//
//  CommonTaskDropdownSubview.h
//  Calendar
//
//  Created by Josh Klobe on 5/21/13.
//
//

#import <UIKit/UIKit.h>
#import "CommonEventContainer.h"

@class CalendarDragManagerView;

@interface CommonTaskDropdownSubview : UIView
{
    UILabel *titleLabel;
    CommonEventContainer *commonEventContainer;
    CalendarDragManagerView *draggingDelegate;
    
    UIScrollView *parentScrollview;
}

-(void)loadViewWithCommentEventContainer:(CommonEventContainer *)theCommonEventContainer;


@property (nonatomic, retain) UILabel *titleLabel;
@property (nonatomic, retain) CommonEventContainer *commonEventContainer;
@property (nonatomic, retain) CalendarDragManagerView *draggingDelegate;

@property (nonatomic, retain) UIScrollView *parentScrollview;
@end
