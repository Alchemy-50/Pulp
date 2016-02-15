//
//  RadialEventDateController.m
//  Calendar
//
//  Created by Josh Klobe on 6/24/13.
//
//

#import "RadialEventDateController.h"
#import "TimeView.h"
#import "AddEditEventViewController.h"

@interface RadialEventDateController ()

@end

@implementation RadialEventDateController


@synthesize outerRadialContainerView;
@synthesize innerRadialContainerView;
@synthesize amPmLabel;
@synthesize theDate;
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)doLoadViews
{
    self.view.backgroundColor = [UIColor colorWithRed:56.0f/255.0f green:56.0f/255.0f blue:56.0f/255.0f alpha:1];
    
    
    UIColor *outerFillColor = [UIColor colorWithRed:51.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1];
    UIColor *innerFillColor = [UIColor colorWithRed:58.0f/255.0f green:58.0f/255.0f blue:58.0f/255.0f alpha:1];
    
    float spacingFactor = .14;
    
    float diameter = 200;
    
    self.outerRadialContainerView = [[RadialContainerView alloc] initWithFrame:CGRectMake(self.view.frame.size.width / 2  - diameter / 2, self.view.frame.size.height / 2 - diameter / 2, diameter, diameter) withSpacingFactor:spacingFactor withRingFillColor:outerFillColor];
    self.outerRadialContainerView.timeType = CONTAINER_VIEW_TIME_TYPE_HOURS;
    self.outerRadialContainerView.backgroundColor = [UIColor clearColor];
    self.outerRadialContainerView.delegate = self;
    [self.view addSubview:self.outerRadialContainerView];    
    [self.outerRadialContainerView loadWithLabelsArray:[NSArray arrayWithObjects:@"12", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", nil]];
  
    
    self.innerRadialContainerView = [[RadialContainerView alloc] initWithFrame:CGRectMake(self.outerRadialContainerView.frame.origin.x + (self.outerRadialContainerView.frame.size.width * spacingFactor), self.outerRadialContainerView.frame.origin.y + (self.outerRadialContainerView.frame.size.height * spacingFactor), self.outerRadialContainerView.frame.size.width - (2 * self.outerRadialContainerView.frame.size.width * spacingFactor), self.outerRadialContainerView.frame.size.height - (2 * self.outerRadialContainerView.frame.size.height * spacingFactor)) withSpacingFactor:spacingFactor *2 withRingFillColor:innerFillColor];
    self.innerRadialContainerView.timeType = CONTAINER_VIEW_TIME_TYPE_MINUTES;
    self.innerRadialContainerView.backgroundColor = [UIColor clearColor];
    self.innerRadialContainerView.delegate = self;
    [self.view addSubview:self.innerRadialContainerView];
    [self.innerRadialContainerView loadWithLabelsArray:[NSArray arrayWithObjects:@"30", @"45", @"00", @"15", nil]];
    
    
    spacingFactor = spacingFactor * 2;
    CircleView *amPmRadial = [[CircleView alloc] initWithFrame:CGRectMake(self.innerRadialContainerView.frame.origin.x + (self.innerRadialContainerView.frame.size.width * spacingFactor), self.innerRadialContainerView.frame.origin.y + (self.innerRadialContainerView.frame.size.height * spacingFactor), self.innerRadialContainerView.frame.size.width - (2 * self.innerRadialContainerView.frame.size.width * spacingFactor), self.innerRadialContainerView.frame.size.height - (2 * self.innerRadialContainerView.frame.size.height * spacingFactor))];
    amPmRadial.backgroundColor = [UIColor clearColor];
    amPmRadial.fillColor = [UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1];
    amPmRadial.strokeColor = [UIColor colorWithRed:85.0f/255.0f green:85.0f/255.0f blue:85.0f/255.0f alpha:1];
    [self.view addSubview:amPmRadial];

    self.amPmLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, amPmRadial.frame.size.height / 2 - 9, amPmRadial.frame.size.width, 18)];
    self.amPmLabel.backgroundColor = [UIColor clearColor];
    self.amPmLabel.textColor = [UIColor colorWithRed:255.0f/255.0f green:187.0f/255.0f blue:0 alpha:1];
    self.amPmLabel.textAlignment = NSTextAlignmentCenter;
    self.amPmLabel.font = [UIFont systemFontOfSize:18];
    [amPmRadial addSubview:self.amPmLabel];
    
    UIButton *amPmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    amPmButton.frame = CGRectMake(amPmRadial.frame.size.width * .25, amPmRadial.frame.size.height * .25, amPmRadial.frame.size.width * .5, amPmRadial.frame.size.height * .55);
    [amPmButton addTarget:self action:@selector(amPmButtonHit) forControlEvents:UIControlEventTouchUpInside];
    amPmButton.backgroundColor = [UIColor clearColor];
    [amPmRadial addSubview:amPmButton];
                                                                   
             
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    okButton.backgroundColor = [UIColor clearColor];
    okButton.frame = CGRectMake(self.view.frame.size.width / 2 - 30, self.outerRadialContainerView.frame.origin.y + self.outerRadialContainerView.frame.size.height + 10, 60, 50);
    [okButton setImage:[UIImage imageNamed:@"radialokbutton.png"] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okButtonHit) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void) setDialsWithDate:(NSDate *)referenceDate
{
    self.theDate = referenceDate;
    
    unsigned hourAndMinuteFlags = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents* travelDateTimeComponents = [calendar components:hourAndMinuteFlags fromDate:theDate];
    NSString* hours = [NSString stringWithFormat:@"%02li", (long)[travelDateTimeComponents hour]];
    NSString* minutes = [NSString stringWithFormat:@"%02li", (long)[travelDateTimeComponents minute]];
    
    NSLog(@"setDialsWithDate, self.theDate: %@", self.theDate);
    NSLog(@"Calendar: %@",calendar);
    NSLog(@"Travel Components: %@",travelDateTimeComponents);
    NSLog(@"Hours: %@",hours);
    NSLog(@"Minutes: %@",minutes);

    if ([hours intValue] >= 12)
        self.amPmLabel.text= @"PM";
    else
        self.amPmLabel.text = @"AM";
    
    if ([hours intValue] > 12)
        hours = [NSString stringWithFormat:@"%02li", (long)[travelDateTimeComponents hour] - 12];
    [self.outerRadialContainerView setTimeCircleWithString:hours];
    [self.innerRadialContainerView setTimeCircleWithString:minutes];
    
    
}

