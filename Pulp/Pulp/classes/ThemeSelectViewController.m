//
//  ThemeSelectViewController.m
//  Calendar
//
//  Created by Josh Klobe on 2/9/16.
//
//

#import "ThemeSelectViewController.h"
#import "ColorSelectView.h"
#import "ThemeManager.h"
#import "ThemeSelectObject.h"


@interface ThemeSelectViewController ()

@end

@implementation ThemeSelectViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSMutableArray *ar = [NSMutableArray arrayWithCapacity:0];
    [ar addObject:[ThemeSelectObject getA50Color]];
    [ar addObject:[ThemeSelectObject getEmeraldColor]];
    [ar addObject:[ThemeSelectObject getGrapeColor]];
    [ar addObject:[ThemeSelectObject getCoralColor]];
    [ar addObject:[ThemeSelectObject getRubyColor]];
    [ar addObject:[ThemeSelectObject getGoldColor]];
    [ar addObject:[ThemeSelectObject getSunkistColor]];
    [ar addObject:[ThemeSelectObject getOceanColor]];
    
    
    float width = 75;
    
    float spacer = 15;
    
    int iter = 0;
    float yPos = 50;
    for (int i = 0; i < [ar count]; i++)
    {
    
        ColorSelectView *theView = [[ColorSelectView alloc] initWithFrame:CGRectMake(17 + iter * spacer + iter * width, yPos, width, width)];
        theView.theParentController = self;
    
        ThemeSelectObject *obj = [ar objectAtIndex:i];
        theView.primaryColor = obj.primaryColor;
        theView.secondaryColor = obj.secondaryColor;
        
        [theView load];
        [self.view addSubview:theView];
        
        iter++;
        
        if (i == 3)
        {
            iter = 0;
            yPos = 135;
        }
    }
}


-(void)colorSelectViewSelected:(ColorSelectView *)theView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [[ThemeManager sharedThemeManager] updateThemeColorWithPrimaryColor:theView.primaryColor withSecondaryColor:theView.secondaryColor];
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
