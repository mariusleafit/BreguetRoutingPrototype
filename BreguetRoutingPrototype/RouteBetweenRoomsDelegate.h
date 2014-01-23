//
//  RouteBetweenRoomsDelegate.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 23.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RouteBetweenRooms;
@protocol RouteBetweenRoomsDelegate <NSObject>

-(void)routeBetweenRooms:(RouteBetweenRooms *)route errorOccured:(NSError *)error;
-(void)routeBetweenRooms:(RouteBetweenRooms *)route gotResult:(AGSRouteResult *)result;
@end
