//
//  GetRouteBetweenRooms.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 23.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "RouteBetweenRoomsDelegate.h"

@interface RouteBetweenRooms : NSObject<AGSLocatorDelegate, AGSRouteTaskDelegate>
-(id)initWithRooms:(NSArray *)rooms delegate:(id<RouteBetweenRoomsDelegate>)delegate;
-(void)execute;
@end
