//
//  GroupFormatManager.m
//  Calendar
//
//  Created by Jay Canty on 4/12/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "GroupFormatManager.h"

@implementation GroupFormatManager

static GroupFormatManager *theManager;

@synthesize  dayFormatter, monthFormatter, yearFormatter, dateFormatter, dateTimeFormatter, timeFormatter;


+(GroupFormatManager *)sharedManager
{
    if (theManager == nil)
        theManager = [[GroupFormatManager alloc] init];
    
    return theManager;
}

- (GroupFormatManager *) init
{
    self = [super init];
    
    // date formatters
    self.dayFormatter = [[NSDateFormatter alloc] init];
    [self.dayFormatter setDateFormat:@"dd"]; 
    
    self.monthFormatter = [[NSDateFormatter alloc] init];
    [self.monthFormatter setDateFormat:@"MM"];  
    
    self.yearFormatter = [[NSDateFormatter alloc] init];
    [self.yearFormatter setDateFormat:@"yyyy"];        
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];     
    
    self.dateTimeFormatter = [[NSDateFormatter alloc] init];
    [self.dateTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    self.timeFormatter = [[NSDateFormatter alloc] init];
    [self.timeFormatter setDateFormat:@"HH:mm:ss"];
    
    return self;
}

- (void)dealloc {
    
    NSLog(@"DEALLOC");
    [self.dayFormatter release];
    [self.monthFormatter release];
    [self.yearFormatter release];
    [self.dateFormatter release];
    [self.dateTimeFormatter release];
	[self.timeFormatter release];
    
    [super dealloc];
}


@end
