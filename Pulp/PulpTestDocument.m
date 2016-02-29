//
//  PulpTestDocument.m
//  Pulp
//
//  Created by Josh Klobe on 2/26/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "PulpTestDocument.h"

@implementation PulpTestDocument



// Called whenever the application reads data from the file system
- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError **)outError
{
    NSLog(@"loadFromContents called");
    self.dataContent = [[NSData alloc] initWithBytes:[contents bytes] length:[contents length]];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noteModified" object:self];
    return YES;
}

// Called whenever the application (auto)saves the content of a note
- (id)contentsForType:(NSString *)typeName error:(NSError **)outError
{
    return self.dataContent;
}



@end
