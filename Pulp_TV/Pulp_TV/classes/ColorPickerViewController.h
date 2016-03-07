//
//  ColorPickerViewController.h
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorPickerViewController : UIViewController

@property (nonatomic, retain) id theParentController;
-(void)loadWithColor:(UIColor *)theColor;
-(void)doneButtonHit;
@end
