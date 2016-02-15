//
//  PulpMapView.h
//  Calendar
//
//  Created by Alchemy50 on 7/3/14.
//
//

#import <MapKit/MapKit.h>
#import "PositionUpdatedRespondeeProtocol.h"

@class DailyView;

@interface PulpMapView : MKMapView <MKMapViewDelegate,  PositionUpdatedRespondeeProtocol>


-(void)loadAnnotations;
@property (nonatomic, retain) DailyView *callbackDailyView;

@property (nonatomic) CLLocationCoordinate2D userPositionCoordinate;
@property (nonatomic) CLLocationCoordinate2D desiredLocationCoordinate;

@property (nonatomic, retain) MKPointAnnotation *userLocationAnnotation;
@property (nonatomic, retain) MKPointAnnotation *destinationAnnotation;
@property (nonatomic, assign) BOOL isInitialized;
@property (nonatomic, retain) MKPolyline *routeLine;

@property (nonatomic, retain) NSString *destinationTitle;
@property (nonatomic, retain) NSString *destinationSubtitle;
@end
