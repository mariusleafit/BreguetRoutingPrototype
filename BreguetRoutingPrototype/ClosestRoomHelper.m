//
//  ClosestRoomHelper.m
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 09.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import "ClosestRoomHelper.h"
#import "Constants.h"

@implementation ClosestRoomHelper
+(AGSGraphic*)getClosestRoom:(AGSPoint *)point inCircle:(AGSPolygon *)circle onFeatureLayer:(AGSFeatureLayer *)featureLayer {
    AGSGeometryEngine *geometryEngine = [AGSGeometryEngine defaultGeometryEngine];
    
    NSMutableArray *roomsInCircle = [NSMutableArray arrayWithCapacity:15];
    
    //get rooms in circle
    for (AGSGraphic *roomGraphic in featureLayer.graphics) {
        if([geometryEngine geometry:roomGraphic.geometry intersectsGeometry:circle]) {
            [roomsInCircle addObject:roomGraphic];
        }
    }
    
    //get closest room 
    double smallestDistance = -1;
    AGSGraphic *closestRoom = nil;
    
    AGSPoint *projectedPoint = (AGSPoint *)[geometryEngine projectGeometry:point toSpatialReference:[Constants BASEMAP_SPATIALREFERENCE]];
    
    for (AGSGraphic *roomGraphic in roomsInCircle) {
        
        double tmpDistance = [geometryEngine distanceFromGeometry:roomGraphic.geometry toGeometry:projectedPoint];
        if(smallestDistance == -1 || tmpDistance < smallestDistance) {
            smallestDistance = tmpDistance;
            closestRoom = roomGraphic;
        }
    }
    return closestRoom;
}
@end
