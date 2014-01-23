//
//  BasicListSelectorItem.h
//  eTimeGUI
//
//  Created by Marius Gächter on 20.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BasicListSelectorItem <NSObject>
-(NSString *)toString;
-(NSString *)detailString;
@end
