//
//  AppDelegate.h
//  PulpTV
//
//  Created by Josh Klobe on 2/26/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>



+ (AppDelegate *)sharedDelegate;
-(void)registerAsLocationUpdateRespondee:(id)theRespondee;
-(void)unregisterAsLocationUpdateRespondee:(id)theRespondee;
-(void)launchExternalURLString:(NSString *)theURLString;
-(void)runBackgroundTasks;

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, retain) MainViewController *mainViewController;

@property (nonatomic, retain) CLLocation *latestLocation;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, retain) NSMutableArray *locationDelegateRespondeesArray;
@property (nonatomic, assign) BOOL locationHasSucceeded;


@end

