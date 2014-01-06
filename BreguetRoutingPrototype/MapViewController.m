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

@interface MapViewController ()
@property (nonatomic) AGSTiledMapServiceLayer *streetBasemap;
@property (nonatomic, weak) AppDelegate *appDelegate;

@property (nonatomic) Building *breguet;
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


#pragma mark UISearchBarDelegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
}

#pragma mark IBAction

- (IBAction)routeClick:(id)sender {
}
- (IBAction)gpsClick:(id)sender {
}
- (IBAction)choosePoint:(id)sender {
}
- (IBAction)settingsClick:(id)sender {
}
@end
