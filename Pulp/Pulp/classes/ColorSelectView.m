//
//  ColorSelectView.m
//  Calendar
//
//  Created by Josh Klobe on 2/9/16.
//
//

#import "ColorSelectView.h"
#import "ThemeSelectViewController.h"
@implementation ColorSelectView



-(void)load
{
    /*
    UIView *primaryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 2, self.frame.size.height)];
    primaryView.backgroundColor = self.primaryColor;
    [self addSubview:primaryView];
 
    UIView *secondaryView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2, 0, self.frame.size.width / 2, self.frame.size.height)];
    secondaryView.backgroundColor = self.secondaryColor;
    [self addSubview:secondaryView];
    */
    
    self.backgroundColor = self.primaryColor;
 
    UIButton *theButton = [UIButton buttonWithType:UIButtonTypeCustom];
    theButton.backgroundColor = [UIColor clearColor];
    theButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [theButton addTarget:self action:@selector(theButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:theButton];
    
}

-(void)theButtonHit
{
    [self.theParentController colorSelectViewSelected:self];
}
@end
