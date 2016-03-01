//
//  SourceRepresentation.m
//  Pulp
//
//  Created by Josh Klobe on 3/1/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "SourceRepresentation.h"
#import <EventKit/EventKit.h>

@interface SourceRepresentation ()
@property (nonatomic, retain) EKSource *referenceSource;
@end

@implementation SourceRepresentation

-(id)initWithSource:(id)theSource
{
    self = [super init];
    self.referenceSource = theSource;
    
    return self;
}

-(NSString *)getTitle
{
    NSString *ret = @"";
    
    if ([self.referenceSource isKindOfClass:[EKSource class]])
    {
        ret = self.referenceSource.title;
    }
    return ret;
}

@end
