//
//  DailyTableViewCell.m
//  Calendar
//
//  Created by Josh Klobe on 7/6/13.
//
//

#import "DailyTableViewCell.h"
#import "EventKitManager.h"

#import "TodosViewController.h"
#import "Utils.h"
#import "TodosViewController.h"
#import "ContainerTodosViewController.h"
#import "DailyView.h"
#import "WeatherDataManager.h"
#import "SettingsManager.h"

#import <CoreLocation/CoreLocation.h>
#import "MapAPIHandler.h"
#import "AppDelegate.h"

@implementation DailyTableViewCell

@synthesize startTimeLabel;
@synthesize amPMLabel;
@synthesize durationLabel;
@synthesize eventTitleLabel;
@synthesize locationLabel;
@synthesize theIndexPath;
@synthesize insetValue;
@synthesize weatherLabel;
@synthesize allDayLabel;
@synthesize dividerView;
@synthesize referenceEvent;
@synthesize parentView;
@synthesize allDayBackgroundView;
@synthesize dateFormatter;
@synthesize referenceCalendar;


static float topInset = 13;
static float mapHeight = 80;

static UIFont *theTitleLabelFont;
static UIFont *theLocationLabelFont;

#define MIN_CELL_HEIGHT 68.0f


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        
        
        
    }
    return self;
}

+(void)loadFonts
{
    if (theTitleLabelFont == nil)
        theTitleLabelFont = [UIFont fontWithName:@"Lato-Bold" size:16];
    
    if (theLocationLabelFont == nil)
        theLocationLabelFont = [UIFont fontWithName:@"Lato-Regular" size:11];
}

-(CGRect)getDailyIconViewFrame
{
    float iconWidth = 15;
    return CGRectMake(self.eventTitleLabel.frame.origin.x - (self.startTimeLabel.frame.origin.x + self.startTimeLabel.frame.size.width) + iconWidth / 2 +12, self.eventTitleLabel.frame.origin.y + 3, iconWidth, iconWidth);
}


