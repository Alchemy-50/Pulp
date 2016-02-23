//
//  UpdatingCoverView.m
//  Pulp
//
//  Created by Josh Klobe on 2/23/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "UpdatingCoverView.h"

@implementation UpdatingCoverView


-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    bgView.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
    [self addSubview:bgView];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height / 2 - 16, self.frame.size.width, 16)];
    loadingLabel.backgroundColor = [UIColor clearColor];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.textColor = [UIColor whiteColor];
    loadingLabel.font = [UIFont systemFontOfSize:16];
    loadingLabel.text = @"Loading...";
    [self addSubview:loadingLabel];
    
    
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicatorView.frame = CGRectMake(self.frame.size.width / 2 - indicatorView.frame.size.width / 2, self.frame.size.height / 2, indicatorView.frame.size.width, indicatorView.frame.size.height);
    [self addSubview:indicatorView];
    [indicatorView startAnimating];
    
    return self;
}

@end
