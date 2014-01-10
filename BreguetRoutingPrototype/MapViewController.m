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

@interface MapViewController ()
@property (nonatomic) AGSTiledMapServiceLayer *streetBasemap;
@property (nonatomic, weak) AppDelegate *appDelegate;

@property (nonatomic) Building *breguet;

@property (nonatomic) DeviceLocationMarkingLayer *deviceLocationLayer;
@property (nonatomic) AGSCLLocationManagerLocationDisplayDataSource *gpsDataSource;

@property (nonatomic) FloorMarkingLayer *floorMarkingLayer;
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
    
    //add locationmarkerlayer
    self.deviceLocationLayer = [[DeviceLocationMarkingLayer alloc] init];
    [self.map addMapLayer:self.deviceLocationLayer withName:@"deviceLocationMarkingLayer"];
    
    
    //zoom to Breguet
    //project polygon
    AGSEnvelope *projectedPolygon = (AGSEnvelope *)[[AGSGeometryEngine defaultGeometryEngine] projectGeometry:self.breguet.extent toSpatialReference:[Constants BASEMAP_SPATIALREFERENCE]];
    
    //set initial Extent
    [self.map zoomToEnvelope:projectedPolygon animated:NO];
}

#pragma mark AGSMapViewTouchDelegate
-(void)mapView:(AGSMapView *)mapView didTapAndHoldAtPoint:(CGPoint)screen mapPoint:(AGSPoint *)mappoint graphics:(NSDictionary *)graphics {
    [self.deviceLocationLayer setLocation:mappoint isGPS:YES];
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

//
int gpsCounter;

-(void)locationDisplayDataSource:(id<AGSLocationDisplayDataSource>)dataSource didUpdateWithLocation:(AGSLocation *)location {
    //white a while to let the device find his correct position
    if(gpsCounter == 5) {
        
        //**mark Building
        Floor *currentFloor = [[self.breguet getVisibleFloors] objectAtIndex:0];
        AGSFeatureLayer *breguetLayer = (AGSFeatureLayer *)[self.map mapLayerForName:[[currentFloor getFloorURL] absoluteString]];
        
        self.floorMarkingLayer = [[FloorMarkingLayer alloc] initWithFeatureLayer:breguetLayer];
        [self.map addMapLayer:self.floorMarkingLayer withName:@"floorMarkingLayer"];
        [self.gpsDataSource stop];
    } else {
        //project point
        AGSPoint *projectedLocation = (AGSPoint *)[[AGSGeometryEngine defaultGeometryEngine] projectGeometry:location.point toSpatialReference:[Constants BASEMAP_SPATIALREFERENCE]];
        [self.deviceLocationLayer setLocation:projectedLocation isGPS:YES];
        
        AGSGeometryEngine *geometryEngine = [AGSGeometryEngine defaultGeometryEngine];
        AGSPolygon *circle = [geometryEngine bufferGeometry:projectedLocation byDistance:location.accuracy];
        
        
        
        AGSGraphicsLayer *test = [[AGSGraphicsLayer alloc] init];
        
        AGSGraphic *circleGraphic = [AGSGraphic graphicWithGeometry:circle symbol:[AGSSimpleFillSymbol simpleFillSymbolWithColor:nil outlineColor:[UIColor blackColor]] attributes:nil infoTemplateDelegate:nil];
        
        [test addGraphic:circleGraphic];
        [self.map addMapLayer:test];
        
        
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

#pragma mark IBAction

- (IBAction)routeClick:(id)sender {
}
- (IBAction)gpsClick:(id)sender {
    [self.gpsDataSource start];
   //self.map.locationDisplay.mapLocation = [[AGSPoint alloc] initWithX:<#(double)#> y:<#(double)#> spatialReference:<#(AGSSpatialReference *)#>]
    /*if(self.map.locationDisplay.dataSourceStarted){
        [self.map.locationDisplay stopDataSource];
        self.map.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
        self.gpsButton.tintColor = [UIColor whiteColor];
    } else {
        
        
        [self.map.locationDisplay startDataSource];
        self.map.locationDisplay.autoPanMode = AGSLocationDisplayAutoPanModeDefault;
        self.gpsButton.tintColor = [UIColor greenColor];
        
    }*/
}
- (IBAction)choosePoint:(id)sender {
    [self.map.locationDisplay stopDataSource];
    if(self.map.locationDisplay.mapLocation) {
        
    }
    
}
- (IBAction)settingsClick:(id)sender {
}
@end
