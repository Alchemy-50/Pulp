//
//  SourceRepresentation.m
//  Pulp
//
//  Created by Josh Klobe on 3/1/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "SourceRepresentation.h"

@interface SourceRepresentation ()
@property (nonatomic, retain) id referenceSource;
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
    return ret;
}

@end
