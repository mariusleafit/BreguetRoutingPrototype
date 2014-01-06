//
//  MapViewController.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 03.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>

@interface MapViewController : UIViewController<AGSMapViewTouchDelegate, AGSMapViewLayerDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet AGSMapView *map;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
- (IBAction)routeClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *routeButton;

- (IBAction)gpsClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *gpsButton;
- (IBAction)choosePoint:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *choosePointButton;
- (IBAction)settingsClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
@end
