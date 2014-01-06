//
//  Floor.h
//  BiluneGeoMobile
//
//  Created by Marius Gächter on 05.07.13.
//  Copyright (c) 2013 leafit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

@class Building;

@interface Floor : NSObject {
    NSNumber* visibility;
}

@property(strong, nonatomic) NSNumber *floorID;
@property(strong, nonatomic) NSString *floorName;
@property(strong, nonatomic) NSString *floorCode;
@property(strong, nonatomic) Building *parentBuilding;
@property (nonatomic, strong) AGSEnvelope *extent;
@property BOOL defaultVisibility;

+(Floor *)createWithData:(NSDictionary *)data andParentBuilding:(Building *)parentBuilding;

-(NSURL *)getParentBuildingURL;
-(NSString *)getStrFloorID;
-(NSURL *)getFloorURL;

//sets the Visiblity to the defaultVisibility
-(void)resetVisibility;

-(void)setVisibility:(BOOL)pVisibility;
-(BOOL)isVisible;


-(AGSSpatialReference *)getSpatialReference;

@end
