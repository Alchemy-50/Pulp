//
//  TodoTableViewCell.m
//  Calendar
//
//  Created by Josh Klobe on 7/11/14.
//
//

#import "TodoTableViewCell.h"
#import "TodoObject.h"
#import "TodosViewController.h"
#import "ContainerTodosViewController.h"
#import "ThemeManager.h"
#import "Utils.h"


@implementation TodoTableViewCell

@synthesize todoEditTextField;
@synthesize todoTitleLabel;
@synthesize todoCheckButton;
@synthesize todoCheckImageView;
@synthesize todoBottomLine;
@synthesize doubleTapGestureRecognizer;
@synthesize todosViewController;
@synthesize theIndexPath;
@synthesize referenceTodoObject;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}



-(void)loadViews
{
    if (self.todoTitleLabel == nil)
    {
        float cutFloat = 1.8;
        float todoHeight = 40;
        float tierTwoLabelInsetX2 = self.frame.size.width * .15;
        
        
        float insetValue = 44;
        self.frame = CGRectMake(insetValue, self.frame.origin.y, self.frame.size.width - insetValue, self.frame.size.height);
        
        
        self.todoTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(tierTwoLabelInsetX2, todoHeight / 2 - 10 - cutFloat, self.frame.size.width - 25, 23)];
        self.todoTitleLabel.textColor = [UIColor whiteColor];
        self.todoTitleLabel.adjustsFontSizeToFitWidth = NO;
        self.todoTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.todoTitleLabel.backgroundColor = [UIColor clearColor];
        self.todoTitleLabel.textAlignment = NSTextAlignmentLeft;
        self.todoTitleLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
        [self addSubview:self.todoTitleLabel];
        
        
        
        float desiredHeight = [UIImage imageNamed:@"todo-uncheckednew.png"].size.width;
        CGSize actualSize = [PulpFAImageView getImageSizeFromString:@"fa-check-circle" withDesiredHeight:desiredHeight];

        
        self.todoCheckImageView = [[PulpFAImageView alloc] initWithFrame:CGRectMake(self.todoTitleLabel.frame.origin.x - 30, self.frame.size.height / 2 - actualSize.height / 2, actualSize.width, actualSize.height)];
        self.todoCheckImageView.referenceString = @"fa-check-circle-o";
        self.todoCheckImageView.desiredHeight = desiredHeight;
        [self addSubview:self.todoCheckImageView];

        [[ThemeManager sharedThemeManager] registerPrimaryObject:self.todoCheckImageView];

        
        
        self.todoCheckButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        self.todoCheckButton.backgroundColor = [UIColor clearColor];
        self.todoCheckButton.frame = CGRectMake(0, 0, self.todoTitleLabel.frame.origin.x, self.frame.size.height);
        [self.todoCheckButton addTarget:self action:@selector(todoCheckButtonHit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.todoCheckButton];
        self.todoCheckButton.alpha = 0;
        
        
        self.theBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [Utils getScreenWidth], self.frame.size.height - cutFloat)];
        self.theBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:.15];
        [self addSubview:self.theBackgroundView];
        
        
    }
    
    
}

-(void)loadWithTodoObject:(TodoObject *)todoObject
{
    self.referenceTodoObject = todoObject;
    
    self.todoTitleLabel.text = @"";
    self.todoBottomLine.alpha = 1;
    self.todoCheckButton.alpha = 1;
    self.todoCheckImageView.alpha = 1;
    self.todoTitleLabel.text = todoObject.todoString;
    self.todoTitleLabel.textColor = [UIColor whiteColor];
    
    if (self.doubleTapGestureRecognizer == nil)
    {
        self.doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editTodo)];
        self.doubleTapGestureRecognizer.numberOfTapsRequired = 1;
        [self addGestureRecognizer:self.doubleTapGestureRecognizer];
    }
    
}




-(void)todoCheckButtonHit
{
    [self.todosViewController cellCallForDeletion:self];
}



- (void) editTodo
{
    if (self.todoEditTextField == nil)
    {
        [self.todosViewController.containerTodosViewController beginEditWithDailyTableViewCell:self];
        
        self.todoTitleLabel.alpha = 0;
        self.todoEditTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.todoTitleLabel.frame.origin.x, self.todoTitleLabel.frame.origin.y, self.todoTitleLabel.frame.size.width, self.todoTitleLabel.frame.size.height)];
        self.todoEditTextField.delegate = self;
        self.todoEditTextField.backgroundColor = [UIColor clearColor];
        self.todoEditTextField.textColor = self.todoTitleLabel.textColor;
        self.todoEditTextField.textAlignment = NSTextAlignmentLeft;
        self.todoEditTextField.text = self.todoTitleLabel.text;
        self.todoEditTextField.font = self.todoTitleLabel.font;
        [self addSubview:self.todoEditTextField];
        
        [self.todoEditTextField becomeFirstResponder];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self.todosViewController upateTodoAtIndexPath:self.theIndexPath withText:textField.text];
    
    
    self.todoTitleLabel.text = textField.text;
    self.todoTitleLabel.alpha = 1;
    [self.todoEditTextField resignFirstResponder];
    
    if (self.todoEditTextField != nil)
    {
        [self.todoEditTextField removeFromSuperview];
        [self.todoEditTextField release];
        self.todoEditTextField = nil;
    }
    
    [self.todosViewController.containerTodosViewController resignResponders];
    
    return NO;
}

-(void)textFieldShouldCancel
{
    self.todoTitleLabel.alpha = 1;
    [self.todoEditTextField resignFirstResponder];
    
    if (self.todoEditTextField != nil)
    {
        [self.todoEditTextField removeFromSuperview];
        [self.todoEditTextField release];
        self.todoEditTextField = nil;
    }
    
    [self.todosViewController.containerTodosViewController resignResponders];
}





@end
