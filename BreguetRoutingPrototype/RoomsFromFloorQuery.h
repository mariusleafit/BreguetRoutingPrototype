//
//  RoomsFormFloorQuery.h
//  BiluneGeoMobile
//
//  Created by Marius Gächter on 06.08.13.
//  Copyright (c) 2013 leafit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "Floor.h"
#import "MultipleRoomsQueryDelegate.h"
#import "BuildingStack.h"

@interface RoomsFromFloorQuery : NSObject<AGSQueryTaskDelegate>
-(id)initWithFloor:(Floor *)floor andName:(NSString *)queryName andDelegate:(id<MultipleRoomsQueryDelegate>)delegate;
-(void)execute;
@end
