//
//  CommonEventsOrderManager.h
//  Calendar
//
//  Created by Josh Klobe on 6/9/14.
//
//

#import <Foundation/Foundation.h>
#import "CommonEventContainer.h"

@interface CommonEventsOrderManager : NSObject


+(CommonEventsOrderManager *)sharedEventsOrderManager;
-(unsigned long)getPositionFromEvent:(CommonEventContainer *)theEvent;
-(void)moveEvent:(CommonEventContainer *)theEvent toIndex:(NSInteger)index;
-(void)deleteEvent:(CommonEventContainer *)theEvent;
-(void)replaceTitle:(CommonEventContainer *)oldEvent withNewTitle:(NSString *)newTitle;

@property (nonatomic, retain) NSMutableDictionary *orderContainerDictionary;

@end
