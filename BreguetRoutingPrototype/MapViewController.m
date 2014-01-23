//
//  MapViewController.m
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 03.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import "MapViewController.h"
#import "Constants.h"
#import "AppDelegate.h"
#import "DeviceLocationMarkingLayer.h"
#import "FloorMarkingLayer.h"
#import "ClosestRoomHelper.h"
#import "GeneralSearchViewController.h"
#import "BasicListSelectorViewController.h"
#import "RoomsFromFloorQuery.h"
#import "RouteBetweenRooms.h"

#define DLG_CURRENT_FLOOR 1
#define DLG_ROOM 2
#define DLG_LOAD_POSITION 3

#define LIST_CHANGEFLOOR @"changefloor"

#define IDENTIFY_ROOM @"identifyRoom"
#define NORMAL_FLOOR_CHANGE @"normal"

#define FLOORSSTART @"floorsstart"
#define FLOORSEND @"floorsend"

#define SEARCHSTARTROOM 2
#define SEARCHENDROOM 1

@interface MapViewController ()
@property (nonatomic) AGSTiledMapServiceLayer *streetBasemap;
@property (nonatomic, weak) AppDelegate *appDelegate;

@property (nonatomic) Building *breguet;

@property (nonatomic) DeviceLocationMarkingLayer *deviceLocationLayer;
@property (nonatomic) AGSCLLocationManagerLocationDisplayDataSource *gpsDataSource;

@property (nonatomic) FloorMarkingLayer *floorMarkingLayer;


@property (nonatomic) AGSGraphicsLayer *currentRoomMarkingLayer;

@property (nonatomic) RoomsFromFloorQuery *roomsQuery;

@property (nonatomic) Room *startRoom;
@property (nonatomic) Room *endRoom;

@property (nonatomic) RouteBetweenRooms *routeBetweenRooms;
@property (nonatomic) UIAlertView *routingWaitDialog;

@property (nonatomic) AGSGraphicsLayer *routeGraphicsLayer;
@property (nonatomic) AGSGraphicsLayer *roomGraphicsLayer;

@property (nonatomic) NSMutableArray *routeInstructions;
@end




@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.appDelegate = GetAppDelegate();
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.breguet = (Building *)[[self.appDelegate.buildingStack getBuildings] objectAtIndex:0];
    
    //initialize map
    self.streetBasemap = [[AGSTiledMapServiceLayer alloc] initWithURL:[NSURL URLWithString:STREETBASEMAPURL]];
    [self.map addMapLayer:self.streetBasemap];
    
    self.map.layerDelegate = self;
    self.map.touchDelegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark helper methods
-(AGSSimpleFillSymbol *)roomMarkingSymbol:(bool)start {
    UIColor *lineColor = [UIColor blueColor];
    if(!start) {
        lineColor = [UIColor greenColor];
    }
    AGSSimpleFillSymbol *roomMarkingSymbol = [AGSSimpleFillSymbol simpleFillSymbolWithColor:nil outlineColor:lineColor];
    roomMarkingSymbol.outline.width = 3;
    return roomMarkingSymbol;
}

-(void)markStartAndEndRoom {
    //reset room graphics layer
    if(self.roomGraphicsLayer) {
        [self.map removeMapLayer:self.roomGraphicsLayer];
    }
    self.roomGraphicsLayer = [[AGSGraphicsLayer alloc] init];
    [self.map addMapLayer:self.roomGraphicsLayer];
    
    if(self.startRoom) {
        AGSPolygon* geometry = (AGSPolygon *)[[AGSGeometryEngine defaultGeometryEngine]projectGeometry:self.startRoom.polygon toSpatialReference:[Constants BASEMAP_SPATIALREFERENCE]];
        
        AGSGraphic *roomMarker = [AGSGraphic graphicWithGeometry:geometry symbol:[self roomMarkingSymbol:true] attributes:nil infoTemplateDelegate:nil];
        
        [self.roomGraphicsLayer addGraphic:roomMarker];
    }
    if(self.endRoom) {
        AGSPolygon* geometry = (AGSPolygon *)[[AGSGeometryEngine defaultGeometryEngine]projectGeometry:self.endRoom.polygon toSpatialReference:[Constants BASEMAP_SPATIALREFERENCE]];
        
        AGSGraphic *roomMarker = [AGSGraphic graphicWithGeometry:geometry symbol:[self roomMarkingSymbol:false] attributes:nil infoTemplateDelegate:nil];
        
        [self.roomGraphicsLayer addGraphic:roomMarker];
    }
}

