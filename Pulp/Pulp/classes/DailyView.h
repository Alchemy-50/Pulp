//
//  DailyView.h
//  Calendar
//
//  Created by Josh Klobe on 2/25/14.
//
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PulpMapView.h"
#import <EventKit/EventKit.h>



@interface DailyView : UIView <UITableViewDataSource, UITableViewDelegate>
{
}


-(void)loadEvents;
-(void)unloadEvents;
-(void)mapTappedWithMapView:(MKMapView *)tappedMapView withEvent:(EKEvent *)theEvent;
-(void)pulpMapViewIsInitialized;
-(void)cellDidReturnWithLocation;
-(void)spoofArrayWithEvent:(EKEvent *)theEvent;
-(void)cellButtonHitWithIndexPath:(NSIndexPath *)theIndexPath;


@property (nonatomic, retain) NSMutableArray *eventsArray;
@property (nonatomic, retain) NSDate *dailyViewDate;
@property (nonatomic, retain) UITableView *theTableView;
@property (nonatomic, retain) UIImageView *emptyCountView;
@property (nonatomic, assign) BOOL eventsLoaded;
@property (nonatomic, retain) UIView *testView;
@property (nonatomic, retain) PulpMapView *expandedMapView;
@property (nonatomic, assign) CGRect referenceMapViewFrame;
@property (nonatomic, retain) EKEvent *currentReferenceEvent;
@property (nonatomic, retain) UIScrollView *contentScrollView;
@property (nonatomic, assign) BOOL cellStyleClear;

@end
