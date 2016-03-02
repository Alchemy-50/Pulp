//
//  ContainerTodosViewController.m
//  Calendar
//
//  Created by Josh Klobe on 5/20/14.
//
//

#import "ContainerTodosViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "TodoDataManager.h"
#import "ThemeManager.h"
#import "PulpFAImageView.h"

@interface ContainerTodosViewController ()

@end

@implementation ContainerTodosViewController

@synthesize todosViewController;
@synthesize addTodoLabel;
@synthesize xInset;
@synthesize textEntryField;
@synthesize editingCell;
@synthesize timerCounter;
@synthesize handlerTimer;
@synthesize exitButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}


- (void)viewDidLoad
{
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
        [self setNeedsStatusBarAppearanceUpdate];
    
    [super viewDidLoad];
    
    [[ThemeManager sharedThemeManager] registerPrimaryObject:self];

    
    UIView *coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width + 25, self.view.frame.size.height * 2)];
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
    [self.view insertSubview:coverView atIndex:0];

    
    
    
    
    UIView *theHeaderView = [[UIView alloc] initWithFrame:CGRectMake(-40, 0, self.view.frame.size.width, 50)];
    theHeaderView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:theHeaderView];
    
    
    float entryHeight = 30;
    UIView *entryBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(68, theHeaderView.frame.size.height / 2 - entryHeight / 2, self.view.frame.size.width * .6, entryHeight)];
    entryBackgroundView.layer.cornerRadius = 5.f;
    entryBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:.25];
    [theHeaderView addSubview:entryBackgroundView];
    
    
    self.addTodoLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, entryBackgroundView.frame.size.width, entryBackgroundView.frame.size.height)];
    self.addTodoLabel.backgroundColor = [UIColor clearColor];
    self.addTodoLabel.textAlignment = NSTextAlignmentLeft;
    self.addTodoLabel.textColor = [UIColor colorWithRed:30.0f/255.0f green:163.0f/255.0f blue:134.0f/255.0f alpha:1];
    self.addTodoLabel.font = [UIFont fontWithName:@"Lato-Bold" size:14];
    self.addTodoLabel.text = @"ADD TODO";
    [entryBackgroundView addSubview:self.addTodoLabel];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.addTodoLabel];
    
    
    self.textEntryField = [[UITextField alloc] initWithFrame:CGRectMake(self.addTodoLabel.frame.origin.x, self.addTodoLabel.frame.origin.y, self.addTodoLabel.frame.size.width * .9, self.addTodoLabel.frame.size.height)];
    self.textEntryField.delegate = self;
    self.textEntryField.backgroundColor = [UIColor clearColor];
    self.textEntryField.textColor = self.addTodoLabel.textColor;
    self.textEntryField.alpha = 1;
    self.textEntryField.font = self.addTodoLabel.font;
    [self.textEntryField setReturnKeyType:UIReturnKeyDone];
    [entryBackgroundView addSubview:self.textEntryField];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:self.textEntryField];
    
    self.todosViewController = [[TodosViewController alloc] initWithStyle:UITableViewStylePlain];
    self.todosViewController.tableView.backgroundColor = [UIColor clearColor];
    self.todosViewController.view.backgroundColor = [UIColor clearColor];
    self.todosViewController.containerTodosViewController = self;
    self.todosViewController.view.frame = CGRectMake(0, theHeaderView.frame.origin.y + theHeaderView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - theHeaderView.frame.origin.y - theHeaderView.frame.size.height);
    [self.view addSubview:self.todosViewController.view];
    [self.todosViewController reloadTodos];
    
    

    float desiredHeight = [UIImage imageNamed:@"todo-addnew.png"].size.width;
    CGSize actualSize = [PulpFAImageView getImageSizeFromString:@"fa-check-circle" withDesiredHeight:desiredHeight];

    
    PulpFAImageView *todoCheckImageView = [[PulpFAImageView alloc] initWithFrame:CGRectMake(self.addTodoLabel.frame.origin.x + self.addTodoLabel.frame.size.width + 25, entryBackgroundView.frame.size.height / 2 - actualSize.height / 2  + 12, actualSize.width, actualSize.height)];
    todoCheckImageView.desiredHeight = desiredHeight;
    todoCheckImageView.referenceString = @"fa-check-circle";
    [self.view addSubview:todoCheckImageView];
    [[ThemeManager sharedThemeManager] registerSecondaryObject:todoCheckImageView];

    
   
    
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    addButton.frame = CGRectMake(todoCheckImageView.frame.origin.x + 30, todoCheckImageView.frame.origin.y - 5, 60, todoCheckImageView.frame.size.height + 10);
    addButton.backgroundColor = [UIColor clearColor];
    [addButton addTarget:self action:@selector(addButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [theHeaderView addSubview:addButton];
    

    self.exitButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    self.exitButton.frame = CGRectMake(0, self.todosViewController.view.frame.origin.y, self.todosViewController.tableView.frame.size.width, 528);
    self.exitButton.backgroundColor = [UIColor clearColor];
    [self.exitButton addTarget:self action:@selector(escapeButtonHit) forControlEvents:UIControlEventTouchUpInside];

    
}

-(void)doTheSizing
{
    if ([self.todosViewController.todosArray count] > 6)
    {
        [self.todosViewController.tableView setContentOffset:CGPointMake(0, self.todosViewController.tableView.contentSize.height - 2 * 44 - (6 * 44) + 10) animated:NO];
        [self.todosViewController.tableView setContentOffset:CGPointMake(0, self.todosViewController.tableView.contentSize.height - 44 - (6 * 44) + 10) animated:YES];
    }
}


-(void)addButtonHit
{
    if ([self.textEntryField.text length] > 0)
    {
        [TodoDataManager saveTodoWithString:self.textEntryField.text];
        [self.todosViewController reloadTodos];
        self.textEntryField.text = @"";
        
        [self doTheSizing];
    }
}

- (void) beginEditWithDailyTableViewCell:(TodoTableViewCell *)theCell
{
    if ([self.exitButton superview] == nil)
        [self.view addSubview:self.exitButton];
    
    self.editingCell = theCell;
    
    
    NSLog(@"beginEditWithDailyTableViewCell");
    //[self.todosViewController sizeViewWithKeyboardExposed:YES];
    
    if ([self.todosViewController.todosArray count] > 6 && self.editingCell.theIndexPath.row > 6)
        [self.todosViewController.tableView setContentOffset:CGPointMake(0, ((self.editingCell.theIndexPath.row - 6) * 44) + 14) animated:YES];
    
}

-(void)viewDidShrink
{
    [self.todosViewController.tableView setContentOffset:CGPointMake(0, self.todosViewController.tableView.contentSize.height - 44 - (6 * 44) + 10) animated:YES];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSLog(@"textFieldShouldBeginEditing!");
    if ([self.exitButton superview] == nil)
        [self.view addSubview:self.exitButton];
    
    if ([self.textEntryField.placeholder compare:@""] == NSOrderedSame)
    {
        self.addTodoLabel.alpha = 0;
        self.textEntryField.placeholder = @"ADD TODO";
        
//        [self doTheSizing];
//        [self.todosViewController sizeViewWithKeyboardExposed:YES];
    }
    return YES;
}





- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self addButtonHit];
    /*
    if ([self.textEntryField.text length] > 0)
    {
        [TodoDataManager saveTodoWithString:self.textEntryField.text];
        [self.todosViewController reloadTodos];
    }
    [self escapeButtonHit];
     
     */
    return NO;
}


-(void)escapeButtonHit
{
    if ([self.textEntryField isFirstResponder] || [self.editingCell.todoEditTextField isFirstResponder])
    {
        NSLog(@"escapeButtonHit");
        [self.todosViewController sizeViewWithKeyboardExposed:NO];
        
        [self.textEntryField resignFirstResponder];
        
        
        self.textEntryField.placeholder = @"";
        self.textEntryField.text = @"";
        
        self.addTodoLabel.alpha = 1;
        
        if (self.editingCell != nil)
        {
            [self.editingCell textFieldShouldCancel];
            self.editingCell = nil;
            
            
        }
        
        if ([self.exitButton superview] != nil)
            [self.exitButton removeFromSuperview];
    }
}


- (void) resignResponders
{
    [self.todosViewController sizeViewWithKeyboardExposed:NO];
    
    if ([self.textEntryField isFirstResponder])
        [self.textEntryField resignFirstResponder];
    
    if ([self.editingCell.todoEditTextField isFirstResponder])
        [self.editingCell.todoEditTextField resignFirstResponder];

    if ([self.exitButton superview] != nil)
        [self.exitButton removeFromSuperview];
    
    
}





@end
