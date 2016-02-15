//
//  ColorSelectView.h
//  Calendar
//
//  Created by Josh Klobe on 2/9/16.
//
//

#import <UIKit/UIKit.h>

@class ThemeSelectViewController;
@interface ColorSelectView : UIView

-(void)load;


@property (nonatomic, retain) id theParentController;
@property (nonatomic, retain) UIColor *primaryColor;
@property (nonatomic, retain) UIColor *secondaryColor;

@end