- (void) loadViews
{
    [DailyTableViewCell loadFonts];
    
    self.autoresizesSubviews = NO;
    if (self.startTimeLabel == nil)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width - self.insetValue, self.frame.size.height);
        
        float stripeYInset = self.frame.size.height * .125;
        
        self.stripeView = [[UIView alloc] initWithFrame:CGRectMake(2, stripeYInset, 2.2, self.frame.size.height - 2 * stripeYInset)];
        self.stripeView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.stripeView];
        
        
        
        
        self.startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake([Utils getXInFramePerspective:6], topInset, self.frame.size.width * .12, 20)];
        self.startTimeLabel.backgroundColor = [UIColor clearColor];
        self.startTimeLabel.textColor = [UIColor blackColor];
        if (self.cellStyleClear)
            self.startTimeLabel.textColor = [UIColor whiteColor];
        self.startTimeLabel.font = [UIFont fontWithName:@"Lato-Regular" size:18 * .75];
        self.startTimeLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.startTimeLabel];
        
        self.amPMLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.startTimeLabel.frame.origin.x + self.startTimeLabel.frame.size.width + 2.7, self.startTimeLabel.frame.origin.y, 25, self.startTimeLabel.frame.size.height)];
        self.amPMLabel.backgroundColor = [UIColor clearColor];
        self.amPMLabel.textAlignment = NSTextAlignmentLeft;
        self.amPMLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
        self.amPMLabel.textColor = self.startTimeLabel.textColor;
        [self addSubview:self.amPMLabel];
        self.amPMLabel.text = @"Mm";
        
        
        float durationBaseColor = 160.0f;
        self.durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.startTimeLabel.frame.origin.x, self.startTimeLabel.frame.origin.y + self.startTimeLabel.frame.size.height -1, self.amPMLabel.frame.origin.x + 8, 14)];
        self.durationLabel.backgroundColor = [UIColor clearColor];
        self.durationLabel.textColor = [UIColor colorWithRed:durationBaseColor/255.0f green:durationBaseColor/255.0f blue:durationBaseColor/255.0f alpha:1];
        self.durationLabel.font = [UIFont fontWithName:@"Lato-Regular" size:9];
        self.durationLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.durationLabel];
        
        
        self.eventTitleLabel = [[UILabel alloc] initWithFrame:[DailyTableViewCell getTitleLabelRectWithEvent:nil]];
        self.eventTitleLabel.numberOfLines = 0;
        self.eventTitleLabel.backgroundColor = [UIColor clearColor];
        self.eventTitleLabel.textColor = self.startTimeLabel.textColor;
        self.eventTitleLabel.font = theTitleLabelFont;
        self.eventTitleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.eventTitleLabel];
        
        
        float dailyIconPositionOffset = [self getDailyIconViewFrame].origin.x + [self getDailyIconViewFrame].size.width + 10.5;
        
        
        
        self.allDayBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.startTimeLabel.frame.size.height * 1.5)];
        self.allDayBackgroundView.backgroundColor = [UIColor colorWithRed:237/255.0f green:238/255.0f blue:234/255.0f alpha:1];
        [self addSubview:self.allDayBackgroundView];
        
        
        self.allDayLabel = [[UILabel alloc] initWithFrame:CGRectMake(dailyIconPositionOffset, 0, self.frame.size.width - dailyIconPositionOffset, self.startTimeLabel.frame.size.height * 1.5)];
        self.allDayLabel.backgroundColor = [UIColor clearColor]; //[UIColor colorWithRed:237/255.0f green:238/255.0f blue:234/255.0f alpha:1];
        self.allDayLabel.textColor = [UIColor colorWithRed:46.0f/255.0f green:175.0f/255 blue:152.0f/255.0f alpha:1];
        self.allDayLabel.font = [UIFont fontWithName:@"Lato-Bold" size:18 * .75];
        self.allDayLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.allDayLabel];
        
        
        
        self.weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.eventTitleLabel.frame.origin.x + self.eventTitleLabel.frame.size.width, self.eventTitleLabel.frame.origin.y, 25, 18)];
        self.weatherLabel.backgroundColor = [UIColor clearColor];
        self.weatherLabel.textColor = self.startTimeLabel.textColor;
        self.weatherLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
        self.weatherLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.weatherLabel];
        
        
        
        self.locationLabel = [[UILabel alloc] initWithFrame:[DailyTableViewCell getLocationLabelRectWithEvent:nil withTitleRect:self.eventTitleLabel.frame]];
        self.locationLabel.numberOfLines = 0;
        self.locationLabel.backgroundColor = [UIColor clearColor];
        self.locationLabel.textColor = [UIColor colorWithRed:durationBaseColor/255.0f green:durationBaseColor/255.0f blue:durationBaseColor/255.0f alpha:1];
        self.locationLabel.font =  theLocationLabelFont;
        self.locationLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.locationLabel];
        
        
        self.dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        if (self.cellStyleClear)
            self.dividerView.backgroundColor = [UIColor colorWithWhite:1 alpha:.1];
        else
            self.dividerView.backgroundColor = [UIColor colorWithWhite:.125 alpha:.125];
        [self addSubview:self.dividerView];
        
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        
        self.referenceCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        
    }
}


-(void)mapTapped
{
}

-(void)touchAndHoldRecognizerFired
{
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedString = [self.locationLabel.text stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    NSString *urlString = [NSString stringWithFormat:@"%@/?q=%@", @"http://maps.apple.com", encodedString];
    
//    [[AppDelegate sharedDelegate] launchExternalURLString:urlString];
}

-(void)setLastRowStyle:(BOOL)isLastRow
{
    if (isLastRow)
    {
        if (self.lastRowView == nil)
        {
            self.lastRowView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 5, self.frame.size.width, 5)];
            self.lastRowView.backgroundColor = [UIColor redColor];
            [self addSubview:self.lastRowView];
        }
    }
    
    
    self.lastRowView.alpha = isLastRow;
}

