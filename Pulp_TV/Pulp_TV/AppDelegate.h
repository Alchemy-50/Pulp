//
//  AppDelegate.h
//  Pulp_TV
//
//  Created by Josh Klobe on 3/2/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>





+ (AppDelegate *)sharedDelegate;

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, retain) MainViewController *mainViewController;
@property (nonatomic, retain) NSMutableArray *locationDelegateRespondeesArray;
@property (nonatomic, assign) BOOL locationHasSucceeded;



@end

