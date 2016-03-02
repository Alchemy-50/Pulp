//
//  ContainerMapView.h
//  Pulp
//
//  Created by Josh Klobe on 2/17/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <MapKit/MapKit.h>

@class DailyTableViewCell;
@interface CellContainerMapView : MKMapView


-(void)loadWithDictionary:(NSDictionary *)dict;
-(BOOL)isReferenceDictionaryEqualToDictionary:(NSDictionary *)dict;

@property (nonatomic, retain) DailyTableViewCell *parentCell;

@end
