//
//  AppDelegate.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 03.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavigationController.h"
#import "BuildingStack.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) BuildingStack *buildingStack;

@property (strong, nonatomic) CustomNavigationController *navigationController;
@end
