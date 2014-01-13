//
//  ChangeFloorViewController.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 10.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Building.h"

@protocol ChangeFloorViewDelegate;

@interface ChangeFloorViewController : UIViewController<UITableViewDataSource>
@property (nonatomic) Building *building;
@property (nonatomic) NSString *identifier;

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Identifier:(NSString *)identifier Building:(Building *)building delegate:(id<ChangeFloorViewDelegate>)delegate;

-(NSArray *)getVisibleFloors;

@property (weak, nonatomic) IBOutlet UITableView *floorList;
@end
