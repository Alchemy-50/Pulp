//
//  CommonEventsOrderManager.m
//  Calendar
//
//  Created by Josh Klobe on 6/9/14.
//
//

#import "CommonEventsOrderManager.h"
#import "GroupDiskManager.h"
#import "CommonEventContainer.h"


#define COMMON_EVENTS_ORDER_DICTIONARY_KEY @"COMMON_EVENTS_ORDER_DICTIONAARY_KEY"

@implementation CommonEventsOrderManager

@synthesize orderContainerDictionary;

static CommonEventsOrderManager *theStaticManager;

+(CommonEventsOrderManager *)sharedEventsOrderManager
{
    
    if (theStaticManager == nil)
    {
        theStaticManager = [[CommonEventsOrderManager alloc] init];
        theStaticManager.orderContainerDictionary = [[NSMutableDictionary alloc] initWithCapacity:0];
        
        NSDictionary *storedDictionary = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:COMMON_EVENTS_ORDER_DICTIONARY_KEY];
        if (storedDictionary != nil)
            [theStaticManager.orderContainerDictionary addEntriesFromDictionary:storedDictionary];
        
    }
    
//    NSLog(@"theStaticManager.orderContainerDictionary: %@", theStaticManager.orderContainerDictionary);
    return  theStaticManager;
}

-(NSMutableArray *)getArrayWithIdentifier:(NSString *)theIdentifier
{
    NSMutableArray *orderedArray = [NSMutableArray arrayWithCapacity:0];
    NSArray *storedArray = [self.orderContainerDictionary objectForKey:theIdentifier];
    if (storedArray != nil)
        [orderedArray addObjectsFromArray:storedArray];
    
    return orderedArray;
}

-(unsigned long)getPositionFromEvent:(CommonEventContainer *)theEvent
{
    NSMutableArray *orderedArray = [self getArrayWithIdentifier:theEvent.referenceCalendarIdentifier];
    
    if (![orderedArray containsObject:theEvent.title])
        [orderedArray addObject:theEvent.title];
    
    [self.orderContainerDictionary setObject:orderedArray forKey:theEvent.referenceCalendarIdentifier];
    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:self.orderContainerDictionary withKey:COMMON_EVENTS_ORDER_DICTIONARY_KEY];
    
    
    return [orderedArray indexOfObject:theEvent.title];
}

-(void)moveEvent:(CommonEventContainer *)theEvent toIndex:(NSInteger)index
{ 
    NSMutableArray *orderedArray = [self getArrayWithIdentifier:theEvent.referenceCalendarIdentifier];

    [orderedArray removeObject:theEvent.title];
    [orderedArray insertObject:theEvent.title atIndex:index];
        
    [self.orderContainerDictionary setObject:orderedArray forKey:theEvent.referenceCalendarIdentifier];
    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:self.orderContainerDictionary withKey:COMMON_EVENTS_ORDER_DICTIONARY_KEY];
}

-(void)deleteEvent:(CommonEventContainer *)theEvent
{
    NSMutableArray *orderedArray = [self getArrayWithIdentifier:theEvent.referenceCalendarIdentifier];
    [orderedArray removeObject:theEvent.title];
    [self.orderContainerDictionary setObject:orderedArray forKey:theEvent.referenceCalendarIdentifier];
    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:self.orderContainerDictionary withKey:COMMON_EVENTS_ORDER_DICTIONARY_KEY];
}

-(void)replaceTitle:(CommonEventContainer *)oldEvent withNewTitle:(NSString *)newTitle
{
    NSMutableArray *orderedArray = [self getArrayWithIdentifier:oldEvent.referenceCalendarIdentifier];
    [orderedArray replaceObjectAtIndex:[self getPositionFromEvent:oldEvent] withObject:newTitle];
    [self.orderContainerDictionary setObject:orderedArray forKey:oldEvent.referenceCalendarIdentifier];
    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:self.orderContainerDictionary withKey:COMMON_EVENTS_ORDER_DICTIONARY_KEY];

}



@end
