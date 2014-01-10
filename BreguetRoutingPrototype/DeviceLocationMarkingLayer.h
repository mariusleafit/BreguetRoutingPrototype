//
//  DevicePositionMarkingLayer.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 09.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>

@interface DeviceLocationMarkingLayer : AGSGraphicsLayer
-(id)init;
-(void)setLocation:(AGSPoint *)deviceLocation isGPS:(bool)isgps;
-(void)clear;
@end
