//
//  ChangeFloorViewController.m
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 10.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import "ChangeFloorViewController.h"
#import "ChangeFloorListCell.h"
#import "ChangeFloorViewDelegate.h"

@interface ChangeFloorViewController ()


@property (nonatomic) id<ChangeFloorViewDelegate> delegate;

@end

@implementation ChangeFloorViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Identifier:(NSString *)identifier Building:(Building *)building delegate:(id<ChangeFloorViewDelegate>)delegate {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.building = building;
        self.delegate = delegate;
        self.identifier = identifier;
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.floorList.dataSource = self;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.delegate changeFloorView:self visibleFloorsDidChange:[self getVisibleFloors]];
}

-(NSArray *)getVisibleFloors {
    return [self.building getVisibleFloors];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.building getFloors] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ChangeFloorCell";
    
    //get cell
    ChangeFloorListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        UIViewController *tmpViewController = [[UIViewController alloc] initWithNibName:@"ChangeFloorCell" bundle:nil];
        //cell = [[ChangeFloorListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell = (ChangeFloorListCell *)tmpViewController.view;
    }
    
    //get Floor
    Floor *floor = [[self.building getFloorsSortedAsc:NO] objectAtIndex:indexPath.row];
    if(floor) {
        cell.floorName.text = floor.floorName;
        [cell.visibilitySwitch setOn:floor.isVisible];
        cell.floor = floor;
    }
    
    return cell;
}


@end
