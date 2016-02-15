//
//  CenterSidebarView.h
//  Calendar
//
//  Created by Josh Klobe on 2/9/16.
//
//

#import <UIKit/UIKit.h>

@interface SidebarView : UIView <UIScrollViewDelegate>


@property (nonatomic, retain) NSMutableDictionary *referencePointContainerDictionary;

-(void)dailyScrollViewDidScrollWithOffset:(float)theOffset;
-(void)updateWeatherData;
@end
