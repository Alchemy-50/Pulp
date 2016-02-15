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
#import <MapKit/MapKit.h>
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
@synthesize theMapView;
@synthesize dateFormatter;
@synthesize referenceCalendar;


static float topInset = 13;
static float mapHeight = 80;

+(CGRect)getEventTitleLabelRect
{
    return CGRectMake(75.200005, topInset, 175.8, 17);
}

+(UIFont *)getEventTitleLabelFont
{
    return [UIFont fontWithName:@"Lato-Bold" size:16];
}

+(CGRect)getEventLocationLabelRect
{
    return CGRectMake(85.4, 46.5, 180.8, 12);
}

+(UIFont *)getEventLocationLabelFont
{
    return [UIFont fontWithName:@"Lato-Regular" size:11];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


-(CGRect)getDailyIconViewFrame
{
    float iconWidth = 15;
    return CGRectMake(self.eventTitleLabel.frame.origin.x - (self.startTimeLabel.frame.origin.x + self.startTimeLabel.frame.size.width) + iconWidth / 2 +12, self.eventTitleLabel.frame.origin.y + 3, iconWidth, iconWidth);
}


- (void) loadViews
{
    
    self.autoresizesSubviews = NO;
    if (self.startTimeLabel == nil)
    {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width - self.insetValue, self.frame.size.height);
        
        float stripeYInset = self.frame.size.height * .125;
        
        self.stripeView = [[UIView alloc] initWithFrame:CGRectMake(2, stripeYInset, 2.2, self.frame.size.height - 2 * stripeYInset)];
        self.stripeView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.stripeView];
        
        
        self.startTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(6, topInset, self.frame.size.width * .12, 20)];
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
        
        
        self.eventTitleLabel = [[UILabel alloc] initWithFrame:[DailyTableViewCell getEventTitleLabelRect]];
        self.eventTitleLabel.numberOfLines = 0;
        self.eventTitleLabel.backgroundColor = [UIColor clearColor];
        self.eventTitleLabel.textColor = self.startTimeLabel.textColor;
        self.eventTitleLabel.font = [DailyTableViewCell getEventTitleLabelFont];
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
        
        
        
        self.weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.eventTitleLabel.frame.origin.x + self.eventTitleLabel.frame.size.width, self.eventTitleLabel.frame.origin.y, 25, self.eventTitleLabel.frame.size.height)];
        self.weatherLabel.backgroundColor = [UIColor clearColor];
        self.weatherLabel.textColor = self.startTimeLabel.textColor;
        self.weatherLabel.font = [UIFont fontWithName:@"Lato-Regular" size:10];
        self.weatherLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:self.weatherLabel];
        
        
        
        self.locationLabel = [[UILabel alloc] initWithFrame:[DailyTableViewCell getEventLocationLabelRect]];
        self.locationLabel.numberOfLines = 0;
        self.locationLabel.backgroundColor = [UIColor clearColor];
        self.locationLabel.textColor = [UIColor colorWithRed:durationBaseColor/255.0f green:durationBaseColor/255.0f blue:durationBaseColor/255.0f alpha:1];
        self.locationLabel.font =  [DailyTableViewCell getEventLocationLabelFont];
        self.locationLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:self.locationLabel];
        
        
        float dividerColor = 240.0f;
        self.dividerView = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        self.dividerView.backgroundColor = [UIColor colorWithRed:dividerColor/255.0f green:dividerColor/255.0f blue:dividerColor/255.0f alpha:1];
        [self addSubview:self.dividerView];
        
        
        self.dateFormatter = [[NSDateFormatter alloc] init];
        
        self.referenceCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        
        
    }
}

