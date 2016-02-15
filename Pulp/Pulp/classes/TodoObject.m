//
//  TodoObject.m
//  Calendar
//
//  Created by Josh Klobe on 7/11/14.
//
//

#import "TodoObject.h"

@implementation TodoObject

@synthesize todoIdentificationNumber;
@synthesize todoString;


- (void) encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.todoIdentificationNumber forKey:@"todoIdentificationNumber"];
    [encoder encodeObject:self.todoString forKey:@"todoString"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    self.todoIdentificationNumber = [decoder decodeObjectForKey:@"todoIdentificationNumber"];
    self.todoString = [decoder decodeObjectForKey:@"todoString"];
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"TodoObject %d %@", [self.todoIdentificationNumber intValue], self.todoString];
}

@end
