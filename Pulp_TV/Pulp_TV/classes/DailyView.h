//
//  DailyView.h
//  Calendar
//
//  Created by Josh Klobe on 2/25/14.
//
//

#import <UIKit/UIKit.h>
#import "Defs.h"
#import "PulpFAImageView.h"
#import "CalendarEvent.h"

@interface DailyView : UIView <UITableViewDataSource, UITableViewDelegate>
{
}


-(void)loadEvents;
-(void)unloadEvents;
-(void)refreshEvents;
-(void)pulpMapViewIsInitialized;
-(void)cellDidReturnWithLocation;
-(void)cellButtonHitWithIndexPath:(NSIndexPath *)theIndexPath;


@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) NSDate *dailyViewDate;
@property (nonatomic, retain) UITableView *theTableView;
@property (nonatomic, retain) UIImageView *emptyCountView;
@property (nonatomic, assign) BOOL eventsLoaded;
@property (nonatomic, retain) UIView *testView;

@property (nonatomic, assign) CGRect referenceMapViewFrame;
@property (nonatomic, retain) CalendarEvent *currentReferenceEvent;
@property (nonatomic, retain) UIScrollView *contentScrollView;
@property (nonatomic, assign) BOOL cellStyleClear;
@property (nonatomic, assign) BOOL suppressMaps;

@property (nonatomic, retain) PulpFAImageView *closeImageView;
@property (nonatomic, retain) PulpFAImageView *mapImageView;

@end
