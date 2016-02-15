//
//  CommonTaskEventContainer.m
//  Calendar
//
//  Created by Josh Klobe on 4/23/13.
//
//

#import "CommonTaskEventContainer.h"

@implementation CommonTaskEventContainer

@synthesize calendarID;
@synthesize associatedCalendar;

@synthesize title;
@synthesize location;
@synthesize creationDate;
@synthesize lastModifiedDate;
@synthesize timeZone;
@synthesize URL;

@synthesize allDay;
@synthesize startDate;
@synthesize endDate;
@synthesize available;

@synthesize automatic;



- (void) encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.calendarID forKey:@"calendarID"];
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.location forKey:@"location"];
    [encoder encodeObject:self.creationDate forKey:@"creationDate"];
    [encoder encodeObject:self.lastModifiedDate forKey:@"lastModifiedDate"];
    [encoder encodeObject:self.timeZone forKey:@"timeZone"];
    [encoder encodeObject:self.URL forKey:@"URL"];
    [encoder encodeObject:self.startDate forKey:@"startDate"];
    [encoder encodeObject:self.endDate forKey:@"endDate"];
    
    
    [encoder encodeBool:self.allDay forKey:@"allDay"];
    [encoder encodeBool:self.available forKey:@"available"];
    [encoder encodeBool:self.automatic forKey:@"automatic"];
    

    
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    
    self.calendarID = [decoder decodeObjectForKey:@"calendarID"];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.location = [decoder decodeObjectForKey:@"location"];
    self.creationDate = [decoder decodeObjectForKey:@"creationDate"];
    self.lastModifiedDate = [decoder decodeObjectForKey:@"lastModifiedDate"];
    self.timeZone = [decoder decodeObjectForKey:@"timeZone"];
    self.URL = [decoder decodeObjectForKey:@"URL"];
    self.allDay = [[decoder decodeObjectForKey:@"allDay"] boolValue];
    self.startDate = [decoder decodeObjectForKey:@"startDate"];
    self.endDate = [decoder decodeObjectForKey:@"endDate"];
    self.available = [[decoder decodeObjectForKey:@"available"] boolValue];
    self.automatic = [[decoder decodeObjectForKey:@"automatic"] boolValue];
   

    return self;
}

@end
