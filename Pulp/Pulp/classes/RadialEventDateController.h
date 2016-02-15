//
//  RadialEventDateController.h
//  Calendar
//
//  Created by Josh Klobe on 6/24/13.
//
//

#import <UIKit/UIKit.h>
#import "CircleView.h"
#import "RadialContainerView.h"

@class AddEditEventViewController;

@interface RadialEventDateController : UIViewController
{
    AddEditEventViewController *delegate;
    
    RadialContainerView *outerRadialContainerView;
    RadialContainerView *innerRadialContainerView;
    
    UILabel *amPmLabel;
    NSDate *theDate;
}


- (void) doLoadViews;
- (void) setDialsWithDate:(NSDate *)theDate;
- (void) hourDidChangeWithString:(NSString *)hourString;
- (void) minuteDidChangeWithString:(NSString *)minuteString;


@property (nonatomic, retain) AddEditEventViewController *delegate;

@property (nonatomic, retain) RadialContainerView *outerRadialContainerView;
@property (nonatomic, retain) RadialContainerView *innerRadialContainerView;

@property (nonatomic, retain) UILabel *amPmLabel;
@property (nonatomic, retain) NSDate *theDate;

@end
