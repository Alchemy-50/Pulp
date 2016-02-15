//
//  DragReceivingComponent.h
//  AlphaRow
//
//  Created by Josh Klobe on 11/14/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlphaRowDragViewManager.h"
@protocol DragReceivingComponent <NSObject>

-(BOOL)willAddDraggableViewToCalendar:(UIView *)draggableView withAlphaRowDragManager:(AlphaRowDragViewManager *)alphaRowDragManager;
@end
