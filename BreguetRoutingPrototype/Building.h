//
//  Building.h
//  BiluneGeoMobile
//
//  Created by Marius Gächter on 05.07.13.
//  Copyright (c) 2013 leafit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>
#import "Floor.h"
#import "Room.h"
@interface Building : NSObject {
    
    
}

@property (nonatomic, strong) NSURL *fullURL;
@property (nonatomic, strong) NSString *shortURL;
@property (nonatomic, strong) NSString *mapName;
@property (nonatomic, strong) NSString *address;


@property (nonatomic, strong) AGSEnvelope *extent;
@property (nonatomic, strong) AGSEnvelope *maxExtent;
@property (nonatomic, strong) AGSSpatialReference *spatialReference;


+(Building *)createWithData:(NSDictionary *)data;

-(NSString *)getBatCode;
-(NSArray *)getFloorsSortedAsc:(BOOL)asc;
-(NSArray *)getFloors;
-(NSArray *)getVisibleFloorsSortedAsc:(BOOL)asc;
-(NSArray *)getVisibleFloorIDsSortedAsc:(BOOL)asc;
-(Floor *)getFloorWithFloorCode:(NSString *)floorCode;
-(Floor *)getFloorWithFloorID:(NSNumber *)floorID;
-(void)changeVisibleFloorsWithFloorCode:(NSString *)floorCode;
-(void)changeVisibleFloorsWithFloorCodes:(NSArray *)floorCodes;

//set the Visibility of the Floors to the defaultVisibility
-(void)resetFloorVisibility;

-(UIImage *)getImage;
-(BOOL)isClickedWithPoint:(AGSPoint *)point andSpatialReference:(AGSSpatialReference *)spatialReference;



@end
