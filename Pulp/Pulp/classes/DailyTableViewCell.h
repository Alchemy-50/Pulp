//
//  DailyTableViewCell.h
//  Calendar
//
//  Created by Josh Klobe on 7/6/13.
//
//

#import <UIKit/UIKit.h>
#import "EventKitManager.h"
#import "DailyIconView.h"
#import <MapKit/MapKit.h>


@class DailyView;

@interface DailyTableViewCell : UITableViewCell <UITextFieldDelegate>
{
    
}

+ (float) getDesiredCellHeightWithEvent:(EKEvent *)theEvent withIndexPath:(NSIndexPath *)indexPath;
- (void) loadViews;
- (void) loadWithEvent:(EKEvent *)theEvent;
- (void) setFieldsWithEvent:(EKEvent *)theEvent;
- (void) eventLocationDataReturned;
- (void) setLastRowStyle:(BOOL)isLastRow;
-(void)loadCoverButton;

@property (nonatomic, retain) DailyView *parentView;

@property (nonatomic, retain) UIView *stripeView;

@property (nonatomic, retain) UILabel *startTimeLabel;
@property (nonatomic, retain) UILabel *amPMLabel;
@property (nonatomic, retain) UILabel *durationLabel;
@property (nonatomic, retain) UILabel *eventTitleLabel;
@property (nonatomic, retain) UILabel *locationLabel;
@property (nonatomic, retain) UILabel *allDayLabel;
@property (nonatomic, retain) UIView *allDayBackgroundView;
@property (nonatomic, retain) UILabel *weatherLabel;
@property (nonatomic, retain) UIView *dividerView;

@property (nonatomic, retain) NSIndexPath *theIndexPath;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSCalendar *referenceCalendar;
@property (nonatomic, assign) float insetValue;

@property (nonatomic, retain) EKEvent *referenceEvent;

@property (nonatomic, retain) MKMapView *theMapView;

@property (nonatomic, retain) UIButton *mapViewButton;

@property (nonatomic, retain) UIView *lastRowView;
@property (nonatomic, assign) BOOL cellStyleClear;

@end
