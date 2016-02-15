//
//  CommonEventContainer.m
//  Calendar
//
//  Created by Josh Klobe on 5/21/13.
//
//

#import "CommonEventContainer.h"

@implementation CommonEventContainer

@synthesize commonEventID;
@synthesize referenceCalendarIdentifier;
@synthesize title;
@synthesize eventIdentifier;
@synthesize allDay;
@synthesize startDate;
@synthesize endDate;
@synthesize isDetached;
@synthesize eventTime;
@synthesize alarmsArray;
@synthesize availibility;
@synthesize entryType;

-(id)init
{
    self = [super init];
    self.commonEventID = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
    return self;
}
- (void) encodeWithCoder:(NSCoder *)encoder {

    
    [encoder encodeObject:self.commonEventID forKey:@"commonEventID"];
    [encoder encodeObject:self.referenceCalendarIdentifier forKey:@"referenceCalendarIdentifier"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.eventIdentifier forKey:@"eventIdentifier"];
    [encoder encodeBool:self.allDay forKey:@"allDay"];
    [encoder encodeObject:self.startDate forKey:@"startDate"];
    [encoder encodeObject:self.endDate forKey:@"endDate"];
    [encoder encodeBool:self.isDetached forKey:@"isDetached"];
    [encoder encodeDouble:self.eventTime forKey:@"eventTime"];
    [encoder encodeObject:self.alarmsArray forKey:@"alarmsArray"];
    [encoder encodeInt:self.availibility forKey:@"availibility"];
    
}


- (id)initWithCoder:(NSCoder *)decoder {


    self.commonEventID = [decoder decodeObjectForKey:@"commonEventID"];
    self.referenceCalendarIdentifier = [decoder decodeObjectForKey:@"referenceCalendarIdentifier"];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.eventIdentifier = [decoder decodeObjectForKey:@"eventIdentifier"];
    self.allDay = [decoder decodeBoolForKey:@"allDay"];
    self.startDate = [decoder decodeObjectForKey:@"startDate"];
    self.endDate = [decoder decodeObjectForKey:@"endDate"];
    self.isDetached = [decoder decodeBoolForKey:@"isDetached"];
    self.eventTime = [decoder decodeDoubleForKey:@"eventTime"];
    self.alarmsArray = [decoder decodeObjectForKey:@"alarmsArray"];
    self.availibility = [decoder decodeIntForKey:@"availibility"];
    
    
    return self;
}


@end
