//
//  layeredBorderView.h
//  Calendar
//
//  Created by jay canty on 2/24/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LayeredBorderView : UIView {
    
    UIView *top;
    UIView *middle;
    UIView *bottom;
    
}

-(void) repositionViews;

@property (nonatomic, retain) UIView *top;
@property (nonatomic, retain) UIView *middle;
@property (nonatomic, retain) UIView *bottom; 

@end