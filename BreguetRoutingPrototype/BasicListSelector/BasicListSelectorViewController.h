//
//  BasicListSelectorViewController.h
//  eTimeGUI
//
//  Created by Marius Gächter on 20.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BasicListSelectorDelegate.h"
#import "BasicListSelectorItem.h"


@interface BasicListSelectorViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *list;

-(id)initWithIdentifier:(NSString *)identifier data:(NSArray *)data selectedItem:(id<BasicListSelectorItem>)itemOrNil delegate:(id<BasicListSelectorDelegate>)delegate cellStyle:(UITableViewCellStyle)cellStyle;
@end
