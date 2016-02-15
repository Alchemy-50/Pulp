//
//  EventTaskSelectViewController.m
//  Calendar
//
//  Created by Josh Klobe on 6/5/14.
//
//

#import "EventTaskSelectViewController.h"
#import "EventKitManager.h"
#import "EventTaskSelectTableViewCell.h"
#import "CommonEventsManager.h"
#import "FullViewEventCreateViewController.h"
#import "CommonEventsOrderManager.h"


@interface EventTaskSelectViewController ()

@end

@implementation EventTaskSelectViewController


@synthesize commonEventsArray;
@synthesize theTableView;
@synthesize referenceCalendar;
@synthesize parentFullViewEventCreateViewController;
@synthesize isEditing;
@synthesize stopButton;
@synthesize editButton;
@synthesize editableIndexPath;
@synthesize isKeyboardShowHandled;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cellEditingIndex = -1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:@"UIKeyboardWillShowNotification"
                                               object:nil];
    
    self.view.backgroundColor = [UIColor redColor];
    
}


-(void)populateCommonEvents
{
    [self.commonEventsArray removeAllObjects];
    
    CommonEventContainer *calendarNameEventContainer = [[CommonEventContainer alloc] init];
    calendarNameEventContainer.entryType = COMMON_EVENT_ENTRY_TYPE_CALENDAR_NAME;
    calendarNameEventContainer.referenceCalendarIdentifier = self.referenceCalendar.calendarIdentifier;
    calendarNameEventContainer.title = self.referenceCalendar.title;
    [self.commonEventsArray addObject:calendarNameEventContainer];
    
    
    
    
    NSArray *preorderedArray = [[CommonEventsManager sharedEventsManager] getCommonEventsForCalendar:self.referenceCalendar];
    
    preorderedArray = [preorderedArray sortedArrayUsingComparator:^NSComparisonResult(CommonEventContainer *a, CommonEventContainer *b) {
        return [[CommonEventsOrderManager sharedEventsOrderManager] getPositionFromEvent:a] > [[CommonEventsOrderManager sharedEventsOrderManager] getPositionFromEvent:b];
    }];
    
    [self.commonEventsArray addObjectsFromArray:preorderedArray];
    
    
    
    
    CommonEventContainer *addButtonEventContainer = [[CommonEventContainer alloc] init];
    addButtonEventContainer.entryType = COMMON_EVENT_ENTRY_TYPE_ADD_BUTTON;
    [self.commonEventsArray addObject:addButtonEventContainer];
    
    
    
}

-(void)loadTheViewsWithCalendar:(EKCalendar *)selectedCalendar
{
    self.referenceCalendar = selectedCalendar;
    
    self.commonEventsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self populateCommonEvents];
    float yInset = 20;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, yInset,self.view.frame.size.width, self.view.frame.size.height - yInset)];
    bgView.backgroundColor = [UIColor blackColor];
    bgView.alpha = .45;
    [self.view addSubview:bgView];
    
    
    self.theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, yInset,self.view.frame.size.width, self.view.frame.size.height - 2 * yInset)];
    self.theTableView.separatorColor = [UIColor clearColor];
    self.theTableView.backgroundColor = [UIColor clearColor];
    self.theTableView.delegate = self;
    self.theTableView.dataSource = self;
    [self.view addSubview:self.theTableView];
    
    
    //    NSLog(@"commonEventsArray: %@", commonEventsArray);
    
    UILongPressGestureRecognizer *touchAndHoldRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressOccured:)];
    touchAndHoldRecognizer.minimumPressDuration = 0.6;
    [self.theTableView addGestureRecognizer:touchAndHoldRecognizer];
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [self.commonEventsArray count];
}



