//
//  BasicListSelectorViewController.m
//  eTimeGUI
//
//  Created by Marius Gächter on 20.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import "BasicListSelectorViewController.h"

@interface BasicListSelectorViewController ()
@property (nonatomic) NSArray *data;
@property (nonatomic) id<BasicListSelectorDelegate> delegate;
@property (nonatomic) NSString *identifier;
@property (nonatomic) id<BasicListSelectorItem> selectedItem;
@property (nonatomic) UITableViewCellStyle cellStyle;
@end

@implementation BasicListSelectorViewController

-(id)initWithIdentifier:(NSString *)identifier data:(NSArray *)data selectedItem:(id<BasicListSelectorItem>)itemOrNil delegate:(id<BasicListSelectorDelegate>)delegate cellStyle:(UITableViewCellStyle)cellStyle {
    self = [super initWithNibName:@"BasicListSelector" bundle:nil];
    if(self) {
        self.identifier = identifier;
        self.data = data;
        self.selectedItem = itemOrNil;
        self.delegate = delegate;
        self.cellStyle = cellStyle;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.list.dataSource = self;
    self.list.delegate = self;

}

-(void)viewWillDisappear:(BOOL)animated {
    [self.delegate BasicList:self.identifier selectionChanged:self.selectedItem];
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.data.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"BasicCell";
    
    //get cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    //decide if detailText has to be displayed
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:self.cellStyle reuseIdentifier:cellIdentifier];
    }
    id<BasicListSelectorItem> currentListItemData = (id<BasicListSelectorItem>)[self.data objectAtIndex:indexPath.row];
    
    if([currentListItemData isKindOfClass:[NSString class]]) {
        cell.textLabel.text = (NSString *)currentListItemData;
        cell.detailTextLabel.text = @"";
    } else {
        cell.textLabel.text = [currentListItemData toString];
        cell.detailTextLabel.text = [currentListItemData detailString];
    }
    
    
    if(currentListItemData == self.selectedItem) {
        [self.list selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionTop];
    }
    
    return cell;
}

#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id<BasicListSelectorItem> selectedItem = (id<BasicListSelectorItem>)[self.data objectAtIndex:indexPath.row];
    
    if(selectedItem) {
        self.selectedItem = selectedItem;
    }
}

@end