#pragma mark AGSMapViewLayerDelegate

-(void)mapViewDidLoad:(AGSMapView *)mapView {
    //Breguet hinzufügen
    for (Floor *floor in [self.breguet getVisibleFloorsSortedAsc:NO]) {
        [self.map addMapLayer:[[AGSFeatureLayer alloc] initWithURL:[floor getFloorURL] mode:AGSFeatureLayerModeSnapshot] withName:[ [floor getFloorURL] absoluteString]];
    }
        
    //zoom to Breguet
    //project polygon
    AGSEnvelope *projectedPolygon = (AGSEnvelope *)[[AGSGeometryEngine defaultGeometryEngine] projectGeometry:self.breguet.extent toSpatialReference:[Constants BASEMAP_SPATIALREFERENCE]];
    
    //set initial Extent
    [self.map zoomToEnvelope:projectedPolygon animated:NO];
}

#pragma mark BasicListSelectorDelegate


-(void)BasicList:(NSString *)identifier selectionChanged:(id<BasicListSelectorItem>)selection {
    //change visible floor
    [self.breguet changeVisibleFloorsWithFloors:[NSArray arrayWithObject:selection]];
    [self updateVisibleFloorsOfBuilding:self.breguet];
    
    //resetz of txtStart & txtEnd
    self.txtStart.text = @"";
    self.txtEnd.text = @"";
    [self.routeGraphicsLayer removeAllGraphics];
}

#pragma mark ChangeEtageManagement
-(void) updateVisibleFloorsOfBuilding:(Building *)building {
    //delete every Floor of Building
    for(Floor *floor in [building getFloors]) {
        [self.map removeMapLayerWithName:[[floor getFloorURL] absoluteString]];
    }
    
    //show visible Floors
    for(Floor *floor in [building getVisibleFloorsSortedAsc:YES]) {
        
        AGSFeatureLayer *tmpFeatureLayer = [[AGSFeatureLayer alloc] initWithURL:[floor getFloorURL] mode:AGSFeatureLayerModeSnapshot];
        [self.map addMapLayer:tmpFeatureLayer withName:[ [floor getFloorURL] absoluteString]];
    }
}

#pragma mark AGSMapViewTouchDelegate
-(void)mapView:(AGSMapView *)mapView didTapAndHoldAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics {
    //open changeFloorView if tap on building
    Building *clickedBuilding = [self.appDelegate.buildingStack getBuildingWithPoint:mappoint andSpatialReference:[Constants BASEMAP_SPATIALREFERENCE]];
    if(clickedBuilding) {
        
        Floor *currentFloor = [[clickedBuilding getVisibleFloors] objectAtIndex:0];
        
        BasicListSelectorViewController *listController = [[BasicListSelectorViewController alloc] initWithIdentifier:LIST_CHANGEFLOOR data:[clickedBuilding getFloors] selectedItem:currentFloor  delegate:self cellStyle:UITableViewCellStyleDefault];
        [self.navigationController pushViewController:listController animated:YES];
    }
}

