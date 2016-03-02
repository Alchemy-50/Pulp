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
@property (nonatomic, retain) UIImageView *coverImageView;

@end

@implementation MaskView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.backgroundColor = [UIColor clearColor];
    
    if (self.theImageView == nil)
    {
        self.theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.theImageView.image = [UIImage imageNamed:@"pulp-cal-circle-mask-trans-smlr.png"];
        [self addSubview:self.theImageView];
        
        [[ThemeManager sharedThemeManager] registerAdvisoryObject:self];
        
        
        self.coverImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.coverImageView.image = [UIImage imageNamed:@"pulp-cal-circle-mask-trans-smlr.png"];
        self.coverImageView.image = [self.theImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [self.coverImageView setTintColor:[UIColor colorWithWhite:0 alpha:.25]];
        [self addSubview:self.coverImageView];
    }
    
    
    
    return self;
}


-(void)adviseThemeUpdateWithPrimaryColor:(UIColor *)thePrimaryColor withSecondaryColor:(UIColor *)theSecondaryColor
{
    self.theImageView.image = [self.theImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.theImageView setTintColor:thePrimaryColor];
}

-(void)destroyViews
{
    [[ThemeManager sharedThemeManager] removeThemeObject:self];
    
    if (self.theImageView.image != nil)
    {
        self.theImageView.image = nil;
        [self.theImageView removeFromSuperview];
        self.theImageView = nil;
    }
    
    if (self.coverImageView.image != nil)
    {
        self.coverImageView.image = nil;
        [self.coverImageView removeFromSuperview];
        self.coverImageView = nil;
    }
    
}

@end
