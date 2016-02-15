//
//  CalendarManagementTableViewCell.m
//  Calendar
//
//  Created by Alchemy50 on 7/11/14.
//
//

#import "AppDelegate.h"
#import "CalendarManagementTableViewCell.h"
#import "GroupDiskManager.h"
#import "EventKitManager.h"
#import "CalendarManagementTableViewController.h"




@implementation CalendarManagementTableViewCell

@synthesize referenceCalendar;
@synthesize parentCalendarManagementTableViewController;
@synthesize checkBoxImageView;
@synthesize calendarNameLabel;
@synthesize sourceNameLabel;
@synthesize cogImageView;
@synthesize addBackgroundView;
@synthesize addCalendarLabel;
@synthesize separatorView;
@synthesize checkButton;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)cleanViews
{
    if (self.checkBoxImageView != nil)
    {
        [self.checkBoxImageView removeFromSuperview];
        [self.checkBoxImageView release];
        self.checkBoxImageView = nil;
    }
    
    
    if (self.calendarNameLabel != nil)
    {
        [self.calendarNameLabel removeFromSuperview];
        [self.calendarNameLabel release];
        self.calendarNameLabel = nil;
    }
    
    
    if (self.sourceNameLabel != nil)
    {
        [self.sourceNameLabel removeFromSuperview];
        [self.sourceNameLabel release];
        self.sourceNameLabel = nil;
    }
    
    
    if (self.cogImageView != nil)
    {
        [self.cogImageView removeFromSuperview];
        [self.cogImageView release];
        self.cogImageView = nil;
    }
    
    
    if (self.addBackgroundView != nil)
    {
        [self.addBackgroundView removeFromSuperview];
        [self.addBackgroundView release];
        self.addBackgroundView = nil;
    }
    

    if (self.addCalendarLabel != nil)
    {
        [self.addCalendarLabel removeFromSuperview];
        [self.addCalendarLabel release];
        self.addCalendarLabel = nil;
    }
    

    if (self.separatorView != nil)
    {
        [self.separatorView removeFromSuperview];
        [self.separatorView release];
        self.separatorView = nil;
    }
    

    if (self.checkButton != nil)
    {
        [self.checkButton removeFromSuperview];
        [self.checkButton release];
        self.checkButton = nil;
    }
    
    
}

-(void)loadWithCalendar:(EKCalendar *)theCalendar
{
    self.referenceCalendar = theCalendar;
    
    if (self.addBackgroundView != nil)
    {
        [self.addBackgroundView removeFromSuperview];
        [self.addBackgroundView release];
        self.addBackgroundView = nil;
        
    }
    
    if (self.addCalendarLabel != nil)
    {
        [self.addCalendarLabel removeFromSuperview];
        [self.addCalendarLabel release];
        self.addCalendarLabel = nil;
        
    }
    
    if (self.checkBoxImageView == nil)
    {
        float checkInset = 8;
        self.checkBoxImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, self.frame.size.height / 2 - 20, 40, 40)];
        [self addSubview:self.checkBoxImageView];
        
        self.checkButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
        self.checkButton.frame = CGRectMake(0, 0, self.checkBoxImageView.frame.origin.x + self.checkBoxImageView.frame.size.width + 3, self.frame.size.height);
        [self.checkButton addTarget:self action:@selector(checkButtonHit) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:checkButton];
        
        
        self.calendarNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.checkBoxImageView.frame.origin.x + self.checkBoxImageView.frame.size.width + 8, self.checkBoxImageView.frame.origin.y + 6, self.frame.size.width - 130, self.checkBoxImageView.frame.size.height / 2)];
        self.calendarNameLabel.backgroundColor = [UIColor clearColor];
        self.calendarNameLabel.textColor = [UIColor whiteColor];
        self.calendarNameLabel.font = [UIFont fontWithName:@"Lato-Bold" size:16];
        self.calendarNameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.calendarNameLabel];
        
        
        self.sourceNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.calendarNameLabel.frame.origin.x, self.calendarNameLabel.frame.origin.y + self.calendarNameLabel.frame.size.height - 7, self.calendarNameLabel.frame.size.width, self.calendarNameLabel.frame.size.height)];
        self.sourceNameLabel.backgroundColor = [UIColor clearColor];
        self.sourceNameLabel.textColor = [UIColor whiteColor];
        self.sourceNameLabel.font = [UIFont fontWithName:@"Lato-Bold" size:9];
        self.sourceNameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.sourceNameLabel];
        
        self.cogImageView = [[UIImageView alloc] initWithFrame:CGRectMake(240, checkInset - 4, self.frame.size.height - checkInset, self.frame.size.height - checkInset)];
        self.cogImageView.image = [UIImage imageNamed:@"settings-btn.png"];
        [self addSubview:self.cogImageView];
        
        UIButton *cogButton = [UIButton buttonWithType:UIButtonTypeCustom];
        cogButton.frame = CGRectMake(self.cogImageView.frame.origin.x, 0, self.frame.size.width - self.cogImageView.frame.origin.x, self.cogImageView.frame.size.height);
        [cogButton addTarget:self action:@selector(cogButtonHit) forControlEvents:UIControlEventTouchUpInside];
        cogButton.backgroundColor = [UIColor redColor];
        [self addSubview:cogButton];

        
        self.separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        separatorView.backgroundColor = [UIColor blackColor];
        [self addSubview:separatorView];
    }
    
    self.backgroundColor = [UIColor colorWithCGColor:theCalendar.CGColor];
    self.calendarNameLabel.text = theCalendar.title;
    self.sourceNameLabel.text = theCalendar.source.title;
    
    [self setCheckBoxImageViewState];
}