-(void)tapGestureRecognizerFired
{
    NSLog(@"tapGestureRecognizerFired");
    
    [self.parentView mapTappedWithMapView:self.theMapView withEvent:self.referenceEvent];
}
-(void)touchAndHoldRecognizerFired
{
    NSString *charactersToEscape = @"!*'();:@&=+$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *encodedString = [self.locationLabel.text stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    NSString *urlString = [NSString stringWithFormat:@"%@/?q=%@", @"http://maps.apple.com", encodedString];
    
    [[AppDelegate sharedDelegate] launchExternalURLString:urlString];
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

-(void)loadWithEvent:(EKEvent *)theEvent
{
    //    ALog(@"indexPath: %d", self.theIndexPath.row);
    [self loadViews];
//    self.dailyIconView.frame = [self getDailyIconViewFrame];
    
    self.referenceEvent = theEvent;
    
    
    self.startTimeLabel.text = @"";
    self.amPMLabel.text = @"";
    self.durationLabel.text = @"";
    self.eventTitleLabel.text = @"";
    self.locationLabel.text = @"";
    
    
    if (theEvent.allDay)
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
    

    self.stripeView.backgroundColor = [UIColor colorWithCGColor:theEvent.calendar.CGColor];
    
    if (theEvent.allDay)
        self.dividerView.alpha = 0;
    
    
    self.eventTitleLabel.text = theEvent.title;
    self.locationLabel.text = theEvent.location;
    
    
    //    NSLog(@"THEEVENT.LOCATION: %@", theEvent.location);
    if ([theEvent.location length] > 0)
    {
        NSDictionary *dict = [[MapAPIHandler getSharedMapAPIHandler] getLocationDictionaryWithEvent:self.referenceEvent];
        //        NSLog(@"dict!!: %@", dict);
        if (dict == nil)
            [MapAPIHandler getLocationForMapWithEvent:self.referenceEvent withReferenceCell:self];
        else if ([[dict allKeys] count] > 0)
            [self loadMapData];
    }
    
    
    if (theEvent.allDay)
    {
        self.allDayLabel.alpha = 1;
        self.allDayLabel.text = theEvent.title;
        
        self.stripeView.alpha = 0;
        self.allDayBackgroundView.backgroundColor = [UIColor colorWithCGColor:theEvent.calendar.CGColor];
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
            self.startTimeLabel.text = [self.dateFormatter stringFromDate:theEvent.startDate];
            
            self.amPMLabel.alpha = 0;
            
            
            NSCalendar *calendar = [[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] autorelease];
            NSDateComponents *components = [calendar components:NSUIntegerMax fromDate:theEvent.startDate toDate:theEvent.endDate options:0];
            
            [self.dateFormatter setDateFormat:@"HH:mm"];
            
            if ([components day] > 0)
            {
                NSDateComponents *nowComponents = [calendar components:NSUIntegerMax fromDate:self.parentView.dailyViewDate toDate:theEvent.endDate options:0];
                if ([nowComponents day] > 0)
                    [self.dateFormatter setDateFormat:@"HH:mm EEE"];
                
            }
            
            self.durationLabel.text = [self.dateFormatter stringFromDate:theEvent.endDate];
            
        }
        else
        {
            [self.dateFormatter setDateFormat:@"h:mm"];
            self.startTimeLabel.text = [self.dateFormatter stringFromDate:theEvent.startDate];
            
            self.amPMLabel.alpha = 1;
            [self.dateFormatter setDateFormat:@"a"];
            self.amPMLabel.text = [self.dateFormatter stringFromDate:theEvent.startDate];
            
            
            
            NSDateComponents *components = [self.referenceCalendar components:NSUIntegerMax fromDate:theEvent.startDate toDate:theEvent.endDate options:0];
            
            [self.dateFormatter setDateFormat:@"h:mm a"];
            
            if ([components day] > 0)
            {
                NSDateComponents *nowComponents = [self.referenceCalendar components:NSUIntegerMax fromDate:self.parentView.dailyViewDate toDate:theEvent.endDate options:0];
                if ([nowComponents day] > 0)
                    [self.dateFormatter setDateFormat:@"h:mm a EEE"];
                
            }
            
            self.durationLabel.text = [self.dateFormatter stringFromDate:theEvent.endDate];
            
        }
    }
}


