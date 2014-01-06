//
//  BuildingStack.h
//  BiluneGeoMobile
//
//  Created by Marius Gächter on 05.07.13.
//  Copyright (c) 2013 leafit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"

@interface BuildingStack : NSObject {
    
}

///*create BuildingStack with JSON-data
+(BuildingStack *) createWithData:(NSDictionary *)data;

+(BuildingStack *) createWithBreguet;

///*get Building with URL (eg. http://biluneapp.unine.ch/arcgis/rest/services/ebilune/30_unimail_web/MapServer)
-(Building *) getBuildingWithFullURL:(NSURL *)pFullURL;
///*get Building with URL (eg. ebilune/30_unimail_web)
-(Building *) getBuildingWithShortURL:(NSString *)pShortURL;

-(Building *) getBuildingWithPoint:(AGSPoint *)point andSpatialReference:(AGSSpatialReference *)spatialReference;

-(NSArray *) getBuildings;

-(void) resetFloorVisibility;
@end
