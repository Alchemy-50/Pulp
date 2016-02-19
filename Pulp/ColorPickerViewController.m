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

@end

@implementation ColorPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    DRColorPickerWheelView *theView = [[DRColorPickerWheelView alloc] initWithFrame:CGRectMake(0, 0, [Utils getScreenWidth], [Utils getScreenHeight])];
    [self.view addSubview:theView];

    
}


@end
