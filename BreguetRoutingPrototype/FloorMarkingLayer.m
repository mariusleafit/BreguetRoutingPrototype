//
//  FloorMarkingLayer.m
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 09.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import "FloorMarkingLayer.h"

@interface FloorMarkingLayer()
@property (nonatomic) AGSFeatureLayer *featureLayer;
@property (nonatomic) AGSSimpleFillSymbol *highlightSymbol;
@property (nonatomic) AGSSimpleFillSymbol *symbol;
@end


@implementation FloorMarkingLayer
-(id)initWithFeatureLayer:(AGSFeatureLayer *)featureLayer{
    self = [super init];
    if(self) {
        self.featureLayer = featureLayer;
        self.symbol = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithWhite:0.5 alpha:0.5] outlineColor:nil];
        self.highlightSymbol = [AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:.5] outlineColor:nil];
        
        for (AGSGraphic *roomGraphic in self.featureLayer.graphics) {
            [self markRoom:roomGraphic highlight:NO];
        }
    }
    return  self;
}
-(void)markRoom:(AGSGraphic *)roomGraphic highlight:(bool)highlight{
    AGSGraphic *tmpRoomGraphic = [AGSGraphic graphicWithGeometry:roomGraphic.geometry symbol:self.symbol attributes:nil infoTemplateDelegate:nil];
    if(highlight) {
        [tmpRoomGraphic setSymbol:self.highlightSymbol];
    }
    [self addGraphic:tmpRoomGraphic];
}
-(void)clear{
    [self removeAllGraphics];
}
@end
