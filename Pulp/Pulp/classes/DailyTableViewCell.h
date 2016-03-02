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
#import "CalendarEvent.h"


@class DailyView;

@interface DailyTableViewCell : UITableViewCell <UITextFieldDelegate>
{
    
}

+ (float) getDesiredCellHeightWithEvent:(CalendarEvent *)theEvent withIndexPath:(NSIndexPath *)indexPath withSuppressMaps:(BOOL)doSuppressMaps;
- (void) loadViews;
- (void) loadWithEvent:(CalendarEvent *)theEvent;
- (void) setFieldsWithEvent:(CalendarEvent *)theEvent;
- (void) eventLocationDataReturned;
- (void) setLastRowStyle:(BOOL)isLastRow;
- (void) loadCoverButton;
- (void) mapTapped;

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

@property (nonatomic, retain) CalendarEvent *referenceEvent;


@property (nonatomic, retain) UIButton *mapViewButton;

@property (nonatomic, retain) UIView *lastRowView;
@property (nonatomic, assign) BOOL cellStyleClear;
@property (nonatomic, assign) BOOL suppressMaps;

@end
