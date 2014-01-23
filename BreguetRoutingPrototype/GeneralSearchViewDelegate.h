//
//  GeneralSearchViewDelegate.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 23.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GeneralSearchViewItem.h"

@class GeneralSearchViewController;

@protocol GeneralSearchViewDelegate <NSObject>
-(void)generalSearchView:(GeneralSearchViewController *)viewController itemSelected:(id<GeneralSearchViewItem>)selection;
@end
