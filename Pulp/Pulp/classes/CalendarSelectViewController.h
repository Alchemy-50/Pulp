//
//  CalendarSelectViewController.h
//  Calendar
//
//  Created by Josh Klobe on 5/15/13.
//
//

#import <UIKit/UIKit.h>

@class DetailsViewController;
@class AddEditEventViewController;

@interface CalendarSelectViewController : UIViewController <UIPickerViewDataSource>
{

}


-(IBAction)cancelButtonHit;
-(IBAction)saveButtonHit;


@property (nonatomic, retain) AddEditEventViewController *delegate;
@property (nonatomic, retain) IBOutlet UIPickerView *thePickerView;
@property (nonatomic, retain) NSMutableArray *contentArray;
@property (nonatomic, assign) NSInteger selectedIndex;
@end
