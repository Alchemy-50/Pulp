//
//  PulpFAImageView.h
//  Calendar
//
//  Created by Josh Klobe on 2/9/16.
//
//

#import "FAImageView.h"
#import "UIImage+FontAwesome.h"

@interface PulpFAImageView : FAImageView

-(void)loadWithColor:(UIColor *)theColor;
+(CGSize)getImageSizeFromString:(NSString *)iconString withDesiredHeight:(float)desiredHeight;

@property (nonatomic, retain) NSString *referenceString;
@property (nonatomic, assign) float desiredHeight;
@end