-(void) loadForAddCalendar
{
    self.backgroundColor = [UIColor clearColor];
    
    self.referenceCalendar = nil;
    if (self.checkBoxImageView != nil)
    {
        [self.checkBoxImageView removeFromSuperview];
        [self.checkBoxImageView release];
        self.checkBoxImageView = nil;
    }
    
    if (self.calendarNameLabel != nil)
    {
        [self.calendarNameLabel removeFromSuperview];
        [self.calendarNameLabel release];
        self.calendarNameLabel = nil;
    }
    
    
    if (self.sourceNameLabel != nil)
    {
        [self.sourceNameLabel removeFromSuperview];
        [self.sourceNameLabel release];
        self.sourceNameLabel = nil;
    }
    
    
    if (self.cogImageView != nil)
    {
        [self.cogImageView removeFromSuperview];
        [self.cogImageView release];
        self.cogImageView = nil;
    }
    
    
    
    if (self.addBackgroundView == nil)
    {
        self.addBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.addBackgroundView.backgroundColor = [UIColor blackColor];
        self.addBackgroundView.alpha = .25;
        [self addSubview:self.addBackgroundView];
    }
    
    if (self.addCalendarLabel == nil)
    {
        self.addCalendarLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, self.frame.size.width, self.frame.size.height)];
        self.addCalendarLabel.backgroundColor = [UIColor clearColor];
        self.addCalendarLabel.textColor = [UIColor whiteColor];
        self.addCalendarLabel.textAlignment = NSTextAlignmentLeft;
        self.addCalendarLabel.text = @"+ Add Calendar";
        [self addSubview:self.addCalendarLabel];
    }
    
}

-(void)cogButtonHit
{
    
}
-(void)checkButtonHit
{
    NSLog(@"checkButtonHit: %@", self.referenceCalendar);
    
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY]];
    BOOL val = [[dict objectForKey:self.referenceCalendar.calendarIdentifier] boolValue];
    val = !val;
    
    [dict setObject:[NSNumber numberWithBool:val] forKey:self.referenceCalendar.calendarIdentifier];
    [[GroupDiskManager sharedManager] saveDataToDiskWithObject:dict withKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY];
    
    [self setCheckBoxImageViewState];
    
    
//    [[DailyViewController sharedDailyViewController] refreshAllDailyViews];

}


-(void)setCheckBoxImageViewState
{
    NSDictionary *dict = [[GroupDiskManager sharedManager] loadDataFromDiskWithKey:STORED_CALENDARS_SHOWING_DICTIONARY_KEY];
    if ([[dict objectForKey:self.referenceCalendar.calendarIdentifier] boolValue])
        self.checkBoxImageView.image =  [UIImage imageNamed:@"radio-on.png"];
    else
        self.checkBoxImageView.image = [UIImage imageNamed:@"radio-off.png"];
}



@end
