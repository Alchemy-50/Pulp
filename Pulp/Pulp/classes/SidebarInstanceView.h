//
//  SidebarInstanceView.h
//  Calendar
//
//  Created by Josh Klobe on 2/9/16.
//
//

#import <UIKit/UIKit.h>

@interface SidebarInstanceView : UIView


-(void)loadWithDate:(NSDate *)theDate withReferenceIndex:(int)referenceIndex;
-(void)updateWeather;
@end
