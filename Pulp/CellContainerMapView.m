//
//  ContainerMapView.m
//  Pulp
//
//  Created by Josh Klobe on 2/17/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "CellContainerMapView.h"
#import "DailyTableViewCell.h"


@interface CellContainerMapView ()
@property (nonatomic, retain) NSDictionary *referenceDictionary;
@end

@implementation CellContainerMapView


-(void)loadWithDictionary:(NSDictionary *)dict
{
    self.referenceDictionary = [[NSDictionary alloc] initWithDictionary:dict];
    
    self.scrollEnabled = NO;
    self.userInteractionEnabled = NO;
    
    UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
    mapButton.frame = self.frame;
    mapButton.backgroundColor = [UIColor clearColor];
    [mapButton addTarget:self action:@selector(mapButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.parentCell addSubview:mapButton];
    
    
    
    NSDictionary *geometryDictionary = [self.referenceDictionary objectForKey:@"geometry"];
    NSDictionary *locationDictionary = [geometryDictionary objectForKey:@"location"];
    
    
    CLLocationCoordinate2D center;
    center.latitude = [[locationDictionary objectForKey:@"lat"] doubleValue];
    center.longitude = [[locationDictionary objectForKey:@"lng"] doubleValue];
    
    MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
    myAnnotation.coordinate = center;
    
    [self addAnnotation:myAnnotation];
    [self setCenterCoordinate:center];
    
    MKCoordinateRegion adjustedRegion = [self regionThatFits:MKCoordinateRegionMakeWithDistance(center, 800, 800)];
    adjustedRegion.span.longitudeDelta  = 0.0105;
    adjustedRegion.span.latitudeDelta  = 0.0105;
    [self setRegion:adjustedRegion animated:NO];

}


-(BOOL)isReferenceDictionaryEqualToDictionary:(NSDictionary *)dict
{
    return [self.referenceDictionary isEqualToDictionary:self.referenceDictionary];
}


-(void)mapButtonHit
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.parentCell mapTapped];
}

@end
