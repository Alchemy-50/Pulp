//
//  CalendarTVViewController.h
//  Pulp_TV
//
//  Created by Josh Klobe on 3/3/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarTVViewController : UIViewController <UIFocusEnvironment>

+(CalendarTVViewController *) sharedController;
-(void) dataChanged;
@end
