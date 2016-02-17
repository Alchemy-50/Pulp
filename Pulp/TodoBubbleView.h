//
//  TodoBubbleView.h
//  Pulp
//
//  Created by Josh Klobe on 2/17/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TodoBubbleView : UIView


+(TodoBubbleView *)sharedTodoBubbleView;
-(void)updateTodoValue;
@end
