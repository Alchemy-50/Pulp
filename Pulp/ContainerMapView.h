//
//  ContainerMapView.h
//  Pulp
//
//  Created by Josh Klobe on 2/17/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface ContainerMapView : MKMapView

@property (nonatomic, retain) NSDictionary *referenceLocationDictionary;
@end
