//
//  DevicePositionMarkingLayer.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 09.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>

@interface DeviceLocationMarkingLayer : AGSGraphicsLayer

@property (nonatomic) AGSPolygon *accuracyCircle;
@property (nonatomic) AGSSpatialReference *spatialReference;

-(id)init;
-(void)setLocation:(AGSPoint *)deviceLocation withSpatialReference:(AGSSpatialReference *)sp;
-(void)setGPSLocation:(AGSLocation *)gpsLocation withSpatialReference:(AGSSpatialReference *)sp;
-(void)clear;
@end
