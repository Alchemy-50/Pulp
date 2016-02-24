//
//  AllCalendarButtonView.h
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllCalendarButtonView : UIView


+(AllCalendarButtonView *)sharedButtonView;

-(void)turnOn;
-(void)turnOff;
@end
