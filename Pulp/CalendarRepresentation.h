//
//  CalendarRepresentation.h
//  Pulp
//
//  Created by Josh Klobe on 2/29/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CalendarRepresentation : NSObject

-(id)initWithEventObject:(id)eventObject;
-(UIColor *)getColor;
-(NSString *)getTitle;
@end
