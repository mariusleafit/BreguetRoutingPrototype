//
//  MapViewController.h
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 03.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import "BasicListSelectorDelegate.h"
#import "GeneralSearchViewDelegate.h"
#import "MultipleRoomsQueryDelegate.h"
#import "RouteBetweenRoomsDelegate.h"

@interface MapViewController : UIViewController<AGSMapViewTouchDelegate, AGSMapViewLayerDelegate, BasicListSelectorDelegate,GeneralSearchViewDelegate, MultipleRoomsQueryDelegate, RouteBetweenRoomsDelegate>
@property (weak, nonatomic) IBOutlet AGSMapView *map;
- (IBAction)routeClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *routeButton;


- (IBAction)txtStartClick:(id)sender;
- (IBAction)txtEndClick:(id)sender;
- (IBAction)showRoute:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txtEnd;
@property (weak, nonatomic) IBOutlet UITextField *txtStart;
@end
