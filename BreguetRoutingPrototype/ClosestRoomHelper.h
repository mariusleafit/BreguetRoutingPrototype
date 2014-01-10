//
//  ClosestRoomHelper.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 09.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@interface ClosestRoomHelper : NSObject
+(AGSPolygon*)getClosestRoom:(AGSPoint *)point onFeatureLayer:(AGSFeatureLayer *)featureLayer;
@end
