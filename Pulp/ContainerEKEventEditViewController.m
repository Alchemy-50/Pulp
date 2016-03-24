//
//  ContainerEKEventEditViewController.m
//  Pulp
//
//  Created by Josh Klobe on 2/22/16.
//  Copyright © 2016 Josh Klobe. All rights reserved.
//

#import "ContainerEKEventEditViewController.h"
#import "MainViewController.h"
#import <objc/runtime.h>
#import "TestIntercepter.h"


@interface ContainerEKEventEditViewController ()
@property (nonatomic, retain) NSMutableArray *tableViewsArray;
@property (nonatomic, retain) id<UITextViewDelegate> expectedTextViewDelegate;
@end

@implementation ContainerEKEventEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}




- (void)presentViewController:(UIViewController *)viewControllerToPresent animated: (BOOL)flag completion:(void (^ __nullable)(void))completion NS_AVAILABLE_IOS(5_0);
{
    NSLog(@"completion: %@", completion);
    
    //    [super presentViewController:viewControllerToPresent animated:YES completion:completion];
    
    
    NSLog(@"viewControllerToPresent: %@", viewControllerToPresent);
    [self printSubviews:viewControllerToPresent.view];
    
    
    NSLog(@" ");
    NSLog(@" ");
    NSLog(@" ");
    //    EKEventAttendeesEditViewController *vc;
    
    
    if ([viewControllerToPresent isKindOfClass:[UINavigationController class]])
    {
        UINavigationController *navController = (UINavigationController *)viewControllerToPresent;
        for (int i = 0; i < [navController.viewControllers count]; i++)
        {
            UIViewController *subViewController = [navController.viewControllers objectAtIndex:i];
            [subViewController performSelectorOnMainThread:@selector(setEditDelegate:) withObject:self waitUntilDone:YES];
            
            /*
             if ([subViewController isKindOfClass:[EKEventAttendeesEditViewController class]])
             {
             
             }
             */
            
            NSLog(@"subViewController[%d]: %@", i, subViewController);
            [self printSubviews:subViewController.view];
            [subViewController.view removeFromSuperview];
            NSLog(@" ");
            NSLog(@" ");
            NSLog(@" ");
        }
        
    }
    
    
    
    [super presentViewController:viewControllerToPresent animated:flag completion:nil];
    
    return;
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
    NSLog(@"theView: %@", theView);
    NSLog(@" ");
    
    for (int i = 0; i < [[theView subviews] count]; i++)
    {
        UIView *subview = [[theView subviews] objectAtIndex:i];
        
        if ([subview isKindOfClass:[UITableView class]])
        {
            UITableView *theTableView = (UITableView *)subview;
            NSLog(@"theTableView.datasource: %@", theTableView.dataSource);
            NSLog(@"theTableView.delegate: %@", theTableView.delegate);
        }
        //            [self.tableViewsArray addObject:subview];
        
        if ([subview isKindOfClass:[UITextView class]])
        {
            /*
            NSLog(@"------");
            NSLog(@"subview is a text view");
            NSLog(@"the text view: %@", subview);
            
            
            [self dumpInfoWithObject:subview];
            [self printObjectProperties:subview];
            NSLog(@"----");
            [self dumpInfoWithObject:((UITextView *)subview).delegate];
            [self printObjectProperties:((UITextView *)subview).delegate];
            */
            
            
            
//            self.expectedTextViewDelegate = ((UITextView *)subview).delegate;
//            ((UITextView *)subview).delegate = self;
            
            /*
            id textViewDelegate = ((UITextView *)subview).delegate;
            [self printObjectProperties:textViewDelegate];
            [self dumpInfoWithObject:textViewDelegate];
            
            id subDelegate = ((UITextView *)textViewDelegate).delegate;
            [self printObjectProperties:subDelegate];
            [self dumpInfoWithObject:subDelegate];
            */
        }
        
        if ([subview.subviews count] > 0)
            [self printSubviews:subview];
        
        
        
    }
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
//    [self.expectedTextViewDelegate performSelectorOnMainThread:@selector(textViewShoul) withObject:<#(nullable id)#> waitUntilDone:<#(BOOL)#>
    [self.expectedTextViewDelegate textViewShouldBeginEditing:textView];
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.expectedTextViewDelegate textViewShouldEndEditing:textView];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.expectedTextViewDelegate textViewDidBeginEditing:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.expectedTextViewDelegate textViewDidEndEditing:textView];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.expectedTextViewDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.expectedTextViewDelegate textViewDidChange:textView];
}


