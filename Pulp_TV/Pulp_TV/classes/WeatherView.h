//
//  WeatherView.h
//  Calendar
//
//  Created by Josh Klobe on 2/26/14.
//
//

#import <UIKit/UIKit.h>

@interface WeatherView : UIView
{
    UIImageView *iconImageView;
    UILabel *weatherLabel;

}

-(void)loadWithDictionary:(NSDictionary *)weatherDictionary;
-(void)imageReturnedWithImage:(UIImage *)theImage;

@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UILabel *weatherLabel;
@end
