//
//  LocationViewController.h
//  Calendar
//
//  Created by Josh Klobe on 5/14/13.
//
//

#import <UIKit/UIKit.h>


@interface LocationViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView *theTableView;
    UISearchBar *theSearchBar;

    NSMutableArray *resultsArray;
    
    id delegate;
}

-(void)searchVenueResponse:(id)obj;

@property (nonatomic, retain) UITableView *theTableView;
@property (nonatomic, retain) UISearchBar *theSearchBar;

@property (nonatomic, retain) NSMutableArray *resultsArray;

@property (nonatomic, retain) id delegate;
@end
