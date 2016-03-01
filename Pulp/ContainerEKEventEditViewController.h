//
//  ContainerEKEventEditViewController.h
//  Pulp
//
//  Created by Josh Klobe on 2/22/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "Defs.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import "CalendarEvent.h"
#import <EventKitUI/EventKitUI.h>

@interface ContainerEKEventEditViewController : EKEventEditViewController <CNContactViewControllerDelegate, EKEventEditViewDelegate, CNContactPickerDelegate>

-(void)loadForNewEventWithStartDate:(NSDate *)startDate;
-(void)loadWithExistingCalendarEvent:(CalendarEvent *)theCalendarEvent;


@property (nonatomic, retain) id containerParentController;


@end
