//
//  Room.m
//  BiluneGeoMobile
//
//  Created by Marius Gächter on 05.07.13.
//  Copyright (c) 2013 leafit. All rights reserved.
//

#import "Room.h"
#import "Floor.h"
#import "Building.h"

@implementation Room

@synthesize name;
@synthesize occupants;
@synthesize polygon;
@synthesize parentFloor;
@synthesize parentBuilding;
@synthesize address;
@synthesize type;
@synthesize area;

+(Room *)createWithName:(NSString *)name andOccupants:(NSString *)occupants andPolygon:(AGSPolygon *)polygon andParentFloor:(Floor *)floor andParentBuilding:(Building *)building andAddress:(NSString *)address andType:(NSString *)type andArea:(NSString *)area {
    
    Room *returnRoom = [[Room alloc] init ];
    returnRoom.name = name;
    returnRoom.occupants = occupants;
    returnRoom.polygon = polygon;
    returnRoom.parentFloor = floor;
    returnRoom.parentBuilding = building;
    returnRoom.address = address;
    returnRoom.type = type;
    returnRoom.area = [NSString stringWithFormat:@"%0.1f",[area floatValue]];
    
    return returnRoom;
}


#pragma mark GeneralSearchViewItem
-(NSString *)title {
    return self.name;
}

-(NSString *)detail {
    return self.occupants;
}

@end
