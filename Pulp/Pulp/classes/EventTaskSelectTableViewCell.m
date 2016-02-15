//
//  EventTaskSelectTableViewCell.m
//  Calendar
//
//  Created by Alchemy50 on 6/6/14.
//
//

#import "EventTaskSelectTableViewCell.h"
#import "EventKitManager.h"
#import "EventTaskSelectViewController.h"
@implementation EventTaskSelectTableViewCell

@synthesize parentEventTaskSelectViewController;
@synthesize backgroundView;
@synthesize typeImageView;
@synthesize taskLabel;
@synthesize separatorView;
@synthesize addImageView;
@synthesize addingEntryField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initializeAndPrepare
{
    float inset = 25;
    
    
    if (self.backgroundView == nil)
    {
        self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.backgroundView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.backgroundView];
    }
    
    if (self.taskLabel == nil)
    {
        
        self.taskLabel = [[UILabel alloc] initWithFrame:CGRectMake(inset, 0, self.frame.size.width - inset, self.frame.size.height)];
        self.taskLabel.backgroundColor = [UIColor clearColor];
        self.taskLabel.textAlignment = NSTextAlignmentLeft;
        self.taskLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
        [self addSubview:self.taskLabel];
    }
    
    if (self.separatorView == nil)
    {
        self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        self.separatorView.backgroundColor = [UIColor blackColor];
        [self addSubview:self.separatorView];
    }
    
    if (self.addImageView == nil)
    {
        UIImage *theImage = [UIImage imageNamed:@"add-event-plus_new.png"];
        
        self.addImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width / 2 - theImage.size.width / 2, self.frame.size.height / 2 - theImage.size.height / 2, theImage.size.width, theImage.size.height)];
        [self addSubview:self.addImageView];
    }
    
    if (self.addingEntryField == nil)
    {
        self.addingEntryField = [[UITextField alloc] initWithFrame:CGRectMake(self.taskLabel.frame.origin.x, 0, self.frame.size.width - self.taskLabel.frame.origin.x, self.frame.size.height)];
        self.addingEntryField.backgroundColor = [UIColor clearColor];
        self.addingEntryField.textAlignment = NSTextAlignmentLeft;
        self.addingEntryField.font = self.taskLabel.font;
        [self addSubview:self.addingEntryField];
    }
    
    if (self.backgroundView.frame.size.width < self.frame.size.width)
    {
        NSLog(@"expanding!");
        self.backgroundView.frame = CGRectMake(self.backgroundView.frame.origin.x, self.backgroundView.frame.origin.y, self.frame.size.width, self.backgroundView.frame.size.height);
        self.separatorView.frame = CGRectMake(self.separatorView.frame.origin.x, self.separatorView.frame.origin.y, self.frame.size.width, self.separatorView.frame.size.height);
        self.taskLabel.frame = CGRectMake(self.taskLabel.frame.origin.x + inset, self.taskLabel.frame.origin.y, self.frame.size.width -  (2 * inset), self.taskLabel.frame.size.height);
    }
    else if (self.backgroundView.frame.size.width > self.frame.size.width)
    {
        NSLog(@"contracting!!");
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.33];
        [UIView setAnimationDelegate:self];

        self.backgroundView.frame = CGRectMake(self.backgroundView.frame.origin.x, self.backgroundView.frame.origin.y, self.frame.size.width, self.backgroundView.frame.size.height);
        self.separatorView.frame = CGRectMake(self.separatorView.frame.origin.x, self.separatorView.frame.origin.y, self.frame.size.width, self.separatorView.frame.size.height);
        self.taskLabel.frame = CGRectMake(inset, 0, self.frame.size.width - inset, self.frame.size.height);
        [UIView commitAnimations];
    }
    
    
    self.taskLabel.textColor = [UIColor whiteColor];
    
    self.addingEntryField.textColor = [UIColor whiteColor];
    self.addingEntryField.text = @"";
    self.addingEntryField.alpha = 0;
    self.addImageView.image = nil;
    self.backgroundView.alpha = 1;
    self.backgroundView.backgroundColor = [UIColor clearColor];
    self.taskLabel.text = @"";
}

-(void) loadWithCommonEventContainer:(CommonEventContainer *)theContainer
{
    [self initializeAndPrepare];
    
    EKCalendar *theCalendar = [[EventKitManager sharedManager] getEKCalendarWithIdentifier:theContainer.referenceCalendarIdentifier];

    if (theContainer.entryType == COMMON_EVENT_ENTRY_TYPE_CALENDAR_NAME)
    {
        self.backgroundView.backgroundColor = [UIColor blackColor];
        self.taskLabel.textColor = [UIColor colorWithCGColor:theCalendar.CGColor];
    }
    else
    {
        self.backgroundView.backgroundColor = [UIColor colorWithCGColor:theCalendar.CGColor];
    }
    self.taskLabel.text = theContainer.title;
    
}

-(void)loadAddButtonView
{
    [self initializeAndPrepare];
    
    self.backgroundView.backgroundColor = [UIColor blackColor];//[UIColor colorWithRed:11.0f/255.0f green:76.0f/255.0f blue:62.0f/255.0f alpha:1];
//    self.backgroundView.alpha = .5;
    self.addImageView.image = [UIImage imageNamed:@"add-event-plus_new.png"];
    
}

-(void)loadEntryView
{
    [self initializeAndPrepare];
    
    self.backgroundView.backgroundColor = [UIColor colorWithRed:11.0f/255.0f green:76.0f/255.0f blue:62.0f/255.0f alpha:1];
//    self.backgroundView.alpha = .5;
    self.addingEntryField.alpha = 1;
    [self.addingEntryField performSelectorOnMainThread:@selector(becomeFirstResponder) withObject:nil waitUntilDone:NO];
    self.addingEntryField.delegate = self.parentEventTaskSelectViewController;
}




@end
