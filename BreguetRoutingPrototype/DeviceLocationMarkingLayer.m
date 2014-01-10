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
@end

@implementation DeviceLocationMarkingLayer
-(id)init {
    self = [super init];
    if(self) {
        self.gpsSymbol = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor blueColor]];
        self.nogpsSymbol = [AGSSimpleMarkerSymbol simpleMarkerSymbolWithColor:[UIColor redColor]];
    }
    return self;
}

-(void)setLocation:(AGSPoint *)deviceLocation isGPS:(bool)isgps {
    self.deviceLocation = deviceLocation;
    self.isGPS = isgps;
    
    [self removeAllGraphics];
    if(self.isGPS) {
        [self addGraphic:[AGSGraphic graphicWithGeometry:deviceLocation symbol:self.nogpsSymbol attributes:nil infoTemplateDelegate:nil]];
    } else {
        [self addGraphic:[AGSGraphic graphicWithGeometry:deviceLocation symbol:self.gpsSymbol attributes:nil infoTemplateDelegate:nil]];
    }
}

-(void)clear {
    [self removeAllGraphics];
    
    
}


@end
