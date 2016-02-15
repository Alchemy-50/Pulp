//
//  EventManagerViewController.m
//  Calendar
//
//  Created by Josh Klobe on 7/1/13.
//
//

#import "EventManagerViewController.h"
#import "AddEditEventViewController.h"
#import "CalendarSelectViewController.h"

#import <CoreImage/CoreImage.h>
#import <CoreVideo/CoreVideo.h>
#import <EventKit/EventKit.h>
#import "CommonEventsManager.h"
#import "ContainerEventViewController.h"
#import "CommonEventContainer.h"
#import "FullCalendarViewController.h"
#import "SettingsManager.h"

#import "AlarmNotificationHandler.h"
#import "Utils.h"

@interface EventManagerViewController ()

@property (nonatomic, retain) EKEvent *eventInScope;

@end

@implementation EventManagerViewController


@synthesize theParentViewController;
@synthesize startEndRect;
@synthesize contentView;
@synthesize theImageView;
@synthesize commonEventReferenceContainer;
@synthesize calendarReferenceDate;
@synthesize ekObjectReference;
@synthesize eventInScope;
@synthesize titleLabel;
@synthesize contactsLabel;
@synthesize dateLabel;
@synthesize timeLabel;
@synthesize locationNameLabel;
@synthesize locationAddressLabel;
@synthesize denyProcess;
@synthesize addController;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // Custom initialization
    }
    return self;
}


-(void)loadViews
{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    if (self.commonEventReferenceContainer != nil)
    {
        if ([self.commonEventReferenceContainer.commonEventID compare:[[EventKitManager sharedManager] getNewCommonEventID]] != NSOrderedSame)
        {
            self.eventInScope.allDay = self.commonEventReferenceContainer.allDay;
            

            NSCalendar *currentCalendar = [NSCalendar currentCalendar];
            NSDateComponents *startDateComponents = [currentCalendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self.commonEventReferenceContainer.startDate];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            NSString *yearMonthDayString = [dateFormatter stringFromDate:self.eventInScope.startDate];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            self.eventInScope.startDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %ld:%ld", yearMonthDayString, (long)[startDateComponents hour], (long)[startDateComponents minute]]];
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy-MM-dd"];
            yearMonthDayString = [dateFormatter stringFromDate:self.eventInScope.endDate];
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
            NSDateComponents *endDateComponents = [currentCalendar components:NSCalendarUnitHour | NSCalendarUnitMinute fromDate:self.commonEventReferenceContainer.endDate];
            self.eventInScope.endDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%@ %ld:%ld", yearMonthDayString, (long)[endDateComponents hour], (long)[endDateComponents minute]]];
            
            
            if (self.commonEventReferenceContainer.alarmsArray != nil)
            {
                for (int i = 0; i < [self.commonEventReferenceContainer.alarmsArray count]; i++)
                {
                    NSNumber *alarmTimeInterval = [self.commonEventReferenceContainer.alarmsArray objectAtIndex:i];
                    EKAlarm *theAlarm = [EKAlarm alarmWithRelativeOffset:[alarmTimeInterval doubleValue]];
                    [self.eventInScope addAlarm:theAlarm];
                }
            }
            self.eventInScope.availability = self.commonEventReferenceContainer.availibility;
        }
        else
        {
         //   self.eventInScope.calendar = nil;
        }
    }
    
    
    
    
    
    self.addController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    self.addController.eventStore = [EventKitManager sharedManager].eventStore;
    self.addController.event = self.eventInScope;
    self.addController.editViewDelegate = self;
    [self.view addSubview:self.addController.view];
    self.addController.view.frame = CGRectMake(self.addController.view.frame.origin.x, self.addController.view.frame.origin.y, [Utils getScreenWidth] - [Utils getScreenWidth] / 7, [Utils getScreenHeight]);
    
    
    //   [self performSelectorInBackground:@selector(doAdd) withObject:nil];
    
}

-(void)doAdd
{
    NSLog(@"doAdd!!!!!");
    [self.view addSubview:self.addController.view];
    
    UIView *aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    aView.backgroundColor = [UIColor redColor];
    [self.view addSubview:aView];
    
    
    
    //    self.addController.view.frame = CGRectMake(0, 25, self.addController.view.frame.size.width, self.addController.view.frame.size.height);
    
}

- (EKCalendar *)eventEditViewControllerDefaultCalendarForNewEvents:(EKEventEditViewController *)controller
{
    return nil;
}


- (void) createNewEventWithReferenceDate
{
    self.eventInScope = [[EventKitManager sharedManager] getNewEKEvent];
    
    NSString *defaultCalendarIdentifier = [[SettingsManager getSharedSettingsManager] getDefaultCalendarID];
    if (defaultCalendarIdentifier != nil)
        self.eventInScope.calendar = [[EventKitManager sharedManager] getEKCalendarWithIdentifier:defaultCalendarIdentifier];
    
    self.eventInScope.startDate = self.calendarReferenceDate;
    self.eventInScope.endDate = [self.eventInScope.startDate dateByAddingTimeInterval:60*60];
    [self loadViews];
}

