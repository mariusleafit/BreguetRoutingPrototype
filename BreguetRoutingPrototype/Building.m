//
//  Building.m
//  BiluneGeoMobile
//
//  Created by Marius Gächter on 05.07.13.
//  Copyright (c) 2013 leafit. All rights reserved.
//

#import "Building.h"
#import "Constants.h"



@interface Building()

@property(strong) NSMutableArray *floors;

@end

@implementation Building

@synthesize fullURL;
@synthesize shortURL;
@synthesize mapName;
@synthesize address;
@synthesize floors;

@synthesize extent;
@synthesize maxExtent;
@synthesize spatialReference;


+(Building *) createWithData:(NSDictionary *)data {
    if(data == nil) {
        return nil;
    }
    
    Building *returnBuilding = [[Building alloc]init];
    
    //init with NSDictionary
    returnBuilding.shortURL = (NSString *)[data valueForKey:@"Url"];
    returnBuilding.fullURL = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@%@/MapServer", BILUNEMAINURL,[[data valueForKey:@"Url"] stringByReplacingOccurrencesOfString:@"ebilune/" withString:@""]]];
    
    returnBuilding.mapName = (NSString *)[data valueForKey:@"Name"];
    
    returnBuilding.address = (NSString *)[data valueForKey:@"Address"];
    
    //Extent & SpatialReference
    AGSSpatialReference *spatialReference = [[AGSSpatialReference alloc] initWithWKID:[[data valueForKey:@"SpacialReference"] intValue]];
    returnBuilding.spatialReference = spatialReference;
    returnBuilding.extent = [[AGSEnvelope alloc]
                             initWithXmin: [[data valueForKey:@"XMin"] doubleValue]
                             ymin: [[data valueForKey:@"YMin"] doubleValue]
                             xmax: [[data valueForKey:@"XMax"] doubleValue]
                             ymax: [[data valueForKey:@"YMax"] doubleValue]
                             spatialReference:spatialReference];
    
    //getFloors
    returnBuilding.floors = [[NSMutableArray alloc] init];
    for (NSDictionary *floorDict in (NSDictionary *)[data valueForKey:@"Floors"]) {
        if(floorDict != nil) {
            Floor *tmpFloor = [Floor createWithData:floorDict andParentBuilding:returnBuilding];
            if(tmpFloor) {
                [returnBuilding.floors addObject: tmpFloor];
            }
        }
    }
    
    //calculate MaxExtent
    double xmin = ((Floor *)[returnBuilding.floors objectAtIndex:0]).extent.xmin;
    double ymin = ((Floor *)[returnBuilding.floors objectAtIndex:0]).extent.ymin;
    double xmax = ((Floor *)[returnBuilding.floors objectAtIndex:0]).extent.xmax;
    double ymax = ((Floor *)[returnBuilding.floors objectAtIndex:0]).extent.ymax;
    for(int i = 1; i < [returnBuilding.floors count]; i++) {
        if(xmin > ((Floor *)[returnBuilding.floors objectAtIndex:i]).extent.xmin) {
            xmin = ((Floor *)[returnBuilding.floors objectAtIndex:i]).extent.xmin;
        }
        if(ymin > ((Floor *)[returnBuilding.floors objectAtIndex:i]).extent.ymin) {
            ymin = ((Floor *)[returnBuilding.floors objectAtIndex:i]).extent.ymin;
        }
        if(xmax < ((Floor *)[returnBuilding.floors objectAtIndex:i]).extent.xmax) {
            xmax = ((Floor *)[returnBuilding.floors objectAtIndex:i]).extent.xmax;
        }
        if(ymax < ((Floor *)[returnBuilding.floors objectAtIndex:i]).extent.ymax) {
            ymax = ((Floor *)[returnBuilding.floors objectAtIndex:i]).extent.ymax;
        }
    }
    returnBuilding.maxExtent = [[AGSEnvelope alloc] initWithXmin:xmin ymin:ymin xmax:xmax ymax:ymax spatialReference:returnBuilding.spatialReference];
    
    return returnBuilding;
}

#pragma mark getters

-(NSString *)getBatCode {
    NSString *returnBatCode;
    if(self.mapName) {
        NSLog(@"test if substring works ");
        returnBatCode = [self.mapName substringToIndex:1];
    }
    return returnBatCode;
}

-(NSArray *)getFloors {
    return self.floors;
}

-(NSArray *)getFloorsSortedAsc:(BOOL)asc {
    return [self sortFloorArray:self.floors asc:asc];
}

-(NSArray *)getVisibleFloors{
    //capacity can be increased (by adding more objects) is just an indicator
    NSMutableArray *returnFloors = [NSMutableArray arrayWithCapacity:30];
    if(self.floors && self.floors.count > 0) {
        for ( Floor *floor in self.floors) {
            if(floor.isVisible) {
                [returnFloors addObject:floor];
            }
        }
    }
    return returnFloors;
}

