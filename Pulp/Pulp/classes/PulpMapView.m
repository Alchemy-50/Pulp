//
//  PulpMapView.m
//  Calendar
//
//  Created by Alchemy50 on 7/3/14.
//
//

#import "PulpMapView.h"
#import "DailyView.h"
@implementation PulpMapView

@synthesize userPositionCoordinate;
@synthesize desiredLocationCoordinate;
@synthesize isInitialized;
@synthesize routeLine;
@synthesize callbackDailyView;
@synthesize destinationTitle;
@synthesize destinationSubtitle;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
    }
    return self;
}

-(void)loadAnnotations
{
    if (self.userLocationAnnotation == nil)
    {
        self.userLocationAnnotation = [[MKPointAnnotation alloc]init];
        self.userLocationAnnotation.coordinate = self.userLocationAnnotation.coordinate;
        [self.userLocationAnnotation setTitle:@"You Are Here"];
        [self addAnnotation:self.userLocationAnnotation];
        
        self.showsUserLocation = YES;
    }
    
    if (self.destinationAnnotation == nil)
    {
        self.destinationAnnotation = [[MKPointAnnotation alloc]init];
        self.destinationAnnotation.coordinate = desiredLocationCoordinate;
        self.destinationAnnotation.title = self.destinationTitle;
        self.destinationAnnotation.subtitle = self.destinationSubtitle;
        [self addAnnotation:self.destinationAnnotation];
    }
   
}

-(void)positionUpdatedWithLocation:(CLLocation *)latestLocation
{
    self.delegate = self;
    
    self.userLocationAnnotation.coordinate = latestLocation.coordinate;
    
    [self loadAnnotations];
    
    if (!self.isInitialized)
    {
        [self setCenterCoordinate:self.userLocationAnnotation.coordinate];
        [self zoomToFitMapAnnotations:self];
        [self zoomToFitMapAnnotations:self];
    }
    
    [self removeAnnotation:self.userLocationAnnotation];
    
    self.isInitialized = YES;
    
    [self.callbackDailyView pulpMapViewIsInitialized];
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");

    NSLog(@"self.destinationAnnotation.title: %@", self.destinationAnnotation.title);
}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
//    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:NO];
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView
            rendererForOverlay:(id < MKOverlay >)overlay
{
    MKPolylineRenderer *renderer =
    [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = [UIColor orangeColor];
    renderer.lineWidth = 6.0;
    return renderer;
}



@end