- (void) createNewEventWithCommonEventContainer:(CommonEventContainer *)theCommonEventContainer withReferenceDate:(NSDate *)referenceDate
{
    self.commonEventReferenceContainer = theCommonEventContainer;
    self.calendarReferenceDate = referenceDate;
    
    
    self.eventInScope = [[EventKitManager sharedManager] getNewEKEvent];
    self.eventInScope.startDate = self.calendarReferenceDate;
    self.eventInScope.endDate = [self.eventInScope.startDate dateByAddingTimeInterval:60*60];
    self.eventInScope.title = self.commonEventReferenceContainer.title;
    self.eventInScope.calendar = [[EventKitManager sharedManager] getEKCalendarWithIdentifier:self.commonEventReferenceContainer.referenceCalendarIdentifier];
    
    NSLog(@"self.eventInScope.startDate: %@", self.eventInScope.startDate);
    NSLog(@"self.eventInScope.endDate: %@", self.eventInScope.endDate);
    
    [self loadViews];
}


- (void) editEventWithReferenceEKObject
{
    NSLog(@"!editEventWithReferenceEKObject");
    self.eventInScope = (EKEvent *)self.ekObjectReference;
    [self loadViews];
}



-(void) displayEvent
{
    NSLog(@"displayEvent!");
    NSLog(@"josh look here");
    
    self.eventInScope = (EKEvent *)self.ekObjectReference;
    
    /*
    ContainerEventViewController *containerEventViewController = [[ContainerEventViewController alloc] initWithNibName:@"ContainerEventViewController" bundle:nil];
    containerEventViewController.parentController = self;
    containerEventViewController.theEvent = self.eventInScope;
     [self.view addSubview:containerEventViewController.view];
    */
    
    EKEventEditViewController *eventEditController = [[EKEventEditViewController alloc] initWithNibName:nil bundle:nil];
    eventEditController.view.frame = CGRectMake(0, 0, [Utils getScreenWidth], [Utils getScreenHeight]);
    eventEditController.eventStore = [EventKitManager sharedManager].eventStore;
    eventEditController.event = self.eventInScope;
    eventEditController.editViewDelegate = self;
    [self.view addSubview:eventEditController.view];

    
    
}

- (void)eventViewCancelButtonHit
{
    NSLog(@"eventViewCancelButtonHit!");

    
    
    [self.theParentViewController createEventExitButtonHitWithController:self withEvent:nil withAction:EKEventEditViewActionCancelled];
}



- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    if (action == EKEventEditViewActionCancelled)
    {
        [self.theParentViewController createEventExitButtonHitWithController:self withEvent:nil withAction:action];
    }
    else
    {
        NSLog(@"1");
        EKEvent *calEvent = controller.event;
        if (!self.denyProcess)
        {
            NSLog(@"2");

            
            
            switch (action) {
                case EKEventEditViewActionSaved:
                    [AlarmNotificationHandler processEventWithCalEvent:calEvent];
                    
                    
                    break;
                case EKEventEditViewActionDeleted:
                    NSLog(@"EKEventEditViewActionDeleted");
                    break;
                    
                default:
                    break;
            }
            
            
            NSLog(@"3");
            NSLog(@"self.theParentViewController: %@", self.theParentViewController);
            
            self.denyProcess = YES;
            [self.theParentViewController createEventExitButtonHitWithController:self withEvent:calEvent withAction:action];
            [self processCalEvent:calEvent withAction:action];
        }
    }
}


-(void)processCalEvent:(EKEvent *)calEvent withAction:(EKEventEditViewAction)action
{
    
    
    if (self.commonEventReferenceContainer != nil && action == EKEventEditViewActionSaved)
    {
        EKCalendar *theCalendar = nil;
        
        if ([self.commonEventReferenceContainer.commonEventID compare:[[EventKitManager sharedManager] getNewCommonEventID]] == NSOrderedSame)
        {
            self.commonEventReferenceContainer = [[CommonEventContainer alloc] init];
            self.commonEventReferenceContainer.title = calEvent.title;
        }        
        
        theCalendar = calEvent.calendar;
        
        self.commonEventReferenceContainer.referenceCalendarIdentifier = theCalendar.calendarIdentifier;
        self.commonEventReferenceContainer.allDay = calEvent.allDay;
        self.commonEventReferenceContainer.startDate = calEvent.startDate;
        self.commonEventReferenceContainer.endDate = calEvent.endDate;
        self.commonEventReferenceContainer.availibility = calEvent.availability;
        
        
        if (calEvent.alarms != nil)
        {
            NSMutableArray *relativeAlarmsArray = [NSMutableArray arrayWithCapacity:0];
            
            for (int i = 0; i < [calEvent.alarms count]; i++)
            {
                EKAlarm *theAlarm = [calEvent.alarms objectAtIndex:i];
                [relativeAlarmsArray addObject:[NSNumber numberWithDouble:theAlarm.relativeOffset]];
            }
            
            self.commonEventReferenceContainer.alarmsArray = [NSArray arrayWithArray:relativeAlarmsArray];
        }
        
        [[CommonEventsManager sharedEventsManager] setCommonEvent:self.commonEventReferenceContainer forCalendar:theCalendar];
        
    }
    
}



@end
