//
//  DataSyncher.m
//  Pulp_TV
//
//  Created by Josh Klobe on 3/3/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "DataSyncher.h"

@implementation DataSyncher

+(void)run
{
    
    NSFileManager* fileManager = [NSFileManager defaultManager];
    id currentiCloudToken = fileManager.ubiquityIdentityToken;
    
    NSLog(@"currentiCloudToken: %@", currentiCloudToken);
    
    
    if (currentiCloudToken) {
        NSData *newTokenData =
        [NSKeyedArchiver archivedDataWithRootObject: currentiCloudToken];
        [[NSUserDefaults standardUserDefaults]
         setObject: newTokenData
         forKey: @"com.apple.MyAppName.UbiquityIdentityToken"];
    } else {
        [[NSUserDefaults standardUserDefaults]
         removeObjectForKey: @"com.apple.MyAppName.UbiquityIdentityToken"];
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver: self
     selector: @selector (iCloudAccountAvailabilityChanged:)
     name: NSUbiquityIdentityDidChangeNotification
     object: nil];
    
    
    
    dispatch_async (dispatch_get_global_queue (DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSURL *myContainer = [[NSFileManager defaultManager]
                              //URLForUbiquityContainerIdentifier: nil];
                              URLForUbiquityContainerIdentifier: @"iCloud.alchemy50.com.Pulp"];
        if (myContainer != nil) {
            // Your app can write to the iCloud container
            
            NSLog(@"here!, myContainer: %@", myContainer);
            
            //NSDocumentDirectory
            //            [[NSUbiquitousKeyValueStore defaultStore] setString:@"myValue" forKey:@"myKey"];
            //            [[NSUbiquitousKeyValueStore defaultStore] synchronize];
            
            id obj = [[NSUbiquitousKeyValueStore defaultStore] objectForKey:@"myKey"];
            NSLog(@"OBJ!: %@", obj);
            
            NSURL *ubiquitousPackage = [[myContainer URLByAppendingPathComponent:@"Documents"]  URLByAppendingPathComponent:@"iCloudPictures.zip"];
            /*
            NSString* str = @"here we go";
            PulpTestDocument *mydoc = [[PulpTestDocument alloc] initWithFileURL:ubiquitousPackage];
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            mydoc.dataContent = data;
            
            [mydoc saveToURL:[mydoc fileURL] forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
             {
                 if (success)
                 {
                     NSLog(@"Synced with icloud");
                     
                     PulpTestDocument *newDoc = [[PulpTestDocument alloc] initWithFileURL:ubiquitousPackage];
                     NSLog(@"newDoc: %@", newDoc);
                     
                     NSURL *testURL = [newDoc fileURL];
                     NSLog(@"testURL: %@", testURL);
                     
                     //                     mydoc = [[PulpTestDocument alloc] initWithFileURL:ubiquitousPackage];
                     
                 }
                 else
                     NSLog(@"Syncing FAILED with icloud");
                 
             }];
            */
            
            dispatch_async (dispatch_get_main_queue (), ^(void) {
                // On the main thread, update UI and state as appropriate
                NSLog(@"here 2");
            });
        }
        else
            NSLog(@"here 3");
    });
    
    
    
}

-(void)iCloudAccountAvailabilityChanged:(id)sender
{
    NSLog(@"%s, sender: %@", __PRETTY_FUNCTION__, sender);
}


@end