- (void)textViewDidChangeSelection:(UITextView *)textView
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    [self.expectedTextViewDelegate textViewDidChangeSelection:textView];
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0)
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0)
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}




-(void)printObjectProperties:(id)obj
{
    NSLog(@"printObjectProperties: %@", obj);
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([obj class], &outCount);
    for(i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithCString:propName
                                                        encoding:[NSString defaultCStringEncoding]];
            NSString *propertyType = [NSString stringWithCString:propType
                                                        encoding:[NSString defaultCStringEncoding]];
            
            NSLog(@"propertyName: %@", propertyName);
            NSLog(@"propertyType: %@", propertyType);
            NSLog(@" ");
            NSLog(@" ");
            NSLog(@" ");
            
        }
    }
    
    
}

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T') {
            if (strlen(attribute) <= 4) {
                break;
            }
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "@";
}


-(BOOL)editItemViewControllerCommit:(id)arg1
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
}

-(void)editItemViewControllerWantsKeyboardPinned:(BOOL)arg1
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}


-(void)editItemViewController:(id)arg1 didCompleteWithAction:(int)arg2
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

-(BOOL)editItemViewControllerShouldShowDetachAlert
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
    return YES;
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
    
    NSString *sClass = NSStringFromClass(class_getSuperclass([attendee class]));
    NSLog(@"sClass: %@", sClass);
    
    
    
    
    [self dumpInfoWithObject:attendee];
    NSLog(@"attendee1: %@", attendee);
    
    [attendee setValue:theFirstName forKey:@"firstName"];
    NSLog(@"attendee2: %@", attendee);
    [attendee setValue:theLastName forKey:@"lastName"];
    NSLog(@"attendee3: %@", attendee);
    [attendee setValue:emailAddress forKey:@"emailAddress"];
    NSLog(@"attendee3: %@", attendee);
    [attendees addObject:attendee];
    
    /*
     
     Class className = NSClassFromString(@"EKAttendee");
     id attendee = [className new];
     
     [attendee setValue:theIdentifier forKey:@"UUID"];
     [attendee setValue:name forKey:@"name"];
     [attendee setValue:emailAddress forKey:@"email"];
     [attendee setValue:[NSNumber numberWithInteger:EKParticipantStatusPending] forKey:@"status"];
     [attendee setValue:[NSNumber numberWithInteger:EKParticipantRoleOptional] forKey:@"role"];
     [attendee setValue:[NSNumber numberWithInteger:EKParticipantTypePerson] forKey:@"type"];
     
     NSLog(@"attendee!: %@", attendee);
     */
    
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



-(void)dumpInfoWithObject:(id)obj
{
    NSLog(@"dumpInfoWithObject: %@", obj);
    
    Class clazz = [obj class];
    u_int count;
    
    Ivar* ivars = class_copyIvarList(clazz, &count);
    NSMutableArray* ivarArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* ivarName = ivar_getName(ivars[i]);
        [ivarArray addObject:[NSString  stringWithCString:ivarName encoding:NSUTF8StringEncoding]];
    }
    free(ivars);
    
    objc_property_t* properties = class_copyPropertyList(clazz, &count);
    NSMutableArray* propertyArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        const char* propertyName = property_getName(properties[i]);
        [propertyArray addObject:[NSString  stringWithCString:propertyName encoding:NSUTF8StringEncoding]];
    }
    free(properties);
    
    Method* methods = class_copyMethodList(clazz, &count);
    NSMutableArray* methodArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i < count ; i++)
    {
        SEL selector = method_getName(methods[i]);
        const char* methodName = sel_getName(selector);
        [methodArray addObject:[NSString  stringWithCString:methodName encoding:NSUTF8StringEncoding]];
    }
    free(methods);
    
    NSDictionary* classDump = [NSDictionary dictionaryWithObjectsAndKeys:
                               ivarArray, @"ivars",
                               propertyArray, @"properties",
                               methodArray, @"methods",
                               nil];
    
    NSLog(@"%@", classDump);
}



@end
