//
//  FloorMarkingLayer.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 09.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>

@interface FloorMarkingLayer : AGSGraphicsLayer
-(id)initWithFeatureLayer:(AGSFeatureLayer *)featureLayer;
-(void)markRoom:(AGSGraphic *)roomGraphic highlight:(bool)highlight;
-(void)clear;
@end
