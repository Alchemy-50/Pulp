//
//  WeatherView.m
//  Calendar
//
//  Created by Josh Klobe on 2/26/14.
//
//

#import "WeatherView.h"
#import "ImagesAPIHandler.h"
#import "SettingsManager.h"
@implementation WeatherView

@synthesize iconImageView;
@synthesize weatherLabel;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        float width = self.frame.size.height / 2;
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, self.frame.size.height * .13, width, width)];
        [self addSubview:self.iconImageView];
        
        self.weatherLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconImageView.frame.origin.x - 10, self.iconImageView.frame.origin.y + self.iconImageView.frame.size.height - 3, self.iconImageView.frame.size.width + 20, self.frame.size.height - (self.iconImageView.frame.origin.y + self.iconImageView.frame.size.height - 5))];
        self.weatherLabel.textColor = [UIColor whiteColor];
        self.weatherLabel.font = [UIFont fontWithName:@"Lato-Black" size:9];
        self.weatherLabel.backgroundColor = [UIColor clearColor];
        self.weatherLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.weatherLabel];
        
    }
    return self;
}


-(void)loadWithDictionary:(NSDictionary *)weatherDictionary
{
    if (weatherDictionary != nil)
    {
        
        NSDictionary *highDict = [weatherDictionary objectForKey:@"high"];
        NSDictionary *lowDict = [weatherDictionary objectForKey:@"low"];
        
        if ([[SettingsManager getSharedSettingsManager] tempInCelcius])
            self.weatherLabel.text = [NSString stringWithFormat:@"%@°/%@°", [highDict objectForKey:@"celsius"], [lowDict objectForKey:@"celsius"]];
        else
            self.weatherLabel.text = [NSString stringWithFormat:@"%@°/%@°", [highDict objectForKey:@"fahrenheit"], [lowDict objectForKey:@"fahrenheit"]];
                
        self.iconImageView.image = [self getWeatherImageWithString:[weatherDictionary objectForKey:@"icon"]];
        
        [ImagesAPIHandler makeImageRequestWithDelegate:self withURL:[weatherDictionary objectForKey:@"icon_url"]];
        
        
    }
    else
    {
        self.weatherLabel.text = @"";
        self.iconImageView.image = nil;
    }
}


-(void)imageReturnedWithImage:(UIImage *)theImage
{
    self.iconImageView.image = theImage;
}


-(UIImage *)getWeatherImageWithString:(NSString *)theTypeString
{
    
    
    if ([theTypeString compare:@"chanceflurries"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-lightsnow.png"];
    }
    
    else if ([theTypeString compare:@"chancerain"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-lightrain.png"];
    }
    
    
    else if ([theTypeString compare:@"chancesleet"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-snow.png"];
    }
    
    
    else if ([theTypeString compare:@"chancesnow"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-lightsnow.png"];
    }
    
    
    else if ([theTypeString compare:@"chancetstorms"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-stormy.png"];
    }
    
    
    else if ([theTypeString compare:@"clear"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-sunny.png"];
    }
    
    
    else if ([theTypeString compare:@"cloudy"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-cloudy.png"];
    }
    
    
    else if ([theTypeString compare:@"flurries"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-lightsnow.png"];
    }
    
    
    else if ([theTypeString compare:@"fog"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-cloudy.png"];
    }
    
    
    else if ([theTypeString compare:@"hazy"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-cloudy.png"];
    }
    
    
    else if ([theTypeString compare:@"mostlycloudy"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-partlycloudy.png"];
    }
    
    
    else if ([theTypeString compare:@"mostlysunny"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-sunny.png"];
    }
    
    
    else if ([theTypeString compare:@"partlycloudy"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-partlycloudy.png"];
    }
    
    
    else if ([theTypeString compare:@"partlysunny"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-sunny.png"];
    }
    
    
    else if ([theTypeString compare:@"rain"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-rain.png"];
    }
    
    
    else if ([theTypeString compare:@"sleet"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-stormy.png"];
    }
    
    
    else if ([theTypeString compare:@"snow"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-snow.png"];
    }
    
    
    else if ([theTypeString compare:@"sunny"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-sunny.png"];
    }
    
    
    else if ([theTypeString compare:@"tstorms"] == NSOrderedSame)
    {
        return [UIImage imageNamed:@"icn-stormy.png"];
    }
    else
    {
        NSLog(@"WEATHER TYPE STRING: %@ not found", theTypeString);
        return nil;
    }
    
    /*
     icn-cloudy.png
     icn-lightrain.png
     icn-lightsnow.png
     icn-partlycloudy.png
     icn-rain.png
     icn-snow.png
     icn-stormy.png
     icn-sunny.png
     icn-windy.png
     */
    
    
}

@end
