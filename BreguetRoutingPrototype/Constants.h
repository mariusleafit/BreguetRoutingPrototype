//
//  Constants.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 03.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

#define STREETBASEMAPURL @"http://services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer"

#define BREGUETBASEURL @"https://biluneapp.unine.ch/arcgis/rest/services/ebilune/19_breguet1_web/MapServer"

#define BILUNEMAINURL @"http://biluneapp.unine.ch/arcgis/rest/services/ebilune/"

@interface Constants : NSObject
+(AGSSpatialReference *) BASEMAP_SPATIALREFERENCE;
+(AGSSpatialReference *) BILUNE_SPATIALREFERENCE;



@end
