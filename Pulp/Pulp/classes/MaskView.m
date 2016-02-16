//
//  MaskView.m
//  Calendar
//
//  Created by Josh Klobe on 2/12/16.
//
//

#import "MaskView.h"
#import "ThemeManager.h"


@interface MaskView ()
@property (nonatomic, retain) UIImageView *theImageView;
@end

@implementation MaskView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor clearColor];
    
    
    self.theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.theImageView.image = [UIImage imageNamed:@"Untitled-7.png"];
    [self addSubview:self.theImageView];
    
    [[ThemeManager sharedThemeManager] registerAdvisoryObject:self];
    
    UIImageView *coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    coverImageView.image = [UIImage imageNamed:@"Untitled-7.png"];
    coverImageView.image = [self.theImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [coverImageView setTintColor:[UIColor colorWithWhite:0 alpha:.25]];
    [self addSubview:coverImageView];
    
    
    
    
    return self;
}
                                 
-(void)adviseThemeUpdateWithPrimaryColor:(UIColor *)thePrimaryColor withSecondaryColor:(UIColor *)theSecondaryColor
{
    self.theImageView.image = [self.theImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.theImageView setTintColor:thePrimaryColor];
    
    
}

                                 
@end
