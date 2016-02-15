//
//  CenterViewController.h
//  Calendar
//
//  Created by Josh Klobe on 2/9/16.
//
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TodosViewController.h"
#import "DailyView.h"
#import "DailyTodoImageView.h"
#import "PositionUpdatedRespondeeProtocol.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUIDefines.h>
#import "EventManagerViewController.h"
#import "SidebarView.h"


@interface CenterViewController : UIViewController <UIScrollViewDelegate, PositionUpdatedRespondeeProtocol>


+ (CenterViewController *)sharedCenterViewController;

-(void)loadViews;
- (void) scrollToDate:(NSDate *)theDate;
- (void) refreshContent;
- (void) handleHourlyWeatherDataWithDictionary:(NSDictionary *)theDict;
- (void) weatherDidReturnWithDictionary:(NSDictionary *)weatherDictionary;
- (void) dailyViewHeaderButtonHit;
- (void) addButtonHit;
- (void) addButtonHeld;
- (DailyView *) getVisibleDailyView;
- (void) presentAndHideDailyViews:(BOOL)forceLoad withIndex:(unsigned long)referenceIndex;
- (void) processPositioningWithScrollView:(UIScrollView *)scrollView;
- (void) spoofAddEventWithEvent:(EKEvent *)theEvent withAction:(EKEventEditViewAction)theAction;
- (void) refreshAllDailyViews;
- (void) sidebarDidScroll:(float)theOffset;
@property (nonatomic, retain) UIScrollView *contentScrollView;
@property (nonatomic, retain) NSMutableDictionary *dayDatesDictionary;
@property (nonatomic, retain) NSMutableArray *dayDatesArray;
@property (nonatomic, assign) BOOL hasRunWeather;
@property (nonatomic, retain) DailyView *currentView;
@property (nonatomic, retain) SidebarView *centerSidebarView;
@property (nonatomic, retain) CLLocation *theLatestLocation;

@property (nonatomic, assign) int currentVisibleIndex;


@end
