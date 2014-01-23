//
//  GetRouteBetweenRooms.m
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 23.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import "RouteBetweenRooms.h"

#import "RouteBetweenRoomsDelegate.h"
#import "Constants.h"
#import "Room.h"
#import "AGSRoomLocator.h"

@interface RouteBetweenRooms()
@property (nonatomic) NSMutableArray *geocoders;
@property (nonatomic) NSArray *rooms;
@property(nonatomic) NSMutableArray *points;
@property (nonatomic) id<RouteBetweenRoomsDelegate> delegate;

@property (nonatomic) NSOperation *routingOperation;
@property (nonatomic) AGSRouteTask *routingTask;
@end

@implementation RouteBetweenRooms

-(id)initWithRooms:(NSArray *)rooms delegate:(id<RouteBetweenRoomsDelegate>)delegate {
    self = [super init];
    if(self) {
        self.rooms = rooms;
        self.delegate = delegate;
        
        self.points = [[NSMutableArray alloc] initWithCapacity:rooms.count];
        self.geocoders = [[NSMutableArray alloc] initWithCapacity:rooms.count];
        for(int i = 0; i < self.rooms.count; i++) {
            [self.points addObject:[[NSObject alloc] init]];
            [self.geocoders addObject:[[NSObject alloc] init]];
        }
    }
    return self;
}

-(void)execute {
    //get point for rooms using geocoding
    int i = 0;
    for (Room *room in self.rooms) {
        //create geocoder & execute
        AGSRoomLocator *geocoder = [[AGSRoomLocator alloc] initWithURL:[self getGeoCodingUrlForRoom:room] room:room delegate:self];
        [geocoder execute];
        
        //cache geocoder so that it doesn't get destroyed
        [self.geocoders setObject:geocoder atIndexedSubscript:i];
        i++;
    }
    
}

#pragma mark helper methods
-(NSURL *)getGeoCodingUrlForRoom:(Room *)room {
    if([room.parentFloor.floorCode isEqualToString:@"SS"]) {
        return [NSURL URLWithString:BREGUET_SS_GEOCODEURL];
    }
    else if([room.parentFloor.floorCode isEqualToString:@"R"]) {
        return [NSURL URLWithString:BREGUET_R_GEOCODEURL];
    }
    else if([room.parentFloor.floorCode isEqualToString:@"E1"]) {
        return [NSURL URLWithString:BREGUET_E1_GEOCODEURL];
    }
    else if([room.parentFloor.floorCode isEqualToString:@"E2"]) {
        return [NSURL URLWithString:BREGUET_E2_GEOCODEURL];
    }
    else if([room.parentFloor.floorCode isEqualToString:@"E3"]) {
        return [NSURL URLWithString:BREGUET_E3_GEOCODEURL];
    }
    
    return [NSURL URLWithString:@""];
}

-(void)starteRouting {
    //create stopGraphics array
    NSMutableArray *stops = [NSMutableArray arrayWithCapacity:self.rooms.count];
    for (AGSPoint *point in self.points) {
        AGSStopGraphic *graphicToAdd = [AGSStopGraphic graphicWithGeometry:point symbol:nil attributes:nil infoTemplateDelegate:nil];
        [stops addObject:graphicToAdd];
    }
    
    //initialize RoutingParams
    AGSRouteTaskParameters *routingTaskParams = [[AGSRouteTaskParameters alloc] init];
    [routingTaskParams setStopsWithFeatures:stops];
    
    
    // this generalizes the route graphics that are returned
    routingTaskParams.outputGeometryPrecision = 5.0;
    routingTaskParams.outputGeometryPrecisionUnits = AGSUnitsMeters;
    
    // return the graphic representing the entire route, generalized by the previous
    // 2 properties: outputGeometryPrecision and outputGeometryPrecisionUnits
    routingTaskParams.returnRouteGraphics = YES;
    
    // this returns turn-by-turn directions
    routingTaskParams.returnDirections = YES;
    routingTaskParams.directionsLanguage = @"en-US";
    routingTaskParams.directionsLengthUnits = AGSNAUnitMeters;
    
    //initialize RoutingTask
    self.routingTask = [AGSRouteTask routeTaskWithURL:[NSURL URLWithString:BREGUET_ROUTINGURL]];
    self.routingTask.delegate = self;
    
    //start request
    self.routingOperation = [self.routingTask solveWithParameters:routingTaskParams];
    //[self.routingOperation start];
}

-(bool)allPointsDetermined {
    for(int i = 0; i < self.points.count; i++) {
        if(!([[self.points objectAtIndex:i] isKindOfClass:[AGSPoint class]])) {
            return false;
        }
    }
    return true;
}

#pragma mark AGSLocatorDelegate
-(void)locator:(AGSLocator *)locator operation:(NSOperation *)op didFindLocationsForAddress:(NSArray *)candidates {
    Room *room = ((AGSRoomLocator *)locator).room;
    int roomArrayID = -1;
    //get array-key of room
    for (int i = 0; i < self.rooms.count; i++) {
        if([((Room*)[self.rooms objectAtIndex:i]).name isEqualToString:room.name]) {
            roomArrayID = i;
        }
    }
    
    //add point of room to the points array
    if(roomArrayID != -1) {
        if(candidates.count > 0) {
            AGSAddressCandidate *candidate = (AGSAddressCandidate *)[candidates objectAtIndex:0];
            [self.points setObject:candidate.location atIndexedSubscript:roomArrayID];
        }
    }
    
    //if all points could be determined the routeTask can be started
    if([self allPointsDetermined]) {
        [self starteRouting];
    }
}

-(void)locator:(AGSLocator *)locator operation:(NSOperation *)op didFailLocationsForAddress:(NSError *)error {
    //call delegate
    [self.delegate routeBetweenRooms:self errorOccured:error];
}

#pragma mark AGSRouteTaskDelegate
-(void)routeTask:(AGSRouteTask *)routeTask operation:(NSOperation *)op didSolveWithResult:(AGSRouteTaskResult *)routeTaskResult {
    // we know that we are only dealing with 1 route...
	AGSRouteResult *routeResult = [routeTaskResult.routeResults lastObject];
	if (routeResult) {
        [self.delegate routeBetweenRooms:self gotResult:routeResult];
	}
}

-(void)routeTask:(AGSRouteTask *)routeTask operation:(NSOperation *)op didFailSolveWithError:(NSError *)error {
    [self.delegate routeBetweenRooms:self errorOccured:error];
}

/*
-(void)routeTask:(AGSRouteTask *)routeTask operation:(NSOperation *)op didRetrieveDefaultRouteTaskParameters:(AGSRouteTaskParameters *)routeParams {
    
}

-(void)routeTask:(AGSRouteTask *)routeTask operation:(NSOperation *)op didFailToRetrieveDefaultRouteTaskParametersWithError:(NSError *)error{
    [self.delegate routeBetweenRooms:self errorOccured:error];
}*/
@end
