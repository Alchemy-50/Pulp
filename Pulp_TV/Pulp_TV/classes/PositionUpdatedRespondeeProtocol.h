//
//  PositionUpdatedRespondeeProtocol.h
//  Calendar
//
//  Created by Alchemy50 on 7/3/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol PositionUpdatedRespondeeProtocol <NSObject>

-(void)positionUpdatedWithLocation:(CLLocation *)latestLocation;

@end