-(void)loadWithEvent:(CalendarEvent *)theEvent
{
    [self loadViews];
    
    self.referenceEvent = theEvent;
    
    
    self.startTimeLabel.text = @"";
    self.amPMLabel.text = @"";
    self.durationLabel.text = @"";
    self.eventTitleLabel.text = @"";
    self.locationLabel.text = @"";
    
    
    if ([self.referenceEvent isAllDay])
    {
        self.locationLabel.alpha = 0;
        self.dividerView.alpha = 0;
        self.stripeView.alpha = 0;
        self.weatherLabel.alpha = 0;
        self.startTimeLabel.alpha = 0;
        self.eventTitleLabel.alpha = 0;
        self.allDayLabel.alpha = 1;
        self.allDayBackgroundView.alpha = 1;
    }
    else
    {
        self.locationLabel.alpha = 1;
        self.stripeView.alpha = 1;
        self.weatherLabel.alpha = 1;
        //        self.calendarTitleLabel.alpha = 1;
        self.startTimeLabel.alpha = 1;
        self.eventTitleLabel.alpha = 1;
        self.allDayLabel.alpha = 0;
        self.allDayBackgroundView.alpha = 0;
    }
    
    [self loadWeatherData];
    
    self.backgroundColor = [UIColor clearColor];
    self.dividerView.alpha = 1;
    

    self.stripeView.backgroundColor = [[self.referenceEvent getCalendar] getColor];
    
    if ([self.referenceEvent isAllDay])
        self.dividerView.alpha = 0;
    
    
    self.eventTitleLabel.frame = [DailyTableViewCell getTitleLabelRectWithEvent:theEvent];
    self.eventTitleLabel.text = [self.referenceEvent getTheTitle];
    
    self.locationLabel.frame = [DailyTableViewCell getLocationLabelRectWithEvent:theEvent withTitleRect:self.eventTitleLabel.frame];
    self.locationLabel.text = [self.referenceEvent getTheLocation];
    
    
    //    NSLog(@"THEEVENT.LOCATION: %@", theEvent.location);

    if ([[self.referenceEvent getTheLocation] length] > 0 && !self.suppressMaps)
    {
        NSDictionary *dict = [[MapAPIHandler getSharedMapAPIHandler] getLocationDictionaryWithEvent:self.referenceEvent];
        //        NSLog(@"dict!!: %@", dict);
        if (dict == nil)
            [MapAPIHandler getLocationForMapWithEvent:self.referenceEvent withReferenceCell:self];
        else if ([[dict allKeys] count] > 0)
            [self loadMapData];
    }
    
    
    if ([self.referenceEvent isAllDay])
    {
        self.allDayLabel.alpha = 1;
        self.allDayLabel.text = [self.referenceEvent getTheTitle];
        
        self.stripeView.alpha = 0;
        self.allDayBackgroundView.backgroundColor = [[self.referenceEvent getCalendar] getColor];
        self.allDayBackgroundView.alpha = 1;
        
        
        self.allDayLabel.textColor = [UIColor whiteColor];
        self.allDayLabel.backgroundColor = [UIColor clearColor];
        self.allDayLabel.textAlignment = NSTextAlignmentCenter;
        self.allDayLabel.frame = CGRectMake(0, 0, self.allDayBackgroundView.frame.size.width, self.allDayBackgroundView.frame.size.height);
    }
    else
    {
        self.stripeView.alpha = 1;
        self.allDayLabel.text = @"";
        self.allDayLabel.alpha = 0;
        self.allDayBackgroundView.alpha = 0;
        
        
        
        if ([[SettingsManager getSharedSettingsManager] startTimeInTwentyFour])
        {
            [self.dateFormatter setDateFormat:@"HH:mm"];
            self.startTimeLabel.text = [self.dateFormatter stringFromDate:[self.referenceEvent getStartDate]];
            
            self.amPMLabel.alpha = 0;
            
            
            NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:[self.referenceEvent getStartDate] toDate:[self.referenceEvent getEndDate] options:0];
            
            [self.dateFormatter setDateFormat:@"HH:mm"];
            
            if ([components day] > 0)
            {
                NSDateComponents *nowComponents = [calendar components:NSUIntegerMax fromDate:self.parentView.dailyViewDate toDate:[self.referenceEvent getEndDate] options:0];
                if ([nowComponents day] > 0)
                    [self.dateFormatter setDateFormat:@"HH:mm EEE"];
                
            }
            
            self.durationLabel.text = [self.dateFormatter stringFromDate:[self.referenceEvent getEndDate]];
            
        }
        else
        {
            [self.dateFormatter setDateFormat:@"h:mm"];
            self.startTimeLabel.text = [self.dateFormatter stringFromDate:[self.referenceEvent getStartDate]];
            
            self.amPMLabel.alpha = 1;
            [self.dateFormatter setDateFormat:@"a"];
            self.amPMLabel.text = [self.dateFormatter stringFromDate:[self.referenceEvent getStartDate]];
            
            
            
            NSDateComponents *components = [self.referenceCalendar components:NSUIntegerMax fromDate:[self.referenceEvent getStartDate] toDate:[self.referenceEvent getEndDate] options:0];
            
            [self.dateFormatter setDateFormat:@"h:mm a"];
            
            if ([components day] > 0)
            {
                NSDateComponents *nowComponents = [self.referenceCalendar components:NSUIntegerMax fromDate:self.parentView.dailyViewDate toDate:[self.referenceEvent getEndDate] options:0];
                if ([nowComponents day] > 0)
                    [self.dateFormatter setDateFormat:@"h:mm a EEE"];
                
            }
            
            self.durationLabel.text = [self.dateFormatter stringFromDate:[self.referenceEvent getEndDate]];
            
        }
    }
}


