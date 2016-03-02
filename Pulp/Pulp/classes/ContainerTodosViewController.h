//
//  ContainerTodosViewController.h
//  Calendar
//
//  Created by Josh Klobe on 5/20/14.
//
//

#import <UIKit/UIKit.h>
#import "TodosViewController.h"
#import "DailyTableViewCell.h"



@interface ContainerTodosViewController : UIViewController <UITextFieldDelegate>
{
    
}

-(void) beginEditWithDailyTableViewCell:(TodoTableViewCell *)theCell;
-(void) resignResponders;
-(void) viewDidShrink;
-(void) escapeButtonHit;

@property (nonatomic, retain) TodosViewController *todosViewController;
@property (nonatomic, retain) UILabel *addTodoLabel;
@property (nonatomic, assign) float xInset;
@property (nonatomic, retain) UITextField *textEntryField;
@property (nonatomic, retain) TodoTableViewCell *editingCell;
@property (nonatomic, assign) int timerCounter;
@property (nonatomic, assign) NSTimer *handlerTimer;
@property (nonatomic, retain) UIButton *exitButton;
@end

