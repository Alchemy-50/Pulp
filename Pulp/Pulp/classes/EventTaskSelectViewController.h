//
//  EventTaskSelectViewController.h
//  Calendar
//
//  Created by Josh Klobe on 6/5/14.
//
//

#import <UIKit/UIKit.h>
#import <EventKit/EventKit.h>

@class FullViewEventCreateViewController;

@interface EventTaskSelectViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>


-(void)loadTheViewsWithCalendar:(EKCalendar *)selectedCalendar;

@property (nonatomic, retain) FullViewEventCreateViewController *parentFullViewEventCreateViewController;
@property (nonatomic, retain) EKCalendar *referenceCalendar;
@property (nonatomic, retain) NSMutableArray *commonEventsArray;
@property (nonatomic, retain) UITableView *theTableView;

@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, retain) UIButton *stopButton;
@property (nonatomic, retain) UIButton *editButton;
@property (nonatomic, assign) NSInteger cellEditingIndex;
@property (nonatomic, retain) NSIndexPath *editableIndexPath;
@property (nonatomic, assign) BOOL isKeyboardShowHandled;


@end
