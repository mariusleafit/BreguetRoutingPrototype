//
//  GeneralSearchViewController.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 23.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeneralSearchViewDelegate.h"

@interface GeneralSearchViewController : UIViewController<UISearchDisplayDelegate,UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *list;
@property (nonatomic) int *identifier;

/**data: array of id<GeneralSearchViewItems>**/
-(id)initWith:(NSArray *)data cellStyle:(UITableViewCellStyle)cellStyle delegate:(id<GeneralSearchViewDelegate>)delegate;
@end
