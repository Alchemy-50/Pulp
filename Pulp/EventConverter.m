//
//  EventConverter.m
//  Pulp
//
//  Created by Josh Klobe on 2/19/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "EventConverter.h"

@implementation EventConverter

+(NSDictionary *)getEventDictionaryFromEvent:(EKEvent *)theEvent
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
 
    
    if (theEvent.eventIdentifier != nil)
        [dict setObject:theEvent.eventIdentifier forKey:@"eventIdentifier"];
    
        [dict setObject:[NSNumber numberWithBool:theEvent.allDay] forKey:@"allDay"];
    
    if (theEvent.startDate != nil)
        [dict setObject:theEvent.startDate forKey:@"startDate"];
    
    if (theEvent.endDate != nil)
        [dict setObject:theEvent.endDate forKey:@"endDate"];
    
    if (theEvent.calendarItemIdentifier != nil)
        [dict setObject:theEvent.calendarItemIdentifier forKey:@"calendarItemIdentifier"];
    
    if (theEvent.calendarItemExternalIdentifier != nil)
        [dict setObject:theEvent.calendarItemExternalIdentifier forKey:@"calendarItemExternalIdentifier"];
    
    if (theEvent.title != nil)
        [dict setObject:theEvent.title forKey:@"title"];
    
    if (theEvent.location != nil)
        [dict setObject:theEvent.location forKey:@"location"];
    
    if (theEvent.notes != nil)
        [dict setObject:theEvent.notes forKey:@"notes"];
    
    if (theEvent.URL != nil)
        [dict setObject:theEvent.URL forKey:@"URL"];
    
    if (theEvent.lastModifiedDate != nil)
        [dict setObject:theEvent.lastModifiedDate forKey:@"lastModifiedDate"];
    
    if (theEvent.creationDate != nil)
        [dict setObject:theEvent.creationDate forKey:@"creationDate"];

 
    //@property(nonatomic, strong) EKCalendar *calendar;
    /*
    @property(nonatomic, copy, nullable) EKStructuredLocation *structuredLocation NS_AVAILABLE(10_11, 9_0);
    @property(nonatomic, readonly, nullable) EKParticipant *organizer;
    @property(nonatomic) EKEventAvailability    availability;
    @property(nonatomic, readonly) EKEventStatus          status;
    @property(nonatomic, readonly) BOOL isDetached;
    @property(nonatomic, readonly) NSDate *occurrenceDate NS_AVAILABLE(10_8, 9_0);
    @property(nonatomic, readonly, nullable) NSString *birthdayContactIdentifier NS_AVAILABLE(10_11, 9_0);
    @property(nonatomic, readonly) NSInteger birthdayPersonID NS_DEPRECATED_IOS(5_0, 9_0, "Use birthdayContactIdentifier instead");
    @property(nonatomic, readonly, nullable) NSString *birthdayPersonUniqueID NS_DEPRECATED_MAC(10_8, 10_11, "Use birthdayContactIdentifier instead");
    @property(nonatomic, copy, nullable) NSTimeZone *timeZone  NS_AVAILABLE(10_8, 5_0);
    @property(nonatomic, readonly) BOOL hasAlarms  NS_AVAILABLE(10_8, 5_0);
    @property(nonatomic, readonly) BOOL hasRecurrenceRules  NS_AVAILABLE(10_8, 5_0);
    @property(nonatomic, readonly) BOOL hasAttendees  NS_AVAILABLE(10_8, 5_0);
    @property(nonatomic, readonly) BOOL hasNotes  NS_AVAILABLE(10_8, 5_0);
    @property(nonatomic, readonly, nullable) NSArray<__kindof EKParticipant *> *attendees;
    @property(nonatomic, copy, nullable) NSArray<EKAlarm *> *alarms;
    */

    
    return dict;
}
@end

