//
//  EventTaskSelectTableViewCell.h
//  Calendar
//
//  Created by Alchemy50 on 6/6/14.
//
//

#import <UIKit/UIKit.h>
#import "CommonEventContainer.h"

@class EventTaskSelectViewController;

@interface EventTaskSelectTableViewCell : UITableViewCell


-(void) loadAddButtonView;
-(void) loadWithCommonEventContainer:(CommonEventContainer *)theContainer;
-(void)loadEntryView;

@property (nonatomic, retain) EventTaskSelectViewController *parentEventTaskSelectViewController;
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIImageView *typeImageView;
@property (nonatomic, retain) UILabel *taskLabel;
@property (nonatomic, retain) UIView *separatorView;

@property (nonatomic, retain) UIImageView *addImageView;

@property (nonatomic, retain) UITextField *addingEntryField;

@end
