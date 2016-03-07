//
//  FocusHandlerProtocol.h
//  Pulp_TV
//
//  Created by Josh Klobe on 3/7/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FocusHandlerProtocol <NSObject>

-(void)focusChanged:(BOOL)didFocusTo withReferenceObject:(id)theReferenceObject;
@end
