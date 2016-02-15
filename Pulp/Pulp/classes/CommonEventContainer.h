//
//  CommonEventContainer.h
//  Calendar
//
//  Created by Josh Klobe on 5/21/13.
//
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

#define COMMON_EVENT_ENTRY_TYPE_REGULAR 0
#define COMMON_EVENT_ENTRY_TYPE_ADD_BUTTON 1
#define COMMON_EVENT_ENTRY_TYPE_ENTRY_FIELD 2
#define COMMON_EVENT_ENTRY_TYPE_CALENDAR_NAME 3

@interface CommonEventContainer : NSObject
{
    NSString *commonEventID;
    NSString *referenceCalendarIdentifier;
    NSString *title;
    NSString *eventIdentifier;
    BOOL allDay;
    NSDate *startDate;
    NSDate *endDate;
    BOOL isDetached;
    NSTimeInterval eventTime;
    NSArray *alarmsArray;
    EKEventAvailability availibility;
    
    int entryType;
}

@property (nonatomic, retain) NSString *commonEventID;
@property (nonatomic, retain) NSString *referenceCalendarIdentifier;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *eventIdentifier;
@property (nonatomic, assign) BOOL allDay;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, assign) BOOL isDetached;
@property (nonatomic, assign) NSTimeInterval eventTime;
@property (nonatomic, retain) NSArray *alarmsArray;
@property (nonatomic, assign) EKEventAvailability availibility;

@property (nonatomic, assign) int entryType;
@end
