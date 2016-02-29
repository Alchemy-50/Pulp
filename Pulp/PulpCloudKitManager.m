//
//  PulpCloudKitManager.m
//  Pulp
//
//  Created by Josh Klobe on 2/26/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "PulpCloudKitManager.h"
#import <CloudKit/CloudKit.h>

@implementation PulpCloudKitManager

NSString *recordNameKey = @"recordNameKey";
NSString *recordTypeKey = @"RecordTypeKey";
NSString *recordKey = @"qwerty";


+(void)run
{
    CKSubscription *subscription = [[CKSubscription alloc] initWithRecordType:recordTypeKey predicate: [NSPredicate predicateWithFormat:@"TRUEPREDICATE"] options:CKSubscriptionOptionsFiresOnRecordCreation | CKSubscriptionOptionsFiresOnRecordUpdate | CKSubscriptionOptionsFiresOnRecordDeletion];
    
    
    CKNotificationInfo *info = [CKNotificationInfo new];
    info.alertLocalizationKey = @"NEW_PARTY_ALERT_KEY";
    info.shouldBadge = YES;
    
    subscription.notificationInfo = info;
    
    
    
    [[[CKContainer defaultContainer] privateCloudDatabase] saveSubscription:subscription
                completionHandler:^(CKSubscription *subscription, NSError *error) {
                    
                    NSLog(@"subscription completed: %@", subscription);
                    NSLog(@"subscriptionError: %@", error);
                    [self runUpdate];
                }];
    
    
}

+(void)runUpdate
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:0];
    [dict setObject:@"testVal3" forKey:@"testKey"];
    NSData *dictionaryData = [NSKeyedArchiver archivedDataWithRootObject:dict];
    
    
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *theDatabase = [container privateCloudDatabase];
    CKRecordID *recordID = [[CKRecordID alloc] initWithRecordName:recordNameKey];
    
    
    

    /*
    [theDatabase deleteRecordWithID:recordID completionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        // handle errors here
        NSLog(@"deleteRecordWithID: %@", recordID);
        NSLog(@"error: %@", error);
        
    }];
    
    */
    
    [theDatabase fetchRecordWithID:recordID completionHandler:^(CKRecord *fetchedRecord, NSError *error) {
        
        if (fetchedRecord == nil)
            fetchedRecord = [[CKRecord alloc] initWithRecordType:recordTypeKey recordID:recordID];
        
        
        
        fetchedRecord[@"dictionaryData"] = dictionaryData;
        
        [theDatabase saveRecord:fetchedRecord completionHandler:^(CKRecord *savedRecord, NSError *error) {
            // handle errors here
            
            NSLog(@"savedRecord: %@", savedRecord);
            NSLog(@"error: %@", error);
            [self fetch];
            
        }];
        
 
    }];
        
    
    
}

+(void)fetch
{
    
    CKContainer *container = [CKContainer defaultContainer];
    CKDatabase *theDatabase = [container privateCloudDatabase];
    
    CKRecordID *someID = [[CKRecordID alloc] initWithRecordName:recordNameKey];
    
    [theDatabase fetchRecordWithID:someID completionHandler:^(CKRecord *fetchedRecord, NSError *error) {
        // handle errors here
        
        
        NSLog(@"fetchedRecord: %@", fetchedRecord);
        NSLog(@"recordKey!: %@", recordKey);
        NSArray *keysArray = [fetchedRecord allKeys];
        NSLog(@"KeysAray: %@", keysArray);
        NSString *obj = [fetchedRecord objectForKey:recordKey];
        NSLog(@"OBJ!: %@", obj);
        NSData *dictionaryData = [fetchedRecord objectForKey:@"dictionaryData"];
        NSLog(@"dictionaryData: %@", dictionaryData);
        
        NSDictionary *myDictionary = (NSDictionary*) [NSKeyedUnarchiver unarchiveObjectWithData:dictionaryData];
        NSLog(@"myDictionary: %@", myDictionary);
        
        NSLog(@"error: %@", error);
        
    }];
    
    
    
}
@end