-(void) setFieldsWithEvent:(EKEvent *)theEvent
{
    //    ALog(@"indexPath: %d", self.theIndexPath.row);
    
    if (!CGRectEqualToRect(self.eventTitleLabel.frame, [DailyTableViewCell getEventTitleLabelRect]))
        self.eventTitleLabel.frame = [DailyTableViewCell getEventTitleLabelRect];
    
    CGRect titleRect = CGRectMake(0, 0, 0, 0);
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
        titleRect = [theEvent.title boundingRectWithSize:CGSizeMake(self.eventTitleLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[self.eventTitleLabel font]}  context:nil];
    else
    {
        CGSize constraint = CGSizeMake(self.eventTitleLabel.frame.size.width, 1000);
        
        CGRect theRect = [self.eventTitleLabel.text boundingRectWithSize:constraint
                                                                 options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin
                                                              attributes:@{NSFontAttributeName:self.eventTitleLabel.font}
                                                                 context:nil];
        
        CGSize titleSize = theRect.size;
        titleRect = CGRectMake(0, 0, titleSize.width, titleSize.height);
    }
    
    if (titleRect.size.height > self.eventTitleLabel.frame.size.height)
    {
        self.eventTitleLabel.frame = CGRectMake(self.eventTitleLabel.frame.origin.x, self.eventTitleLabel.frame.origin.y, self.eventTitleLabel.frame.size.width, titleRect.size.height);
        self.locationLabel.frame = CGRectMake(self.locationLabel.frame.origin.x, self.eventTitleLabel.frame.origin.y + self.eventTitleLabel.frame.size.height, self.locationLabel.frame.size.width, self.locationLabel.frame.size.height);
    }
    
    CGRect locationRect = CGRectMake(0, 0, 0, 0);
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
        locationRect = [theEvent.location boundingRectWithSize:CGSizeMake(self.locationLabel.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[self.locationLabel font]}  context:nil];
    else
    {
        CGSize constraint = CGSizeMake(self.locationLabel.frame.size.width, 1000);
        
        CGRect theRect = [self.locationLabel.text boundingRectWithSize:constraint
                                                               options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin
                                                            attributes:@{NSFontAttributeName:self.locationLabel.font}
                                                               context:nil];
        
        
        CGSize locationSize = theRect.size;
        locationRect = CGRectMake(0, 0, locationSize.width, locationSize.height);
    }
    
    
    if (locationRect.size.height > self.locationLabel.frame.size.height)
        self.locationLabel.frame = CGRectMake(self.locationLabel.frame.origin.x, self.locationLabel.frame.origin.y, self.locationLabel.frame.size.width, locationRect.size.height);
    
    
    float maxHeight = 0;
    maxHeight = self.locationLabel.frame.origin.y + self.locationLabel.frame.size.height + 10;
    
    if (self.theMapView != nil)
        maxHeight = self.theMapView.frame.origin.y + self.theMapView.frame.size.height;
    
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

+ (float) getDesiredCellHeightWithEvent:(EKEvent *)theEvent withIndexPath:(NSIndexPath *)indexPath
{
    //    ALog(@"indexPath: %d", indexPath.row);
    CGRect titleRect = CGRectMake(0, 0, 0, 0);
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
        titleRect = [theEvent.title boundingRectWithSize:CGSizeMake([DailyTableViewCell getEventTitleLabelRect].size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[DailyTableViewCell getEventTitleLabelFont]}  context:nil];
    else
    {
        
        
        CGSize constraint = CGSizeMake([DailyTableViewCell getEventTitleLabelRect].size.width, 1000);
        
        CGRect theRect = [theEvent.title boundingRectWithSize:constraint
                                                      options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[DailyTableViewCell getEventTitleLabelFont]}
                                                      context:nil];
        
        
        
        titleRect = CGRectMake(0, 0, theRect.size.width, theRect.size.height);
    }
    titleRect.origin = [DailyTableViewCell getEventTitleLabelRect].origin;
    
    
    CGRect locationRect = CGRectMake(0, 0, 0, 0);
    
    if (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)
        locationRect = [theEvent.location boundingRectWithSize:CGSizeMake([DailyTableViewCell getEventLocationLabelRect].size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[DailyTableViewCell getEventLocationLabelFont]}  context:nil];
    else
    {
        CGSize constraint = CGSizeMake([DailyTableViewCell getEventLocationLabelRect].size.width, 1000);
        
        
        CGRect theRect = [theEvent.location boundingRectWithSize:constraint
                                                      options:NSLineBreakByWordWrapping | NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[DailyTableViewCell getEventLocationLabelFont]}
                                                      context:nil];

        
        locationRect = CGRectMake(0, 0, theRect.size.width, theRect.size.height);
    }
    
    
    locationRect.origin = CGPointMake(locationRect.origin.x, titleRect.origin.y + titleRect.size.height);
    if (locationRect.size.height == 0)
        locationRect.size = CGSizeMake(0, [DailyTableViewCell getEventLocationLabelRect].size.height);
    
    
    float returnHeight = locationRect.origin.y + locationRect.size.height + 10;
    
    
    if (theEvent.allDay)
        return 30;
    else
    {
        NSDictionary *locationDictionary = [NSDictionary dictionaryWithDictionary:[[MapAPIHandler getSharedMapAPIHandler] getLocationDictionaryWithEvent:theEvent]];
        if (locationDictionary != nil)
            if ([[locationDictionary allKeys] count] > 0)
                returnHeight += mapHeight;
        
        return returnHeight;
    }
    
    
}


