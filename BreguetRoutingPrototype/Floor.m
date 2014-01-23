//
//  Floor.m
//  BiluneGeoMobile
//
//  Created by Marius Gächter on 05.07.13.
//  Copyright (c) 2013 leafit. All rights reserved.
//

#import "Floor.h"
#import "Building.h"

@interface Floor()

@end

@implementation Floor

@synthesize floorID;
@synthesize floorName;
@synthesize floorCode;
@synthesize parentBuilding;
@synthesize defaultVisibility;
@synthesize extent;


+(Floor *)createWithData:(NSDictionary *)data andParentBuilding:(Building *)parentBuilding {
    if(data == nil) {
        return nil;
    }
    
    Floor *returnFloor = [[Floor alloc] init];
    returnFloor.parentBuilding = parentBuilding;
    
    //load data from JSON
    returnFloor.floorID = (NSNumber *)[data valueForKey:@"ID"];
    
    returnFloor.floorName = (NSString *)[data valueForKey:@"Name"];
    
    returnFloor.floorCode = (NSString *)[data valueForKey:@"Code"];
    
    returnFloor.defaultVisibility = [((NSNumber *)[data valueForKey:@"DefaultVisibility"]) boolValue];
    [returnFloor setVisibility:returnFloor.defaultVisibility];
    
    //Extend
    returnFloor.extent = [[AGSEnvelope alloc]
                             initWithXmin: [[data valueForKey:@"XMin"] doubleValue]
                             ymin: [[data valueForKey:@"YMin"] doubleValue]
                             xmax: [[data valueForKey:@"XMax"] doubleValue]
                             ymax: [[data valueForKey:@"YMax"] doubleValue]
                             spatialReference:[returnFloor getSpatialReference]];
    
    return returnFloor;
}

///returns fullUrl of parentBuilding
-(NSURL *)getParentBuildingURL {
    return self.parentBuilding.fullURL;
}

-(NSString *)getStrFloorID {
    return [NSString stringWithFormat:@"%@", self.floorID];
}

-(NSURL *)getFloorURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@/%@", self.getParentBuildingURL, self.getStrFloorID]];
}

-(AGSSpatialReference *)getSpatialReference {
    return self.parentBuilding.spatialReference;
}

-(void) setVisibility:(BOOL)pVisibility {
    visibility = [[NSNumber alloc] initWithBool:pVisibility];
}

-(void)resetVisibility {
    visibility = [[NSNumber alloc] initWithBool:self.defaultVisibility];
}

-(BOOL) isVisible{
    return [visibility boolValue];
}

#pragma mark BasicListSelectorItem

-(NSString *)toString {
    return self.floorName;
}

-(NSString *)detailString {
    return @"";
}
@end