-(void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics {

    
}


#pragma mark MultipleRoomsQueryDelegate
-(void)roomQueryRoomsFound:(NSArray *)rooms andQueryName:(NSString *)queryName {
    if([queryName isEqualToString:FLOORSSTART]) {
        GeneralSearchViewController *searchView = [[GeneralSearchViewController alloc] initWith:rooms cellStyle:UITableViewCellStyleSubtitle delegate:self];
        searchView.identifier = SEARCHSTARTROOM;
        [self.navigationController pushViewController:searchView animated:YES];
    } else if([queryName isEqualToString:FLOORSEND]) {
        GeneralSearchViewController *searchView = [[GeneralSearchViewController alloc] initWith:rooms cellStyle:UITableViewCellStyleSubtitle delegate:self];
        searchView.identifier = SEARCHENDROOM;
        [self.navigationController pushViewController:searchView animated:YES];
    }
}

-(void)roomQueryErrorOccured:(NSString *)queryName {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Impossible de charger les locaux" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

#pragma mark GeneralSearchViewDelegate


-(void)generalSearchView:(GeneralSearchViewController *)viewController itemSelected:(id<GeneralSearchViewItem>)selection {
    bool start = true;
    
    if(viewController.identifier == SEARCHSTARTROOM) {
        self.txtStart.text = [selection title];
        self.startRoom = selection;
    } else if(viewController.identifier == SEARCHENDROOM) {
        self.txtEnd.text = [selection title];
        self.endRoom = selection;
        start = false;
    }
    
    //mark room
    [self markStartAndEndRoom];
}

#pragma mark RouteBetweenRoomsDelegate
- (AGSSimpleLineSymbol*)routeSymbol {
	
	AGSSimpleLineSymbol *sls1 = [AGSSimpleLineSymbol simpleLineSymbol];
	sls1.color = [UIColor redColor];
	sls1.style = AGSSimpleLineSymbolStyleSolid;
	sls1.width = 2;
	
	
	return sls1;
}

-(void)routeBetweenRooms:(RouteBetweenRooms *)route errorOccured:(NSError *)error {
    if(self.routingWaitDialog) {
        [self.routingWaitDialog dismissWithClickedButtonIndex:0 animated:YES];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Impossible à calculer la route" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)routeBetweenRooms:(RouteBetweenRooms *)route gotResult:(AGSRouteResult *)result {
    if(result) {
        AGSPolyline *pl = (AGSPolyline *)[[AGSGeometryEngine defaultGeometryEngine]projectGeometry:result.routeGraphic.geometry toSpatialReference:[Constants BASEMAP_SPATIALREFERENCE]];
        
        AGSGraphic *line = [AGSGraphic graphicWithGeometry:pl symbol:[self routeSymbol] attributes:nil infoTemplateDelegate:nil];
        
        // add the route graphic to the graphic's layer
		if(self.routeGraphicsLayer) {
            [self.map removeMapLayer:self.routeGraphicsLayer];
        }
        self.routeGraphicsLayer = [[AGSGraphicsLayer alloc] init];
        [self.map addMapLayer:self.routeGraphicsLayer];
        [self.routeGraphicsLayer addGraphic:line];
        
        //save routing instructions
        self.routeInstructions = [[NSMutableArray alloc] init];
        if(result.directions != nil) {
            for (AGSDirectionGraphic *graphic in result.directions.graphics ) {
                [self.routeInstructions addObject:[graphic attributeAsStringForKey:@"text"]];
            }
        }
        
        //dismiss waiting dialog
        if(self.routingWaitDialog) {
            [self.routingWaitDialog dismissWithClickedButtonIndex:0 animated:YES];
        }
    }
}

#pragma mark IBAction

- (IBAction)routeClick:(id)sender {
    if(self.startRoom && self.endRoom) {
        //show waiting dialog
        self.routingWaitDialog = [[UIAlertView alloc] initWithTitle:@"Charger..." message:nil delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
        [self.routingWaitDialog show];
        
        self.routeBetweenRooms = [[RouteBetweenRooms alloc] initWithRooms:[NSArray arrayWithObjects:self.startRoom,self.endRoom, nil] delegate:self];
        [self.routeBetweenRooms execute];
    } else {
        
    }
}


- (IBAction)txtStartClick:(id)sender {
    [self.view endEditing:YES];
    
    //get rooms of current floor
    Floor *currentFloor = [[self.breguet getVisibleFloors] objectAtIndex:0];
    self.roomsQuery = [[RoomsFromFloorQuery alloc] initWithFloor:currentFloor andName:FLOORSSTART andDelegate:self];
    
    [self.roomsQuery execute];
}

- (IBAction)txtEndClick:(id)sender {
    [self.view endEditing:YES];
    
    //get rooms of current floor
    Floor *currentFloor = [[self.breguet getVisibleFloors] objectAtIndex:0];
    self.roomsQuery = [[RoomsFromFloorQuery alloc] initWithFloor:currentFloor andName:FLOORSEND andDelegate:self];
    
    [self.roomsQuery execute];
}

- (IBAction)showRoute:(id)sender {
    if(self.routeInstructions.count > 0) {
        BasicListSelectorViewController *basicList = [[BasicListSelectorViewController alloc] initWithIdentifier:@"" data:self.routeInstructions selectedItem:nil delegate:nil cellStyle:UITableViewCellStyleDefault];
        [self.navigationController pushViewController:basicList animated:YES];
    }
}
@end
