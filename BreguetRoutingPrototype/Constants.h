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

#define BREGUET_SS_GEOCODEURL @"http://130.125.97.56:6080/arcgis/rest/services/routpamr/_bre1_loc_00_CreateAddressLo/GeocodeServer"
#define BREGUET_R_GEOCODEURL @"http://130.125.97.56:6080/arcgis/rest/services/routpamr/_bre1_loc_0_CreateAddressLoc/GeocodeServer"
#define BREGUET_E1_GEOCODEURL @"http://130.125.97.56:6080/arcgis/rest/services/routpamr/_bre1_loc_1_CreateAddressLoc/GeocodeServer"
#define BREGUET_E2_GEOCODEURL @"http://130.125.97.56:6080/arcgis/rest/services/routpamr/Breguet1_2_rpamr_CreateAddre/GeocodeServer"
#define BREGUET_E3_GEOCODEURL @"http://130.125.97.56:6080/arcgis/rest/services/routpamr/Breguet1_3_rpamr_CreateAddre/GeocodeServer"



#define BREGUET_ROUTINGURL @"http://130.125.97.56:6080/arcgis/rest/services/routpamr/19_Breguet1_routpamr/NAServer/Route"
@interface Constants : NSObject
+(AGSSpatialReference *) BASEMAP_SPATIALREFERENCE;
+(AGSSpatialReference *) BILUNE_SPATIALREFERENCE;



@end
