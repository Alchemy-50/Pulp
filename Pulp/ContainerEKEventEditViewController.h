//
//  ContainerEKEventEditViewController.h
//  Pulp
//
//  Created by Josh Klobe on 2/22/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import <EventKitUI/EventKitUI.h>
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>


@interface ContainerEKEventEditViewController : EKEventEditViewController <CNContactViewControllerDelegate, CNContactPickerDelegate>

@end
