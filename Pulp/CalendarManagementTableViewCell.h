//
//  CalendarManagementTableViewCell.h
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Defs.h"
#import "SourceRepresentation.h"
#import "CalendarRepresentation.h"

@interface CalendarManagementTableViewCell : UITableViewCell

-(void) initialize;
-(void) cleanViews;
-(void) loadWithSource:(SourceRepresentation *)theSource;
-(void) loadWithCalendar:(CalendarRepresentation *)theCalendar;



@end
