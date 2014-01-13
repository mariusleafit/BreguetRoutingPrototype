//
//  ChangeFloorViewDelegate.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 10.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChangeFloorViewController.h"

@protocol ChangeFloorViewDelegate<NSObject>
-(void)changeFloorView:(ChangeFloorViewController *)viewController visibleFloorsDidChange:(NSArray *)visibleFloors;
@end
