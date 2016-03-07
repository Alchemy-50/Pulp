//
//  CircleView.h
//  RadialControl
//
//  Created by Josh Klobe on 6/21/13.
//  Copyright (c) 2013 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView
{
    UIColor *strokeColor;
    UIColor *fillColor;
}

@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *fillColor;

@end
