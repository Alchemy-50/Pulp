//
//  CalendarEvent.h
//  Calendar
//
//  Created by jay canty on 1/20/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>

@interface CalendarEvent : NSObject <NSCoding> {
    
    /*  EKEvent is the base class
        The following members of EKEvent/EKCalendarItem will be used;
     
        - title
        - calendar 
        - location
        - startDate
        - endDate
    */
    EKEvent *ekObject;
    
    NSMutableArray *participants;
    
    NSString *organizer;
    
    NSString *fbEventID;
    
    //NSString *commonTaskCalendarID;
    
    BOOL validEvent;
}

- (CalendarEvent *) init;
- (CalendarEvent *) initWithEKEvent:(EKEvent *)ekEvent;
- (CalendarEvent *) initWithSingleEKEvent:(EKEvent *)event;
- (void) addEkEvent:(EKEvent *)event;
- (EKEvent *) getEkEventWithParameter:(id)param;

- (CalendarEvent *) initWithCalendarEvent:(CalendarEvent *)ce;

- (void) printCalendarEvent;

@property (nonatomic, retain) EKEvent *ekObject;
@property (nonatomic, retain) NSMutableArray *participants;
@property (nonatomic, retain) NSString *organizer;
@property (nonatomic, retain) NSString *fbEventID;
@property (nonatomic, assign) BOOL validEvent;
//@property (nonatomic, retain) NSString *commonTaskCalendarID;
@end
