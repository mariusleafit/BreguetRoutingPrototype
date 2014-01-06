//
//  Constants.m
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 03.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import "Constants.h"

@implementation Constants
+(AGSSpatialReference *)BASEMAP_SPATIALREFERENCE {
    return [[AGSSpatialReference alloc] initWithWKID:102100];
}
+(AGSSpatialReference *)BILUNE_SPATIALREFERENCE {
    return [[AGSSpatialReference alloc] initWithWKID:21781];
}
@end
