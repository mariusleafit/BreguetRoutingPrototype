//
//  BasicListSelectorProtocol.h
//  eTimeGUI
//
//  Created by Marius Gächter on 20.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BasicListSelectorItem.h"

@protocol BasicListSelectorDelegate <NSObject>
-(void)BasicList:(NSString *)identifier selectionChanged:(id<BasicListSelectorItem>)selection;
@end