- (EventTaskSelectTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    EventTaskSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[EventTaskSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.parentEventTaskSelectViewController = self;
    }
    
    cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, tableView.frame.size.width, cell.frame.size.height);
    
    NSLog(@"cell[%ld].frame: %@", (long)indexPath.row, NSStringFromCGRect(cell.frame));
    
    CommonEventContainer *eventContainer = [self.commonEventsArray objectAtIndex:indexPath.row];
    
    if ((eventContainer.entryType == COMMON_EVENT_ENTRY_TYPE_REGULAR && self.cellEditingIndex == indexPath.row) || eventContainer.entryType == COMMON_EVENT_ENTRY_TYPE_ENTRY_FIELD)
    {
        self.editableIndexPath = indexPath;
        [cell loadEntryView];
    }
    else if (eventContainer.entryType == COMMON_EVENT_ENTRY_TYPE_REGULAR || eventContainer.entryType == COMMON_EVENT_ENTRY_TYPE_CALENDAR_NAME)
        [cell loadWithCommonEventContainer:eventContainer];
    else if (eventContainer.entryType == COMMON_EVENT_ENTRY_TYPE_ADD_BUTTON)
        [cell loadAddButtonView];
    
    
    
    
    
    
    return cell;
}

- (void) keyboardWillShow:(NSNotification *)note {
    
    if (!self.isKeyboardShowHandled)
    {
        self.isKeyboardShowHandled = YES;
        NSDictionary *userInfo = [note userInfo];
        CGSize kbSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        [self handleEntryPositionWithKeyboardHeight:kbSize.height];
    }
    
}
- (void) handleEntryPositionWithKeyboardHeight:(float)keyboardHeight
{
    
    
    CGRect cellRectInTableView = [self.theTableView rectForRowAtIndexPath:self.editableIndexPath];
    
    self.theTableView.contentSize = CGSizeMake(self.theTableView.contentSize.width, self.theTableView.contentSize.height * 2);
    
    float visibileHeight = self.view.frame.size.height - keyboardHeight - self.theTableView.frame.origin.y;
    
    
    float yOffset = 0;
    if (cellRectInTableView.origin.y + cellRectInTableView.size.height > visibileHeight)
    {
        yOffset = cellRectInTableView.origin.y -  visibileHeight + cellRectInTableView.size.height;
        
        [self.theTableView setContentOffset:CGPointMake(0, yOffset) animated:YES];
    }
    self.theTableView.scrollEnabled = NO;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"didSelectRowAtIndexPath!");
    
    CommonEventContainer *selectedEventContainer = [self.commonEventsArray objectAtIndex:indexPath.row];
    
    if (selectedEventContainer.entryType == COMMON_EVENT_ENTRY_TYPE_ADD_BUTTON)
    {
        [self populateCommonEvents];
        
        CommonEventContainer *addButtonEventContainer = [[CommonEventContainer alloc] init];
        addButtonEventContainer.entryType = COMMON_EVENT_ENTRY_TYPE_ENTRY_FIELD;
        [self.commonEventsArray insertObject:addButtonEventContainer atIndex:[self.commonEventsArray count] - 1];
        [self.theTableView reloadData];
    }
    else if (selectedEventContainer.entryType == COMMON_EVENT_ENTRY_TYPE_REGULAR)
    {
        
        if (self.isEditing)
        {
            self.cellEditingIndex = indexPath.row;
            NSLog(@"cellEditingIndex!: %ld", (long)indexPath.row);
            [self.theTableView reloadData];
        }
        else
            [self.parentFullViewEventCreateViewController commonTaskSelected:selectedEventContainer];
        
    }
    
    
    
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonEventContainer *theContainer = [self.commonEventsArray objectAtIndex:indexPath.row];
    if (theContainer.entryType == COMMON_EVENT_ENTRY_TYPE_REGULAR)
        return YES;
    else
        return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommonEventContainer *theContainer = [self.commonEventsArray objectAtIndex:indexPath.row];
    if (theContainer.entryType == COMMON_EVENT_ENTRY_TYPE_REGULAR)
        return YES;
    else
        return NO;
}


- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSLog(@"move event from int: %ld to int: %ld", (long)fromIndexPath.row, (long)toIndexPath.row);
    [[CommonEventsOrderManager sharedEventsOrderManager] moveEvent:[self.commonEventsArray objectAtIndex:fromIndexPath.row] toIndex:toIndexPath.row - 1];
    
}

- (void)tableView:(UITableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableView willBeginEditingRowAtIndexPath: %@", indexPath);
}

- (void)tableView:(UITableView *)tableView willEndEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"tableView willEndEditingRowAtIndexPath: %@", indexPath);
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        CommonEventContainer *theContainer = [self.commonEventsArray objectAtIndex:indexPath.row];
        [[CommonEventsManager sharedEventsManager] removeCommonEvent:theContainer forCalendar:self.referenceCalendar];
        [[CommonEventsOrderManager sharedEventsOrderManager] deleteEvent:theContainer];
        
        [self populateCommonEvents];
        [self.theTableView reloadData];
    }
}


