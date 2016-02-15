//
//  SidebarButtonView.h
//  Calendar
//
//  Created by Josh Klobe on 2/11/16.
//
//

#import <UIKit/UIKit.h>

#define SIDEBAR_BUTTON_TYPE_CHEVRON 1
#define SIDEBAR_BUTTON_TYPE_CHECKSQUARE 2
#define SIDEBAR_BUTTON_TYPE_CALENDAR 3
#define SIDEBAR_BUTTON_TYPE_COG 4

@interface SidebarButtonView : UIScrollView

+(void)toggleButtonStatesWithSelectedButton:(SidebarButtonView *)theSelectedButton;

-(void)loadWithType:(int)theType;
-(void)adviseThemeUpdateWithPrimaryColor:(UIColor *)thePrimaryColor withSecondaryColor:(UIColor *)theSecondaryColor;
@end
