//
//  TodoBubbleView.m
//  Pulp
//
//  Created by Josh Klobe on 2/17/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "TodoBubbleView.h"
#import "TodoDataManager.h"

@interface TodoBubbleView ()
@property (nonatomic, retain) UILabel *theLabel;
@end

@implementation TodoBubbleView

static TodoBubbleView *theStaticView;

+(TodoBubbleView *)sharedTodoBubbleView
{
    if (theStaticView == nil)
    {
        theStaticView = [[TodoBubbleView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
        theStaticView.backgroundColor = [UIColor whiteColor];
        theStaticView.layer.cornerRadius = theStaticView.frame.size.width / 2.0f;
        theStaticView.clipsToBounds = YES;
        
        theStaticView.theLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, theStaticView.frame.size.width, theStaticView.frame.size.height)];
        theStaticView.theLabel.backgroundColor = [UIColor whiteColor];
        theStaticView.theLabel.textAlignment = NSTextAlignmentCenter;
        theStaticView.theLabel.textColor = [UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1];
        theStaticView.theLabel.font = [UIFont fontWithName:@"Lato-Black" size:10];
        [theStaticView addSubview:theStaticView.theLabel];
        
        [theStaticView updateTodoValue];
        
    }
    
    return theStaticView;
}

-(void)updateTodoValue
{
    self.theLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)[[TodoDataManager getAllTodos] count]];
}

@end
