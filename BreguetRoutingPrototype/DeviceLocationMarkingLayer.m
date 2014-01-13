//
//  DevicePositionMarkingLayer.m
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 09.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import "DeviceLocationMarkingLayer.h"

@interface DeviceLocationMarkingLayer()
@property (nonatomic) AGSPoint *deviceLocation;
@property (nonatomic) bool isGPS;
@property (nonatomic) AGSSymbol *nogpsSymbol;
@property (nonatomic) AGSSymbol *gpsSymbol;
@property (nonatomic) AGSSimpleFillSymbol *accuracyCircleSymbol;
@end

@implementation DeviceLocationMarkingLayer
-(id)init {
    self = [super init];
    if(self) {
        self.gpsSymbol = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor blueColor]];
        self.nogpsSymbol = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor redColor]];
        self.accuracyCircleSymbol = [AGSSimpleFillSymbol simpleFillSymbolWithColor:nil outlineColor:[UIColor blackColor]];
    }
    return self;
}

-(void)setLocation:(AGSPoint *)deviceLocation withSpatialReference:(AGSSpatialReference *)sp{
    //project location
    AGSPoint *projectedLocation = (AGSPoint *)[[AGSGeometryEngine defaultGeometryEngine] projectGeometry:deviceLocation toSpatialReference:sp];
    
    //set members
    self.deviceLocation = projectedLocation;
    self.isGPS = NO;
    self.spatialReference = sp;
    
    //draw
    [self removeAllGraphics];
    [self addGraphic:[AGSGraphic graphicWithGeometry:deviceLocation symbol:self.nogpsSymbol attributes:nil infoTemplateDelegate:nil]];
}

-(void)setGPSLocation:(AGSLocation *)gpsLocation withSpatialReference:(AGSSpatialReference *)sp{
    //project location
    AGSPoint *projectedLocation = (AGSPoint *)[[AGSGeometryEngine defaultGeometryEngine] projectGeometry:gpsLocation.point toSpatialReference:sp];
    
    //set members
    self.isGPS = YES;
    self.deviceLocation = projectedLocation;
    self.spatialReference = sp;
    
    //draw
    [self removeAllGraphics];
    [self addGraphic:[AGSGraphic graphicWithGeometry:self.deviceLocation symbol:self.gpsSymbol attributes:nil infoTemplateDelegate:nil]];
    
    //draw accuracy circle
    AGSGeometryEngine *geometryEngine = [AGSGeometryEngine defaultGeometryEngine];
    self.accuracyCircle = [geometryEngine bufferGeometry:self.deviceLocation byDistance:gpsLocation.accuracy];
    
    AGSGraphic *circleGraphic = [AGSGraphic graphicWithGeometry:self.accuracyCircle symbol:self.accuracyCircleSymbol attributes:nil infoTemplateDelegate:nil];
    
    [self addGraphic:circleGraphic];
    
}

-(void)clear {
    [self removeAllGraphics];
    
    
}


@end
