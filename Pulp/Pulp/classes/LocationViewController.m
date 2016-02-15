//
//  LocationViewController.m
//  Calendar
//
//  Created by Josh Klobe on 5/14/13.
//
//

#import "LocationViewController.h"


@interface LocationViewController ()

@end

@implementation LocationViewController

@synthesize theTableView, theSearchBar;

@synthesize resultsArray;

@synthesize delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *exitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    exitButton.backgroundColor = [UIColor blackColor];
    [exitButton addTarget:self action:@selector(exitButtonHit) forControlEvents:UIControlEventTouchUpInside];
    [exitButton setTitle:@"X" forState:UIControlStateNormal];
    exitButton.frame = CGRectMake(0, 0 , 44,44);
    [self.view addSubview:exitButton];
    
    self.theSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(exitButton.frame.size.width,0, self.view.frame.size.width - exitButton.frame.size.width, 44)];
    self.theSearchBar.delegate = self;
    [self.view addSubview:self.theSearchBar];
    
    
    self.theTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.theSearchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.theSearchBar.frame.size.height)];
    self.theTableView.dataSource = self;
    self.theTableView.delegate = self;
    [self.view addSubview:self.theTableView];
    
    self.resultsArray = [[NSMutableArray alloc] initWithCapacity:0];
 
    [self.theSearchBar becomeFirstResponder];
}


- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    NSString *theText = [NSString stringWithFormat:@"%@%@", self.theSearchBar.text, text];
    return YES;
}


-(void)searchVenueResponse:(id)obj
{
    [self.resultsArray removeAllObjects];
    
    NSDictionary *returnDictionary = [NSDictionary dictionaryWithDictionary:obj];
    NSDictionary *metaDictionary = [returnDictionary objectForKey:@"meta"];
    NSDictionary *responseDictionary = [returnDictionary objectForKey:@"response"];
    
//    /NSLog(@"obj: %@", obj);
    
    
    
    if ([[metaDictionary objectForKey:@"code"] intValue] == 200)
    {
        NSLog(@"success");
        [self.resultsArray removeAllObjects];
        [self.resultsArray addObjectsFromArray:[responseDictionary objectForKey:@"minivenues"]];
        

        [self.theTableView reloadData];
    }

    
    

    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.resultsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
   
    NSDictionary *resultObject = [self.resultsArray objectAtIndex:indexPath.row];
    cell.textLabel.text = [resultObject objectForKey:@"name"];
    
    // Configure the cell...
    
    return cell;
}

-(void) exitButtonHit
{
    NSLog(@"exitButtonHit self.delegate: %@", self.delegate);
//    [self.delegate locationExitButtonHit:self];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.theSearchBar resignFirstResponder];
}


@end
