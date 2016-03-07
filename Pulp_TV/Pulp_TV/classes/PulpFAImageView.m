//
//  PulpFAImageView.m
//  Calendar
//
//  Created by Josh Klobe on 2/9/16.
//
//

#import "PulpFAImageView.h"

@implementation PulpFAImageView


-(void)loadWithColor:(UIColor *)theColor
{
    NSString *theString = [[NSString alloc] initWithString:self.referenceString];


    UIImage *icon = [UIImage imageWithIcon:theString backgroundColor:[UIColor clearColor] iconColor:theColor fontSize:self.desiredHeight];
    /*
    NSLog(@"self.referenceString: %@", self.referenceString);
    NSLog(@"icon!: %@", icon);
    NSLog(@"self.frame: %@", NSStringFromCGRect(self.frame));
    NSLog(@" ");
    NSLog(@" ");
    NSLog(@" ");
    */
    

    self.image = icon;
    
    self.referenceColor = theColor;
    
}



+(CGSize)getImageSizeFromString:(NSString *)iconString withDesiredHeight:(float)desiredHeight
{
    CGSize theSize = [UIImage imageWithIcon:iconString backgroundColor:[UIColor clearColor] iconColor:[UIColor blackColor] fontSize:desiredHeight].size;
    return theSize;
}
@end
