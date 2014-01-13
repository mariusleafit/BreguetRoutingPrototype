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
#import "DestinationViewController.h"
#import "DeviceLocationMarkingLayer.h"
#import "FloorMarkingLayer.h"
#import "ClosestRoomHelper.h"
#import "ChangeFloorViewController.h"

#define DLG_CURRENT_FLOOR 1
#define DLG_ROOM 2
#define DLG_LOAD_POSITION 3

#define IDENTIFY_ROOM @"identifyRoom"
#define NORMAL_FLOOR_CHANGE @"normal"

@interface MapViewController ()
@property (nonatomic) AGSTiledMapServiceLayer *streetBasemap;
@property (nonatomic, weak) AppDelegate *appDelegate;

@property (nonatomic) Building *breguet;

@property (nonatomic) DeviceLocationMarkingLayer *deviceLocationLayer;
@property (nonatomic) AGSCLLocationManagerLocationDisplayDataSource *gpsDataSource;

@property (nonatomic) FloorMarkingLayer *floorMarkingLayer;


@property (nonatomic) AGSGraphicsLayer *currentRoomMarkingLayer;
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
    
    //init gps
    self.gpsDataSource = [[AGSCLLocationManagerLocationDisplayDataSource alloc] init];
    self.gpsDataSource.delegate = self;
    
    //nitialize gui components
    self.searchBar.delegate = self;
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark ChangeFloorViewDelegate
//gets called when user changed the visible floors
-(void)changeFloorView:(ChangeFloorViewController *)viewController visibleFloorsDidChange:(NSArray *)visibleFloors {
    
    //if floor changed to get the current room
    if([viewController.identifier isEqualToString:IDENTIFY_ROOM]) {
        //change floors on map
        //is at least one floor visible?
        if([visibleFloors count] > 0) {
            [self.breguet changeVisibleFloorsWithFloorCode:[visibleFloors objectAtIndex:0]];
        } else {
            //set visibility back to default
            [self.breguet resetFloorVisibility];
        }
        [self updateVisibleFloorsOfBuilding:self.breguet];
        
        //start gps to try to get the current room
        [self.gpsDataSource start];
    } else if([viewController.identifier isEqualToString:NORMAL_FLOOR_CHANGE]) {
        //change floors on map
        
        //is at least one floor visible?
        if([visibleFloors count] > 0) {
            [self.breguet changeVisibleFloorsWithFloors:visibleFloors];
        } else {
            //set visibility back to default
            [self.breguet resetFloorVisibility];
        }
        [self updateVisibleFloorsOfBuilding:self.breguet];
    }
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
        //show changeFloorView
        ChangeFloorViewController *changeFloorView = [[ChangeFloorViewController alloc] initWithNibName:@"ChangeFloor" bundle:nil Identifier:NORMAL_FLOOR_CHANGE Building:clickedBuilding delegate:self];
        [self.navigationController pushViewController:changeFloorView animated:YES];
    }
}

-(void)mapView:(AGSMapView *)mapView didClickAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics {
#pragma mark todo
    AGSGraphic *clickedRoom = [[[graphics allValues]objectAtIndex:0] objectAtIndex:0];
    if(clickedRoom) {
        //mark Room
        if(self.currentRoomMarkingLayer) {
            [self.map removeMapLayer:self.currentRoomMarkingLayer];
        }
        
        self.currentRoomMarkingLayer = [[AGSGraphicsLayer alloc] init];
        [self.map addMapLayer:self.currentRoomMarkingLayer];
        [self.currentRoomMarkingLayer addGraphic:[AGSGraphic graphicWithGeometry:clickedRoom.geometry symbol:[AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor redColor] outlineColor:nil] attributes:nil infoTemplateDelegate:nil]];
    }
    
}

#pragma mark UISearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
    //show select destination view
    UIStoryboard *destinationStoryboard = [UIStoryboard storyboardWithName:@"destination" bundle:nil];
    DestinationViewController  *destinationViewController = [destinationStoryboard instantiateViewControllerWithIdentifier:@"destination"];
    [self.appDelegate.navigationController pushViewController:destinationViewController animated:YES];
}

#pragma mark AGSLocationDisplayDataSourceDelegate