-(void) setFieldsWithEvent:(CalendarEvent *)theEvent
{
    
    self.eventTitleLabel.frame = [DailyTableViewCell getTitleLabelRectWithEvent:theEvent];
    self.eventTitleLabel.text = [theEvent getTheTitle];
    
    self.locationLabel.frame = [DailyTableViewCell getLocationLabelRectWithEvent:theEvent withTitleRect:self.eventTitleLabel.frame];
    self.locationLabel.text = [theEvent getTheLocation];
    
    
    
    float maxHeight = 0;
    maxHeight = self.locationLabel.frame.origin.y + self.locationLabel.frame.size.height + 10;
    

    
    self.dividerView.frame  = CGRectMake(self.dividerView.frame.origin.x, maxHeight, self.frame.size.width, self.dividerView.frame.size.height);
    
    
    float yDiff = self.stripeView.frame.origin.y;
    self.stripeView.frame = CGRectMake(self.stripeView.frame.origin.x, self.stripeView.frame.origin.y, self.stripeView.frame.size.width, maxHeight - 2 * yDiff);
    
    
}

-(void)loadCoverButton
{
    UIButton *theButton = [UIButton buttonWithType:UIButtonTypeCustom];
    theButton.backgroundColor = [UIColor clearColor];
    theButton.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    [theButton addTarget:self action:@selector(theButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:theButton];
}

-(void)theButtonHit
{
    [self.parentView cellButtonHitWithIndexPath:self.theIndexPath];
}


- (void) eventLocationDataReturned
{
    [self.parentView cellDidReturnWithLocation];
}



-(void)loadWeatherData
{
    NSString *degrees = [[WeatherDataManager getSharedWeatherDataManager] getHourlyDegreesWithDate:[self.referenceEvent getStartDate]];
    if (degrees == nil)
        self.weatherLabel.text = @"";
    else
        self.weatherLabel.text = [NSString stringWithFormat:@"%@°", degrees];
}




-(void)loadMapData
{
  
}


+(CGRect)getTitleLabelRectWithEvent:(CalendarEvent *)theEvent
{
    NSString *theString = @"";
    if (theEvent != nil)
        theString = [theEvent getTheTitle];


    float maxWidth = [Utils getScreenWidth] * .54;
    
    float height = [theString boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:@{NSFontAttributeName:theTitleLabelFont}
                                                context:nil].size.height;

    if (height < 18)
        height = 18;
    
    height += 2;
    return CGRectMake([Utils getXInFramePerspective:75.0], topInset - 1.5, maxWidth, height);
}


+(CGRect)getLocationLabelRectWithEvent:(CalendarEvent *)theEvent withTitleRect:(CGRect)titleRect
{
    NSString *theString = @"";
    if (theEvent != nil)
        theString = [theEvent getTheLocation];
    
    float height = [theString boundingRectWithSize:CGSizeMake(titleRect.size.width, MAXFLOAT)
                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                attributes:@{NSFontAttributeName:theLocationLabelFont}
                                                   context:nil].size.height;
    
    
    
    height += 3;
    
    return CGRectMake(titleRect.origin.x, titleRect.origin.y + titleRect.size.height + 2, titleRect.size.width, height);
}







+ (float) getDesiredCellHeightWithEvent:(CalendarEvent *)theEvent withIndexPath:(NSIndexPath *)indexPath withSuppressMaps:(BOOL)doSuppressMaps
{
    [DailyTableViewCell loadFonts];
    
    if ([theEvent isAllDay])
        return 30;
    else
    {
        CGRect titleLabelRect = [DailyTableViewCell getTitleLabelRectWithEvent:theEvent];
        CGRect locationLabelRect = [DailyTableViewCell getLocationLabelRectWithEvent:theEvent withTitleRect:titleLabelRect];
        
        float returnHeight = locationLabelRect.origin.y + locationLabelRect.size.height;
        
        if (!doSuppressMaps)
        {
            NSDictionary *locationDictionary = [NSDictionary dictionaryWithDictionary:[[MapAPIHandler getSharedMapAPIHandler] getLocationDictionaryWithEvent:theEvent]];
            if (locationDictionary != nil)
                if ([[locationDictionary allKeys] count] > 0)
                    returnHeight += mapHeight;
        }
        if (returnHeight < MIN_CELL_HEIGHT)
            returnHeight = MIN_CELL_HEIGHT;
        
        returnHeight += 10;
        
//        NSLog(@"getDesiredCellHeightWithEvent[%@]: %f", theEvent.title, returnHeight);
        
        return returnHeight;
    }
    
    
}



@end
