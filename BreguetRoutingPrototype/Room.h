//
//  Room.h
//  BiluneGeoMobile
//
//  Created by Marius Gächter on 05.07.13.
//  Copyright (c) 2013 leafit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Floor.h"
#import "GeneralSearchViewItem.h"

@class Floor;
@class Building;

@interface Room : NSObject<GeneralSearchViewItem> {
    
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *occupants;
@property (nonatomic, strong) AGSPolygon *polygon;
@property (nonatomic) Floor *parentFloor;
@property (nonatomic, strong) Building *parentBuilding;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *area;

+(Room *)createWithName:(NSString *)name andOccupants:(NSString *)occupants andPolygon:(AGSPolygon *)polygon andParentFloor:(Floor *)floor
       andParentBuilding:(Building *)building andAddress:(NSString *)address andType:(NSString *)type andArea:(NSString *)area;


@end
