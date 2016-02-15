//
//  ProgessAlertView.m
//  Calendar
//
//  Created by Josh Klobe on 3/4/14.
//
//

#import "ProgessAlertView.h"

@implementation ProgessAlertView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.67];

        UIActivityIndicatorView *theIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        theIndicatorView.frame = CGRectMake(self.frame.size.width / 2 - theIndicatorView.frame.size.width / 2, self.frame.size.height / 2 - theIndicatorView.frame.size.width / 2, theIndicatorView.frame.size.width, theIndicatorView.frame.size.height);
        [self addSubview:theIndicatorView];
        [theIndicatorView startAnimating];

        
        UILabel *theLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, theIndicatorView.frame.origin.y + theIndicatorView.frame.size.height + 5, self.frame.size.width, 25)];
        theLabel.backgroundColor = [UIColor clearColor];
        theLabel.textColor = [UIColor whiteColor];
        theLabel.textAlignment = NSTextAlignmentCenter;
        theLabel.font = [UIFont systemFontOfSize:19];
        theLabel.text = @"Loading...";
        [self addSubview:theLabel];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
