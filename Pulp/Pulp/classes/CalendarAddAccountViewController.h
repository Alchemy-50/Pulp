//
//  CalendarAddAccountViewController.h
//  AlphaRow
//
//  Created by Josh Klobe on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalendarAddAccountViewController : UIViewController
{
    UILabel *addLabel;
    UITextField *addField;
    UIButton *addButton;
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFrame:(CGRect )theFrame;
-(void)layoutViews;

@property (nonatomic, retain) UILabel *addLabel;
@property (nonatomic, retain) UITextField *addField;
@property (nonatomic, retain) UIButton *addButton;
@end
