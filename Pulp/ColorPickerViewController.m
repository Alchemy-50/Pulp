//
//  ColorPickerViewController.m
//  Pulp
//
//  Created by Josh Klobe on 2/18/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "ColorPickerViewController.h"
#import "DRColorPickerWheelView.h"
#import "Utils.h"
@interface ColorPickerViewController ()

@property (nonatomic, retain) DRColorPickerWheelView *thePickerWheelView;

@end

@implementation ColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.thePickerWheelView = [[DRColorPickerWheelView alloc] initWithFrame:CGRectMake(0, 0, [Utils getScreenWidth], [Utils getScreenHeight])];
    [self.view addSubview:self.thePickerWheelView];

    
}

-(void)loadWithColor:(UIColor *)theColor
{
    self.thePickerWheelView.color = theColor;
}

@end
