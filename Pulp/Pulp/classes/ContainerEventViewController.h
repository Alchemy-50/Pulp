//
//  ContainerEventViewController.h
//  Calendar
//
//  Created by Josh Klobe on 3/13/14.
//
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>
#import "EventKitManager.h"
#import <EventKitUI/EventKitUI.h>

@class EventManagerViewController;
@interface ContainerEventViewController : UINavigationController <EKEventEditViewDelegate, EKEventViewDelegate>
{
    EKEvent *theEvent;

    UIView *eventViewContainer;
    EKEventEditViewController *eventEditController;
    EventManagerViewController *parentController;

    EKEventViewController *eKEventViewController;
    
}
@property (nonatomic, retain) EKEvent *theEvent;
@property (nonatomic, retain) UIView *eventViewContainer;
@property (nonatomic, retain) EKEventEditViewController *eventEditController;

@property (nonatomic, retain) EventManagerViewController *parentController;

@property (nonatomic, retain) EKEventViewController *eKEventViewController;


@end
