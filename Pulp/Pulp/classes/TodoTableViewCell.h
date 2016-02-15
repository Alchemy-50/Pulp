//
//  TodoTableViewCell.h
//  Calendar
//
//  Created by Josh Klobe on 7/11/14.
//
//

#import <UIKit/UIKit.h>
#import "TodoObject.h"
#import "PulpFAImageView.h"
@class TodosViewController;

@interface TodoTableViewCell : UITableViewCell <UITextFieldDelegate>



-(void)loadViews;
-(void)loadWithTodoObject:(TodoObject *)todoObject;
-(void)textFieldShouldCancel;

@property (nonatomic, retain) TodoObject *referenceTodoObject;
@property (nonatomic, retain) UITextField *todoEditTextField;
@property (nonatomic, retain) UILabel *todoTitleLabel;
@property (nonatomic, retain) UIButton *todoCheckButton;
@property (nonatomic, retain) PulpFAImageView *todoCheckImageView;
@property (nonatomic, retain) UIView *todoBottomLine;
@property (nonatomic, retain) UIView *theBackgroundView;
@property (nonatomic, retain) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic, retain) TodosViewController *todosViewController;
@property (nonatomic, retain) NSIndexPath *theIndexPath;

@end
