//
//  TodosViewController.m
//  Calendar
//
//  Created by Josh Klobe on 3/4/14.
//
//

#import "TodosViewController.h"
#import "DailyTableViewCell.h"
#import "EventKitManager.h"
#import "AppDelegate.h"
#import "ContainerTodosViewController.h"
#import "TodoDataManager.h"
#import "TodoObject.h"
#import "TodoTableViewCell.h"

#import "ThemeManager.h"


@interface TodosViewController ()

@end

@implementation TodosViewController


@synthesize todosArray;
@synthesize cellXInset;
@synthesize containerTodosViewController;
@synthesize preventDeletion;
@synthesize isEditing;
@synthesize stopEditingButton;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        

          
        // Custom initialization
    }
    return self;
}




-(void)reloadTodos
{
    [self.todosArray removeAllObjects];
    [self.todosArray addObjectsFromArray:[TodoDataManager getAllTodos]];
    [self.tableView reloadData];

    self.tableView.contentSize = CGSizeMake(0, ([self.todosArray count] * 44));
}

- (void)viewDidLoad
{
    
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.todosArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureHit)];
    [self.tableView addGestureRecognizer:tapGestureRecognizer];
    
    UILongPressGestureRecognizer *touchAndHoldRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOccured:)];
    touchAndHoldRecognizer.minimumPressDuration = 0.6;
//    [self.view addGestureRecognizer:touchAndHoldRecognizer];
    
    [self reloadTodos];
 
}

-(void)tapGestureHit
{
    [self.containerTodosViewController escapeButtonHit];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    self.tableView.backgroundColor = [UIColor clearColor];
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.todosArray count];
}

- (TodoTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    TodoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[TodoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.todosViewController = self;
//        cell.insetValue = self.cellXInset;
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, self.view.frame.size.width, cell.frame.size.height);
        [cell loadViews];
        cell.backgroundColor = [UIColor clearColor];
    }
    
    
    
    cell.theIndexPath = indexPath;
    
    [cell loadWithTodoObject:[self.todosArray objectAtIndex:indexPath.row]];
    return cell;
}

-(void)sizeViewWithKeyboardExposed:(BOOL)keyboardExposed
{    
    if (self.tableView.frame.size.height == 508 && keyboardExposed)
    {
        if (self.tableView.frame.size.height != 294)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:.27];
            [UIView setAnimationDelegate:self.containerTodosViewController];
            [UIView setAnimationDidStopSelector:@selector(viewDidShrink)];
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, 294);
            [UIView commitAnimations];
        }
    }
    else
    {
        if (self.tableView.frame.size.height != 508)
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, 508);
    }
    
    

    
}
-(void)cellCallForDeletion:(TodoTableViewCell *)theCell
{    
    if (!self.preventDeletion)
    {
        self.preventDeletion = YES;
        
        [TodoDataManager deleteTodo:[self.todosArray objectAtIndex:theCell.theIndexPath.row]];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.18];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationFinished:finished:context:)];
        theCell.frame = CGRectMake(theCell.frame.origin.x + theCell.frame.size.width, theCell.frame.origin.y, theCell.frame.size.width, theCell.frame.size.height);
        [UIView commitAnimations];
        

    }
}

-(void)upateTodoAtIndexPath:(NSIndexPath *)referenceIndexPath withText:(NSString *)newString
{
    TodoObject *obj = [self.todosArray objectAtIndex:referenceIndexPath.row];
    obj.todoString = newString;
    [TodoDataManager updateObjectWithTodo:obj];
    
    [self reloadTodos];
}

-(void)longPressOccured:(id)obj
{
    NSLog(@"longPressOccured");
    if (!self.isEditing)
    {
        
        self.isEditing = YES;
        [self.tableView setEditing:YES animated:YES];
        
        if (self.stopEditingButton == nil)
        {
            self.stopEditingButton = [UIButton buttonWithType:UIButtonTypeCustom];
            self.stopEditingButton.frame = CGRectMake(320 / 2 - 50, 10, 100, 40);
            self.stopEditingButton.backgroundColor = [UIColor redColor];
            [self.stopEditingButton addTarget:self action:@selector(stopEditingButtonHit) forControlEvents:UIControlEventTouchUpInside];
            [self.stopEditingButton setTitle:@"Stop" forState:UIControlStateNormal];
            [self.containerTodosViewController.view addSubview:self.stopEditingButton];
        }
        
    }
}

-(void)stopEditingButtonHit
{
    self.isEditing = NO;
    [self.tableView setEditing:NO animated:YES];
    [self.stopEditingButton removeFromSuperview];
    self.stopEditingButton = nil;
}


- (void)animationFinished:(NSString *)animationID finished:(BOOL)finished context:(void *)context
{
    [self reloadTodos];
    self.preventDeletion = NO;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"move event from int: %ld to int: %ld", (long)fromIndexPath.row, (long)toIndexPath.row);
    [TodoDataManager moveTodoFrom:fromIndexPath.row to:toIndexPath.row];
    
    [self reloadTodos];
//    [[TodoOrderManager sharedTodoOrderManager] moveEvent:[self.todosArray objectAtIndex:fromIndexPath.row] toIndex:toIndexPath.row];
    
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}




- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}



@end
