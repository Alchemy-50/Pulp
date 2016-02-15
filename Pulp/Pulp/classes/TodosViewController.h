//
//  TodosViewController.h
//  Calendar
//
//  Created by Josh Klobe on 3/4/14.
//
//

#import <UIKit/UIKit.h>
#import "TodoTableViewCell.h"
#import "EventKitManager.h"

@class ContainerTodosViewController;


@interface TodosViewController : UITableViewController


-(void)cellCallForDeletion:(TodoTableViewCell *)theCell;
-(void)upateTodoAtIndexPath:(NSIndexPath *)referenceIndexPath withText:(NSString *)newString;
-(void)reloadTodos;
-(void)sizeViewWithKeyboardExposed:(BOOL)keyboardExposed;


@property (nonatomic, retain) ContainerTodosViewController *containerTodosViewController;
@property (nonatomic, retain) NSMutableArray *todosArray;
@property (nonatomic, assign) float cellXInset;
@property (nonatomic, assign) BOOL preventDeletion;
@property (nonatomic, assign) BOOL isEditing;
@property (nonatomic, retain) UIButton *stopEditingButton;
@end
