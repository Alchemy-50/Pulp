//
//  CalendarAddAccountViewController.m
//  AlphaRow
//
//  Created by Josh Klobe on 11/8/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "CalendarAddAccountViewController.h"

@implementation CalendarAddAccountViewController

@synthesize  addLabel, addField, addButton;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withFrame:(CGRect )theFrame
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.frame = theFrame;
        NSLog(@"here: %@", self.view);
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

-(void)layoutViews
{
    
    if (self.addLabel != nil)
    {
        [self.addLabel removeFromSuperview];
        [self.addLabel release];                 
    }
    
    if (self.addField != nil)
    {
        [self.addField removeFromSuperview];
        [self.addField release];                 
    }
    
    self.addLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,self.view.frame.size.width, 20)];
    self.addLabel.backgroundColor = [UIColor clearColor];
    self.addLabel.text = @"Add Account";
    self.addLabel.textAlignment = NSTextAlignmentCenter;
    self.addLabel.font = [UIFont fontWithName:@"Lato-Regular" size:16];
    [self.view addSubview:self.addLabel];
    
    self.addField = [[UITextField alloc] initWithFrame:CGRectMake(0, self.addLabel.frame.origin.y + self.addLabel.frame.size.height + 10, self.view.frame.size.width, 24)];
    self.addField.backgroundColor = [UIColor whiteColor];                                     
    [self.view addSubview:self.addField];
    
    self.addButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
    [self.addButton setTitle:@"Add" forState:UIControlStateNormal];
    self.addButton.frame = CGRectMake(0,self.addField.frame.origin.y + self.addField.frame.size.height + 10, self.addField.frame.size.width, self.addField.frame.size.height);
    [self.view addSubview:self.addButton];
    
    //NSLog(@"self.view: %@", self.view);

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
