//
//  EventConverter.m
//  Pulp
//
//  Created by Josh Klobe on 2/19/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "EventConverter.h"
#import "EventKitManager.h"

@implementation EventConverter


+(NSDictionary *)loadWithEvent:(EKEvent *)theEvent
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    
 
    
    if (theEvent.eventIdentifier != nil)
        [dict setObject:[theEvent.eventIdentifier description] forKey:@"eventIdentifier"];
    
        [dict setObject:[NSNumber numberWithBool:theEvent.allDay] forKey:@"allDay"];
    
    if (theEvent.startDate != nil)
        [dict setObject:[theEvent.startDate description] forKey:@"startDate"];
    
    if (theEvent.endDate != nil)
        [dict setObject:[theEvent.endDate description] forKey:@"endDate"];
    
    if (theEvent.calendarItemIdentifier != nil)
        [dict setObject:[theEvent.calendarItemIdentifier description] forKey:@"calendarItemIdentifier"];
    
    if (theEvent.calendarItemExternalIdentifier != nil)
        [dict setObject:[theEvent.calendarItemExternalIdentifier description] forKey:@"calendarItemExternalIdentifier"];
    
    if (theEvent.title != nil)
        [dict setObject:[theEvent.title description] forKey:@"title"];
    
    if (theEvent.location != nil)
        [dict setObject:[theEvent.location description] forKey:@"location"];
    
    if (theEvent.notes != nil)
        [dict setObject:[theEvent.notes description] forKey:@"notes"];
    
    if (theEvent.URL != nil)
        [dict setObject:[theEvent.URL description] forKey:@"URL"];
    
    if (theEvent.lastModifiedDate != nil)
        [dict setObject:[theEvent.lastModifiedDate description] forKey:@"lastModifiedDate"];
    
    if (theEvent.creationDate != nil)
        [dict setObject:[theEvent.creationDate description] forKey:@"creationDate"];

 
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


+(EKEvent *)loadWithDictionary:(id)theDictionary
{
    EKEvent *theEvent = [[EventKitManager sharedManager] getEKEventWithIdentifier:[theDictionary objectForKey:@"eventIdentifier"]];
    if (theEvent == nil)
        theEvent = [[EventKitManager sharedManager] getNewEKEvent];
    
    
    theEvent.allDay = [[theDictionary objectForKey:@"allDay"] boolValue];
    theEvent.startDate = [theDictionary objectForKey:@"startDate"];
    theEvent.endDate = [theDictionary objectForKey:@"endDate"];
    theEvent.title = [theDictionary objectForKey:@"title"];
    theEvent.location = [theDictionary objectForKey:@"location"];
    theEvent.notes = [theDictionary objectForKey:@"notes"];
    theEvent.URL = [theDictionary objectForKey:@"URL"];
    
    
    //theEvent.calendarItemIdentifier = [theDictionary objectForKey:@"calendarItemIdentifier"];
    //theEvent.calendarItemExternalIdentifier = [theDictionary objectForKey:@"calendarItemExternalIdentifier"];
    //theEvent.creationDate = [theDictionary objectForKey:@"creationDate"];
    //theEvent.lastModifiedDate = [theDictionary objectForKey:@"lastModifiedDate"];
    
    return theEvent;
}



/*
- (NSDictionary *) dictionaryWithPropertiesOfObject:(id)obj withClass:(Class)theClass
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList(theClass, &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        id theObjToSet = [obj valueForKey:key];
        if (theObjToSet != nil)
            [dict setObject:theObjToSet forKey:key];
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dict];
}
*/


@end

