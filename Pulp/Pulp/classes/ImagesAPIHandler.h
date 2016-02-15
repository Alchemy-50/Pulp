//
//  ImagesAPIHandler.h
//  Calendar
//
//  Created by Josh Klobe on 2/26/14.
//
//
#import <UIKit/UIKit.h>

@interface ImagesAPIHandler : NSObject

+(void)makeImageRequestWithDelegate:(id)theDelegate withURL:(NSString *)imageURLString;

@end
