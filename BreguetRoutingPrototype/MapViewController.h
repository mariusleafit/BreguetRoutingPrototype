//
//  MapViewController.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 03.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "ChangeFloorViewDelegate.h"
#import "GeneralSearchViewDelegate.h"

@interface MapViewController : UIViewController<AGSMapViewTouchDelegate, AGSMapViewLayerDelegate, UISearchBarDelegate, AGSLocationDisplayDataSourceDelegate, ChangeFloorViewDelegate, UIAlertViewDelegate, GeneralSearchViewDelegate>
@property (weak, nonatomic) IBOutlet AGSMapView *map;
- (IBAction)routeClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *routeButton;

- (IBAction)gpsClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *gpsButton;
- (IBAction)choosePoint:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *choosePointButton;
- (IBAction)settingsClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;
- (IBAction)txtStartClick:(id)sender;
- (IBAction)txtEndClick:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtEnd;
@property (weak, nonatomic) IBOutlet UITextField *txtStart;
@end
