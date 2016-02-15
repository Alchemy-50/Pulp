//
//  DailyTodoImageView.m
//  Calendar
//
//  Created by Josh Klobe on 5/27/14.
//
//

#import "DailyTodoImageView.h"

@implementation DailyTodoImageView

@synthesize countLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        UIImageView *theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        theImageView.image = [UIImage imageNamed:@"to-do-triangle.png"];
        [self addSubview:theImageView];


        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(22, self.frame.size.height / 2 + 4, 25, self.frame.size.height / 2 - 4)];
        self.countLabel.backgroundColor = [UIColor clearColor];
        self.countLabel.textColor = [UIColor whiteColor];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.countLabel];
        self.countLabel.text = @"0";
        
        // Initialization code
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