int gpsCounter;
UIAlertView *gpsAlertView;
-(void)locationDisplayDataSource:(id<AGSLocationDisplayDataSource>)dataSource didUpdateWithLocation:(AGSLocation *)location {
    //wait a while to let the device find his correct position
    if(gpsCounter == 5) {
        
        //**mark Building
        Floor *currentFloor = [[self.breguet getVisibleFloors] objectAtIndex:0];
        AGSFeatureLayer *breguetLayer = (AGSFeatureLayer *)[self.map mapLayerForName:[[currentFloor getFloorURL] absoluteString]];
        
        /*self.floorMarkingLayer = [[FloorMarkingLayer alloc] initWithFeatureLayer:breguetLayer];
         [self.map addMapLayer:self.floorMarkingLayer withName:@"floorMarkingLayer"];*/
        
        AGSGraphic *closestRoom = [ClosestRoomHelper getClosestRoom:location.point inCircle:self.deviceLocationLayer.accuracyCircle onFeatureLayer:breguetLayer];
        
        if(closestRoom) {
            //mark closes Room
            if(self.currentRoomMarkingLayer) {
                [self.map removeMapLayer:self.currentRoomMarkingLayer];
            }
            
            self.currentRoomMarkingLayer = [[AGSGraphicsLayer alloc] init];
            [self.map addMapLayer:self.currentRoomMarkingLayer];
            [self.currentRoomMarkingLayer addGraphic:[AGSGraphic graphicWithGeometry:closestRoom.geometry symbol:[AGSSimpleFillSymbol simpleFillSymbolWithColor:[UIColor redColor] outlineColor:nil] attributes:nil infoTemplateDelegate:nil]];
            
            //get roomName
            NSString *closestRoomName = [closestRoom attributeAsStringForKey:@"LOC_CODE"];
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Étage" message:[NSString stringWithFormat:@"Vous-êtez dans le local '%@'?.",closestRoomName] delegate:self cancelButtonTitle:@"Non" otherButtonTitles:@"Oui",nil];
            alertView.tag = DLG_ROOM;
            [alertView show];
        }
        
        [self.gpsDataSource stop];
        [gpsAlertView dismissWithClickedButtonIndex:0 animated:TRUE];
    } else {
        //show loading dialog
        if(gpsCounter == 0) {
            gpsAlertView = [[UIAlertView alloc] initWithTitle:@"Chercher la position..." message:@""
                                                     delegate:self
                                            cancelButtonTitle:@"Annuler"
                                            otherButtonTitles:nil];
            gpsAlertView.tag = DLG_LOAD_POSITION;
            [gpsAlertView show];
        }
        //project point
        [self.deviceLocationLayer setGPSLocation:location withSpatialReference:[Constants BASEMAP_SPATIALREFERENCE]];
    }
    gpsCounter++;
}

-(void)locationDisplayDataSource:(id<AGSLocationDisplayDataSource>)dataSource didFailWithError:(NSError *)error {
    
}

-(void)locationDisplayDataSource:(id<AGSLocationDisplayDataSource>)dataSource didUpdateWithHeading:(double)heading {
    
}

-(void)locationDisplayDataSourceStarted:(id<AGSLocationDisplayDataSource>)dataSource {
    gpsCounter = 0;
}

-(void)locationDisplayDataSourceStopped:(id<AGSLocationDisplayDataSource>)dataSource {
    //[self.map removeMapLayerWithName:@"floorMarkingLayer"];
}

#pragma mark UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    ChangeFloorViewController *changeFloorView;
    UIAlertView *localAlertView;
    switch(alertView.tag) {
        case DLG_CURRENT_FLOOR:
            switch(buttonIndex) {
                case 0://NON
                    //show changeFloorView
                    changeFloorView = [[ChangeFloorViewController alloc] initWithNibName:@"ChangeFloor" bundle:nil Identifier:IDENTIFY_ROOM Building:self.breguet delegate:self];
                    [self.navigationController pushViewController:changeFloorView animated:YES];
                    break;
                case 1://OUI
                    [self.gpsDataSource start];
                    break;
            }
            break;
        case DLG_ROOM:
            switch(buttonIndex) {
                case 0:
                     localAlertView = [[UIAlertView alloc] initWithTitle:@"Local" message:[NSString stringWithFormat:@"Choisisez le local à la main."] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [localAlertView show];
                    [self.deviceLocationLayer clear];
                    break;
            }
            break;
        case DLG_LOAD_POSITION:
            [self.gpsDataSource stop];
            [self.deviceLocationLayer clear];
            break;
    }
}

#pragma mark IBAction

- (IBAction)routeClick:(id)sender {
}
- (IBAction)gpsClick:(id)sender {
    //add deviceposition layer
    if(self.deviceLocationLayer) {
        [self.map removeMapLayer:self.deviceLocationLayer];
    }
    //add locationmarkerlayer
    self.deviceLocationLayer = [[DeviceLocationMarkingLayer alloc] init];
    [self.map addMapLayer:self.deviceLocationLayer withName:@"deviceLocationMarkingLayer"];
    
    //remove gps & room marker
    [self.currentRoomMarkingLayer removeAllGraphics];
    [self.deviceLocationLayer clear];
    
    
    //get currently visible floor
    Floor *currentFloor = [[self.breguet getVisibleFloors] objectAtIndex:0];
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Étage" message:[NSString stringWithFormat:@"Vous-êtez sur l'étage '%@'?.",currentFloor.floorName] delegate:self cancelButtonTitle:@"Non" otherButtonTitles:@"Oui",nil];
    alertView.tag = DLG_CURRENT_FLOOR;
    [alertView show];
}
- (IBAction)choosePoint:(id)sender {
    [self.map.locationDisplay stopDataSource];
    if(self.map.locationDisplay.mapLocation) {
        
    }
    
}
- (IBAction)settingsClick:(id)sender {
}
@end