- (void) eventLocationDataReturned
{
    [self.parentView cellDidReturnWithLocation];
}




-(void)loadWeatherData
{
    NSString *degrees = [[WeatherDataManager getSharedWeatherDataManager] getHourlyDegreesWithDate:self.referenceEvent.startDate];
    if (degrees == nil)
        self.weatherLabel.text = @"";
    else
        self.weatherLabel.text = [NSString stringWithFormat:@"%@°", degrees];
}




-(void)loadMapData
{
    NSDictionary *locationDictionary = [NSDictionary dictionaryWithDictionary:[[MapAPIHandler getSharedMapAPIHandler] getLocationDictionaryWithEvent:self.referenceEvent]];
    
    if (self.theMapView == nil)
    {
        self.theMapView = [[MKMapView alloc]  initWithFrame:CGRectMake(self.theMapView.frame.origin.x, self.locationLabel.frame.origin.y + self.locationLabel.frame.size.height + 10, self.frame.size.width, mapHeight)];
        self.theMapView.scrollEnabled = NO;
        self.theMapView.userInteractionEnabled = NO;
        [self addSubview:self.theMapView];
        
        UIButton *mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        mapButton.frame = self.theMapView.frame;
        mapButton.backgroundColor = [UIColor clearColor];
        [mapButton addTarget:self action:@selector(tapGestureRecognizerFired) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mapButton];
        
        /*
         UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerFired)];
         tapGestureRecognizer.numberOfTapsRequired = 1;
         [self.theMapView addGestureRecognizer:tapGestureRecognizer];
         
         UILongPressGestureRecognizer *touchAndHoldRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touchAndHoldRecognizerFired)];
         touchAndHoldRecognizer.minimumPressDuration = 0.45;
         [self.theMapView addGestureRecognizer:touchAndHoldRecognizer];
         */
        
        CLLocationCoordinate2D center;
        
        NSDictionary *metadataDictionary = [locationDictionary objectForKey:@"metadata"];
        center.latitude = [[metadataDictionary objectForKey:@"latitude"] doubleValue];
        center.longitude = [[metadataDictionary objectForKey:@"longitude"] doubleValue];
        
        MKPointAnnotation *myAnnotation = [[MKPointAnnotation alloc]init];
        myAnnotation.coordinate = center;
        
        [self.theMapView addAnnotation:myAnnotation];
        [self.theMapView setCenterCoordinate:center];
        
        MKCoordinateRegion adjustedRegion = [self.theMapView regionThatFits:MKCoordinateRegionMakeWithDistance(center, 800, 800)];
        adjustedRegion.span.longitudeDelta  = 0.0105;
        adjustedRegion.span.latitudeDelta  = 0.0105;
        [self.theMapView setRegion:adjustedRegion animated:NO];
        
        
        
    }
}


@end
