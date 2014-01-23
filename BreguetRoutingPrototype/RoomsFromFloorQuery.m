//
//  RoomsFormFloorQuery.m
//  BiluneGeoMobile
//
//  Created by Marius Gächter on 06.08.13.
//  Copyright (c) 2013 leafit. All rights reserved.
//

#import "RoomsFromFloorQuery.h"
#import "Room.h"

@interface RoomsFromFloorQuery() {
    NSString *queryName;
    id<MultipleRoomsQueryDelegate> queryDelegate;
    AGSQueryTask *queryTask;
    AGSQuery *query;
    Floor *queryFloor;
}

@end

@implementation RoomsFromFloorQuery

-(id)initWithFloor:(Floor *)floor andName:(NSString *)name andDelegate:(id<MultipleRoomsQueryDelegate>)delegate{
    self = [super init];
    if(self) {
        queryName = name;
        queryDelegate = delegate;
        queryFloor = floor;
        
        queryTask = [AGSQueryTask queryTaskWithURL:[floor getFloorURL]];
        queryTask.delegate = self;
        
        
        query = [AGSQuery query];
        query.outFields = [NSArray arrayWithObjects:@"*", nil];
        query.where = @"OBJECTID>-1";
        query.returnGeometry = true;
    }
    return self;

}

-(void)execute {
    [queryTask executeWithQuery:query];
}

#pragma mark AGSQueryTaskDelegate
//results are returned
- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didExecuteWithFeatureSetResult:(AGSFeatureSet *)featureSet {
	//get Room from featureSet
    NSMutableArray *foundRooms = [NSMutableArray arrayWithCapacity:40];
    if([featureSet.features count] > 0) {
        for (int i = 0; i < [featureSet.features count]; i++) {
            NSString *locCode = [(AGSGraphic *)(featureSet.features[i]) attributeAsStringForKey:@"LOC_CODE"];
            NSString *locOccupants = [(AGSGraphic *)(featureSet.features[i]) attributeAsStringForKey:@"LOC_OCCUPANTS"];
            NSString *batAddress = [(AGSGraphic *)(featureSet.features[i]) attributeAsStringForKey:@"BAT_ADRESSE"];
            NSString *locType = [(AGSGraphic *)(featureSet.features[i]) attributeAsStringForKey:@"LOC_TYPE_DESIGNATION"];
            NSString *locArea = [(AGSGraphic *)(featureSet.features[i]) attributeAsStringForKey:@"SHAPE_Area"];
            AGSPolygon *roomPolygon = (AGSPolygon *)(((AGSGraphic *)(featureSet.features[i])).geometry);
                    
            Room *tmpRoom = [Room createWithName:locCode andOccupants:locOccupants andPolygon:roomPolygon andParentFloor:queryFloor andParentBuilding:queryFloor.parentBuilding andAddress:batAddress andType:locType andArea:locArea];
            if(tmpRoom) {
                [foundRooms addObject:tmpRoom];
            }
        }
    }
    
    //order rooms
    NSArray *orderedRoom = [foundRooms sortedArrayUsingComparator:^(Room *a, Room *b) {
        NSString *roomA = [a.name stringByReplacingOccurrencesOfString:@"(" withString:@""];
        NSString *roomB = [b.name stringByReplacingOccurrencesOfString:@"(" withString:@""];
        
        return[roomA compare:roomB options:NSNumericSearch];
    }];
    
    [queryDelegate roomQueryRoomsFound:[NSArray arrayWithArray:orderedRoom] andQueryName:queryName];
}




//error occured
- (void)queryTask:(AGSQueryTask *)queryTask operation:(NSOperation *)op didFailWithError:(NSError *)error {
    [queryDelegate roomQueryErrorOccured:queryName];
}
@end
