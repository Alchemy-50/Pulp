//
//  CommonTaskEventContainer.h
//  Calendar
//
//  Created by Josh Klobe on 4/23/13.
//
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface CommonTaskEventContainer : NSObject
{
    NSString *calendarID;
    EKCalendar *associatedCalendar;
    
    NSString *title;
    NSString *location;
    NSDate *creationDate;
    NSDate *lastModifiedDate;
    NSTimeZone *timeZone;
    NSURL *URL;
    
    BOOL allDay;
    NSDate *startDate;
    NSDate *endDate;
    BOOL available;
    
    BOOL automatic;
    
}

@property (nonatomic, retain) NSString *calendarID;
@property (nonatomic, retain) EKCalendar *associatedCalendar;

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSDate *creationDate;
@property (nonatomic, retain) NSDate *lastModifiedDate;
@property (nonatomic, retain) NSTimeZone *timeZone;
@property (nonatomic, retain) NSURL *URL;

@property (nonatomic, assign) BOOL allDay;
@property (nonatomic, retain) NSDate *startDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, assign) BOOL available;

@property (nonatomic, assign) BOOL automatic;

@end
