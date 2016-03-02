//
//  GroupFormatManager.h
//  Calendar
//
//  Created by Jay Canty on 4/12/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GroupFormatManager : NSObject {
    
    NSDateFormatter *dayFormatter;
    NSDateFormatter *monthFormatter;      
    NSDateFormatter *yearFormatter; 
    NSDateFormatter *dateFormatter;
    NSDateFormatter *dateTimeFormatter;
    NSDateFormatter *timeFormatter;
}

+(GroupFormatManager *)sharedManager;

@property (nonatomic, retain) NSDateFormatter *dayFormatter;
@property (nonatomic, retain) NSDateFormatter *monthFormatter;      
@property (nonatomic, retain) NSDateFormatter *yearFormatter; 
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDateFormatter *dateTimeFormatter;
@property (nonatomic, retain) NSDateFormatter *timeFormatter;


@end