- (void) hourDidChangeWithString:(NSString *)theString
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: self.theDate];
    [components setHour: [theString integerValue]];
    self.theDate = [gregorian dateFromComponents: components];
    [self.delegate updateDateWithDateController:self];
}

- (void) minuteDidChangeWithString:(NSString *)theString
{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components: NSUIntegerMax fromDate: self.theDate];
    [components setMinute:[theString integerValue]];
    self.theDate = [gregorian dateFromComponents: components];
    
    [self.delegate updateDateWithDateController:self];
}
          
          
          

-(void)amPmButtonHit
{
    NSLog(@"amPmButtonHit");
    unsigned hourAndMinuteFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [calendar setTimeZone:[NSTimeZone localTimeZone]];
    NSDateComponents* travelDateTimeComponents = [calendar components:hourAndMinuteFlags fromDate:self.theDate];
    NSString* hours = [NSString stringWithFormat:@"%02li", (long)[travelDateTimeComponents hour]];
    
    if ([hours intValue] >= 12)
        [travelDateTimeComponents setHour:[hours intValue] - 12];
    else
        [travelDateTimeComponents setHour:[hours intValue] + 12];
    
    [self setDialsWithDate:[calendar dateFromComponents:travelDateTimeComponents]];
    [self.delegate updateDateWithDateController:self];

}
- (void) okButtonHit
{
    NSLog(@"okButtonHit");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
