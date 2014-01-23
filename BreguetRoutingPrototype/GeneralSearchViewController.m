//
//  GeneralSearchViewController.m
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 23.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import "GeneralSearchViewController.h"
#import "GeneralSearchViewItem.h"

@interface GeneralSearchViewController ()
@property (nonatomic) NSArray *data;
@property (nonatomic) UITableViewCellStyle cellStyle;
@property (nonatomic) id<GeneralSearchViewDelegate> delegate;

@property (nonatomic) bool isSearching;
@property (nonatomic) NSMutableArray *filteredData;

@property (nonatomic) UISearchDisplayController *searchController;
@end

@implementation GeneralSearchViewController

-(id)initWith:(NSArray *)data cellStyle:(UITableViewCellStyle)cellStyle delegate:(id<GeneralSearchViewDelegate>)delegate{
     self = [super initWithNibName:@"GeneralSearchView" bundle:nil];
    if(self) {
        self.data = data;
        self.cellStyle = cellStyle;
        self.delegate = delegate;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.isSearching = false;
    self.filteredData = [[NSMutableArray alloc] init];
    
    self.searchController = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    
    
    self.searchController.delegate = self;
    self.searchController.searchResultsDataSource = self;
    self.searchController.searchResultsDelegate = self;
    
    self.list.delegate = self;
    self.list.dataSource = self;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark helper methods

- (void)filterListForSearchText:(NSString *)searchText
{
    [self.filteredData removeAllObjects]; //clears the array from all the string objects it might contain from the previous searches
    
    for (id<GeneralSearchViewItem> item in self.data) {
        NSRange nameRange = [[item title] rangeOfString:searchText options:NSCaseInsensitiveSearch];
        if (nameRange.location != NSNotFound) {
            [self.filteredData addObject:item];
        }
    }
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //delegate aufrufen und view schliessen
    id<GeneralSearchViewItem> selectedItem = [self.data objectAtIndex:indexPath.row];
    [self.delegate generalSearchView:self itemSelected:selectedItem];
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.isSearching) {
        return self.filteredData.count;
    } else {
        return self.data.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"cell";
    UITableViewCell *cell = [self.list dequeueReusableCellWithIdentifier:cellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:self.cellStyle reuseIdentifier:cellIdentifier];
    }
    
    id<GeneralSearchViewItem> item = nil;
    if(self.isSearching) {
        item = [self.filteredData objectAtIndex:indexPath.row];
    } else {
        item = [self.data objectAtIndex:indexPath.row];
    }
    
    cell.textLabel.text = [item title];
    if(self.cellStyle != UITableViewCellStyleDefault) {
        cell.detailTextLabel.text = [item detail];
    }
    
    return cell;
}


#pragma mark UISearchDisplayControllerDelegate
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller {
    //When the user taps the search bar, this means that the controller will begin searching.
    self.isSearching = YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    //When the user taps the Cancel Button, or anywhere aside from the view.
    self.isSearching = NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterListForSearchText:searchString];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterListForSearchText:[self.searchDisplayController.searchBar text]];    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


@end
