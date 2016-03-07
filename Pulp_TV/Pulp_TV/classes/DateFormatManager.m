//
//  GroupFormatManager.m
//  Calendar
//
//  Created by Jay Canty on 4/12/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "DateFormatManager.h"

@implementation DateFormatManager

static DateFormatManager *theManager;

@synthesize  dayFormatter, monthFormatter, yearFormatter, dateFormatter, dateTimeFormatter, timeFormatter;


+(DateFormatManager *)sharedManager
{
    if (theManager == nil)
        theManager = [[DateFormatManager alloc] init];
    
    return theManager;
}

- (DateFormatManager *) init
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



@end
