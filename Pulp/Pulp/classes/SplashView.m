//
//  SplashView.m
//  Calendar
//
//  Created by jay canty on 3/12/12.
//  Copyright (c) 2012 A 50. All rights reserved.
//

#import "SplashView.h"

@implementation SplashView

@synthesize theImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *splashImage = [UIImage imageNamed:@"Default.png"];
        
        self.theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,self.frame.size.width, self.frame.size.height)];
//        self.theImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,0,splashImage.size.width, splashImage.size.height)];
        self.theImageView.image = splashImage;
//        self.theImageView.image = [UIImage imageNamed:@"Default.png"];
        [self addSubview:self.theImageView];
        
    }
    return self;
}


-(void) resize
{
    /*
    self.appTitle.frame = CGRectMake(0,0,self.frame.size.width, 80);
    progressWheel.frame = CGRectMake(self.frame.size.width/2 - 40, 
                                     self.frame.size.height * .5, 80, 80);    
     */
    
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