-(NSArray *)getVisibleFloorsSortedAsc:(BOOL)asc {
    //capacity can be increased (by adding more objects) is just an indicator
    NSMutableArray *returnFloors = [NSMutableArray arrayWithArray:[self getVisibleFloors]];
    
    return [self sortFloorArray:returnFloors asc:asc];
}

-(NSArray *)sortFloorArray:(NSArray *)unsortedArray asc:(BOOL)asc {
    NSArray *sortedArray = [unsortedArray sortedArrayUsingComparator:^(Floor *a, Floor *b) {
        if(!asc) {
            if([a.floorID intValue] > [b.floorID intValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            } else if([a.floorID intValue] < [b.floorID intValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            } else {
                return (NSComparisonResult)NSOrderedSame;
            }
        } else {
            if([a.floorID intValue] < [b.floorID intValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            } else if([a.floorID intValue] > [b.floorID intValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            } else {
                return (NSComparisonResult)NSOrderedSame;
            }
        }

    }];
    return sortedArray;
}

///returns String array
-(NSArray *)getVisibleFloorIDsSortedAsc:(BOOL)asc {
    //capacity can be increased (by adding more objects) is just an indicator
    NSMutableArray *returnFloorIDs = [NSMutableArray arrayWithCapacity:30];
    for(Floor *floor in [self getVisibleFloorsSortedAsc:asc]) {
        [returnFloorIDs addObject:[floor getStrFloorID]];
    }
    return returnFloorIDs;
}

-(Floor *)getFloorWithFloorCode:(NSString *)floorCode {
    Floor *returnFloor = nil;
    if(self.floors && self.floors.count > 0) {
        int i = 0;
        while(returnFloor == nil && self.floors.count > i) {
            if([((Floor *)self.floors[i]).floorCode isEqualToString:floorCode]) {
                returnFloor = (Floor *)self.floors[i];
            }
            i++;
        }
    }
    return returnFloor;
}

-(Floor *)getFloorWithFloorID:(NSNumber *)floorID {
    Floor *returnFloor = nil;
    if(self.floors && self.floors.count > 0) {
        int i = 0;
        while(returnFloor == nil && self.floors.count > i) {
            if([((Floor *)self.floors[i]).floorID isEqualToNumber:floorID]) {
                returnFloor = (Floor *)self.floors[i];
            }
            i++;
        }
    }
    return returnFloor;
}

/*-(UIImage *)getImage {
    NSString *imageName = [[BuildingImageMapping mappingDict] valueForKey:self.mapName];
    if(imageName){
        return [UIImage imageNamed:imageName];
    } else {
        return nil;
    }
}*/

-(BOOL)isClickedWithPoint:(AGSPoint *)point andSpatialReference:(AGSSpatialReference *)spatialReference {
    BOOL flag = false;
    AGSGeometryEngine *geometryEngine = [AGSGeometryEngine defaultGeometryEngine];
    AGSPoint *projectedPoint = (AGSPoint *)[geometryEngine projectGeometry:point toSpatialReference:[Constants BILUNE_SPATIALREFERENCE]];
    if([geometryEngine geometry:self.maxExtent containsGeometry:projectedPoint]) {
        flag = true;
    }
    return flag;
}


#pragma mark modifiers
-(void)changeVisibleFloorsWithFloorCode:(NSString *)floorCode{
    [self changeVisibleFloorsWithFloorCodes:[NSArray arrayWithObject:floorCode]];
}

-(void)changeVisibleFloorsWithFloorCodes:(NSArray *)floorCodes {
    //get floors to be set visible
    NSMutableArray *newFloors = [NSMutableArray arrayWithCapacity:5];/*capacitiy is just an indicator*/
    for(NSString *floorCode in floorCodes) {
        if([self getFloorWithFloorCode:floorCode]) {
            [newFloors addObject:[self getFloorWithFloorCode:floorCode]];
        }
    }
    
    if(newFloors.count > 0) {
        //get currently visible floors
        NSMutableArray *currentFloors = [NSMutableArray arrayWithArray:[self getVisibleFloorsSortedAsc:true]];
        if(currentFloors.count > 0) {
            for(Floor *floor in currentFloors){
                [floor setVisibility:NO];
            }
        }
        
        //sort newFloors by floorID
        NSLog(@"Test: Folder sorting");
        [newFloors sortUsingComparator:^NSComparisonResult(id a, id b) {
            return[((Floor *)a).floorID compare:((Floor *)b).floorID];
        }];
        
        for(Floor *floor in newFloors) {
            [floor setVisibility:YES];
        }
        
    }
}

-(void)resetFloorVisibility {
    for (Floor *floor in self.floors) {
        [floor resetVisibility];
    }
}

@end
