    //
//  BuildingStack.m
//  BiluneGeoMobile
//
//  Created by Marius Gächter on 05.07.13.
//  Copyright (c) 2013 leafit. All rights reserved.
//

#import "BuildingStack.h"

@interface BuildingStack()

@property(strong) NSMutableArray *buildings;

@end

@implementation BuildingStack

@synthesize buildings;

-(id)init {
    self = [super init];
    if(self) {
        self.buildings = [[NSMutableArray alloc] init];
        
    }
    return self;
}

//hardcode breguet
+(BuildingStack *) createWithBreguet {
    NSMutableDictionary *breguetParams = [[NSMutableDictionary alloc] initWithCapacity:20];
    [breguetParams setObject:@"Rue Abram-Louis Breguet 1, 2000 Neuchâtel" forKey:@"Address"];
    [breguetParams setObject:@"19_Breguet1" forKey:@"Name"];
    [breguetParams setObject:@"ebilune/19_breguet1_web" forKey:@"Url"];
    [breguetParams setObject:@"21781" forKey:@"SpacialReference"];
    [breguetParams setObject:@"562078.13662500144" forKey:@"XMax"];
    [breguetParams setObject:@"562017.77467499836" forKey:@"XMin"];
    [breguetParams setObject:@"204909.91502241665" forKey:@"YMax"];
    [breguetParams setObject:@"204860.75337758413" forKey:@"YMin"];
    
    NSMutableArray *floors = [NSMutableArray arrayWithCapacity:5];
    [floors addObject:[NSDictionary dictionaryWithObjects:
                      [NSArray arrayWithObjects:@"E3",@"false",@"0",@"Etage 3",@"562075.39290000126",@"562020.51839999855", @"204905.50290000066",@"204865.16550000012",  nil]
                        forKeys:[NSArray arrayWithObjects:@"Code",@"DefaultVisibility",@"ID",@"Name",@"XMax",@"XMin",@"YMax",@"YMin",nil]]];
    [floors addObject:[NSDictionary dictionaryWithObjects:
                       [NSArray arrayWithObjects:@"E2",@"false",@"1",@"Etage2",@"562075.257100001",@"562020.53110000119", @"204906.19810000062",@"204865.20499999821",  nil]
                                                  forKeys:[NSArray arrayWithObjects:@"Code",@"DefaultVisibility",@"ID",@"Name",@"XMax",@"XMin",@"YMax",@"YMin",nil]]];
    [floors addObject:[NSDictionary dictionaryWithObjects:
                       [NSArray arrayWithObjects:@"E1",@"true",@"2",@"Etage 1",@"562075.29360000044",@"562020.53170000017", @"204906.22360000014",@"204865.184799999", nil]
                                                  forKeys:[NSArray arrayWithObjects:@"Code",@"DefaultVisibility",@"ID",@"Name",@"XMax",@"XMin",@"YMax",@"YMin",nil]]];
    [floors addObject:[NSDictionary dictionaryWithObjects:
                       [NSArray arrayWithObjects:@"R",@"false",@"3",@"Etage rez",@"562075.30900000036",@"562027.4728000015", @"204905.48950000107",@"204873.50609999895", nil]
                                                  forKeys:[NSArray arrayWithObjects:@"Code",@"DefaultVisibility",@"ID",@"Name",@"XMax",@"XMin",@"YMax",@"YMin",nil]]];
    [floors addObject:[NSDictionary dictionaryWithObjects:
                       [NSArray arrayWithObjects:@"SS",@"false",@"4",@"Etage sous-sol",@"562078.16160000116",@"562026.22890000045", @"204906.46130000055",@"204873.67350000143", nil]
                                                  forKeys:[NSArray arrayWithObjects:@"Code",@"DefaultVisibility",@"ID",@"Name",@"XMax",@"XMin",@"YMax",@"YMin",nil]]];
    
    
    
    [breguetParams setObject:floors forKey:@"Floors"];
    
    
    
    return [self createWithData:[NSArray arrayWithObject:breguetParams]];
}

///*create BuildingStack with JSON-data
+(BuildingStack *) createWithData:(NSDictionary *)data {
    if(data == nil) {
        return nil;
    }
    
    BuildingStack *returnBuildingStack = [[BuildingStack alloc] init];
    
    //initialize with Dictionary
    // add Buildings
    for(NSDictionary *buildingDict in data) {
        if(buildingDict != nil) {
            Building *tmpBuilding = [Building createWithData:buildingDict];
            if(tmpBuilding) {
                [returnBuildingStack.buildings addObject:tmpBuilding];
            }
        }
    }

    return returnBuildingStack;
}

///*get Building with URL (eg. http://biluneapp.unine.ch/arcgis/rest/services/ebilune/30_unimail_web/MapServer)
-(Building *) getBuildingWithFullURL:(NSURL *)pFullURL{
    Building *returnBuilding = nil;
    if(self.buildings && self.buildings.count > 0) {
        int i = 0;
        while(returnBuilding == nil && self.buildings.count > i) {
            Building *tmpBuilding = (Building *)self.buildings[i];
            if([[tmpBuilding.fullURL absoluteString] isEqualToString:[pFullURL absoluteString]]) {
                returnBuilding = tmpBuilding;
            }
            i++;
        }
    }
    return returnBuilding;
}

///*get Building with URL (eg. ebilune/30_unimail_web)
-(Building *) getBuildingWithShortURL:(NSString *)pShortURL {
    Building *returnBuilding = nil;
    if(self.buildings && self.buildings.count > 0) {
        int i = 0;
        while(returnBuilding == nil && self.buildings.count > i) {
            Building *tmpBuilding = (Building *)self.buildings[i];
            if([tmpBuilding.shortURL isEqualToString:pShortURL]) {
                returnBuilding = tmpBuilding;
            }
            i++;
        }
    }
    return returnBuilding;
}

-(Building *)getBuildingWithPoint:(AGSPoint *)point andSpatialReference:(AGSSpatialReference *)spatialReference {
    Building *returnBuilding = nil;
    int i = 0;
    while(returnBuilding == nil && i < [self.buildings count]) {
        Building *tmpBuilding = [self.buildings objectAtIndex:i];
        if([tmpBuilding isClickedWithPoint:point andSpatialReference:nil]) {
            returnBuilding = tmpBuilding;
        }
        i++;
    }
    return returnBuilding;
}

-(NSArray *)getBuildings {
    return buildings;
}

-(void)resetFloorVisibility {
    for(Building *building in self.buildings) {
        [building resetFloorVisibility];
    }
}

@end
