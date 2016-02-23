//
//  ContainerEKEventEditViewController.m
//  Pulp
//
//  Created by Josh Klobe on 2/22/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "ContainerEKEventEditViewController.h"
#import "MainViewController.h"


@interface ContainerEKEventEditViewController ()
@property (nonatomic, retain) NSMutableArray *tableViewsArray;
@end

@implementation ContainerEKEventEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}




- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0);
{
    self.tableViewsArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"!!");
    NSLog(@"viewControllerToPresent!: %@", viewControllerToPresent);
    UINavigationController *navController = (UINavigationController *)viewControllerToPresent;
    if ([navController isKindOfClass:[UINavigationController class]])
    {
        NSLog(@"navController.viewControllers: %@", navController.viewControllers);
        
    }
  
    
    CNContactPickerViewController *vc = [[CNContactPickerViewController alloc] initWithNibName:nil bundle:nil];
    vc.delegate = self;
    [super presentViewController:vc animated:YES completion:nil];
    

//    NSLog(@"self.view: %@", self.view);
    [self printSubviews:self.view];
        
}

-(void)printSubviews:(UIView *)theView
{
    for (int i = 0; i < [[theView subviews] count]; i++)
    {
        UIView *subview = [[theView subviews] objectAtIndex:i];
        
        if ([subview isKindOfClass:[UITableView class]])
            [self.tableViewsArray addObject:subview];
        
        if ([subview.subviews count] > 0)
            [self printSubviews:subview];


        
    }
}


- (void)contactViewController:(CNContactViewController *)viewController didCompleteWithContact:(nullable CNContact *)contact
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}



- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"contact: %@", contact);
    
    NSString *theFirstName = contact.givenName;
    NSString *theLastName = contact.familyName;
    NSString *name = [NSString stringWithFormat:@"%@ %@", theFirstName, theLastName];
    
    NSString *theIdentifier = contact.identifier;
    
    NSString *emailAddress = @"";
    for (int i = 0; i < [contact.emailAddresses count]; i++)
    {
        
        CNLabeledValue *labeledValue = [contact.emailAddresses objectAtIndex:i];
        emailAddress = labeledValue.value;
        
    }
    
    NSLog(@"theFirstName: %@", theFirstName);
    NSLog(@"theLastName: %@", theLastName);
    NSLog(@"emailAddress: %@", emailAddress);
    
    
    
    NSMutableArray *attendees = [NSMutableArray new];
    
    Class className = NSClassFromString(@"EKAttendee");
    id attendee = [className new];
    
    [attendee setValue:theIdentifier forKey:@"UUID"];
    [attendee setValue:name forKey:@"name"];
    [attendee setValue:emailAddress forKey:@"email"];
    [attendee setValue:[NSNumber numberWithInteger:EKParticipantStatusPending] forKey:@"status"];
    [attendee setValue:[NSNumber numberWithInteger:EKParticipantRoleOptional] forKey:@"role"];
    [attendee setValue:[NSNumber numberWithInteger:EKParticipantTypePerson] forKey:@"type"];
    
    NSLog(@"attendee!: %@", attendee);
    [self.event setValue:attendees forKey:@"attendees"];

    
    for (int i = 0; i < [self.tableViewsArray count]; i++)
    {
        UITableView *theTableView = [self.tableViewsArray objectAtIndex:i];
        NSLog(@"THE TABLE VIEW[%d]: %@", i, theTableView);
        [theTableView reloadData];
    }
    
    
}


- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperty:(CNContactProperty *)contactProperty
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"contactProperty: %@", contactProperty);
    
}


/*
 
- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContacts:(NSArray<CNContact*> *)contacts
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContactProperties:(NSArray<CNContactProperty*> *)contactProperties
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

 */



@end