-(void)doBeginEdit
{
    [self.theTableView setEditing:YES animated:YES];
    
    
    self.stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.stopButton.frame = CGRectMake(0, 20, 59.5, 40);
    self.stopButton.backgroundColor = [UIColor redColor];
    [self.stopButton addTarget:self action:@selector(stopButtonHit:) forControlEvents:UIControlEventTouchUpInside];
    [self.stopButton setTitle:@"Stop" forState:UIControlStateNormal];
    [self.view addSubview:self.stopButton];
    
    
    
    self.editButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.editButton.frame = CGRectMake(self.stopButton.frame.origin.x + self.stopButton.frame.size.width + 2, self.stopButton.frame.origin.y, self.stopButton.frame.size.width, 40);
    self.editButton.backgroundColor = [UIColor lightGrayColor];
    [self.editButton addTarget:self action:@selector(editButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self.editButton setTitle:@"Edit" forState:UIControlStateNormal];
    [self.view addSubview:self.editButton];
    
}
-(void)longPressOccured:(id)obj
{
    NSLog(@"longPressOccured");
    if (self.stopButton == nil)
    {
        self.stopButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.33];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(doBeginEdit)];
        self.theTableView.frame = CGRectMake(self.theTableView.frame.origin.x, self.theTableView.frame.origin.y, self.theTableView.frame.size.width * 2, self.theTableView.frame.size.height);
        self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.theTableView.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
        
        [self.theTableView reloadData];
        
        
        
        
    }
}


-(void)doEndEdit
{
    
    
    [self.stopButton removeFromSuperview];
    self.stopButton = nil;
    
    [self.editButton removeFromSuperview];
    self.stopButton = nil;
    
    [self populateCommonEvents];
    
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.33];
    self.theTableView.frame = CGRectMake(self.theTableView.frame.origin.x, self.theTableView.frame.origin.y, self.theTableView.frame.size.width / 2, self.theTableView.frame.size.height);
    self.view.frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y, self.theTableView.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];

    
    [self.theTableView reloadData];

    
}


-(void)stopButtonHit:(UIButton *)stopButton
{
    if (self.stopButton.alpha == 1)
    {
    
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:.33];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(doEndEdit)];
        self.stopButton.alpha = 0;
        self.editButton.alpha = 0;
        [UIView commitAnimations];

    
    
        self.isKeyboardShowHandled = NO;
        self.isEditing = NO;
        [self.theTableView setEditing:NO animated:YES];
        self.cellEditingIndex = -1;
    }
}

-(void)editButtonHit
{
    self.isKeyboardShowHandled = NO;
    self.editableIndexPath = nil;
    
    if (self.isEditing)
    {
        [self.editButton setBackgroundColor:[UIColor lightGrayColor]];
        self.isEditing = NO;
        [self.theTableView setEditing:YES animated:YES];
    }
    
    else
    {
        [self.editButton setBackgroundColor:[UIColor redColor]];
        self.isEditing = YES;
        [self.theTableView setEditing:NO animated:YES];
    }
}



- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    
    if (self.cellEditingIndex >= 0)
    {
        CommonEventContainer *theContainer = [self.commonEventsArray objectAtIndex:self.cellEditingIndex];
        [[CommonEventsOrderManager sharedEventsOrderManager] replaceTitle:theContainer withNewTitle:textField.text];
        theContainer.title = textField.text;
        [[CommonEventsManager sharedEventsManager] setCommonEvent:theContainer forCalendar:self.referenceCalendar];
        
        self.cellEditingIndex = -1;
        [self populateCommonEvents];
        [self.theTableView reloadData];
    }
    else
    {
        CommonEventContainer *commonEventContainer = [[CommonEventContainer alloc] init];
        commonEventContainer.title = textField.text;
        commonEventContainer.referenceCalendarIdentifier = self.referenceCalendar.calendarIdentifier;
        [[CommonEventsManager sharedEventsManager] setCommonEvent:commonEventContainer forCalendar:self.referenceCalendar];
        
        [textField resignFirstResponder];
        
        [self populateCommonEvents];
        [self.theTableView reloadData];
    }
    return NO;
}






@end
