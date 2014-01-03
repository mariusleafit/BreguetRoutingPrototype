//
//  customNavigationControllerViewController.m
//  BiluneGeoMobile
//
//  Created by Marius Gächter on 26.08.13.
//  Copyright (c) 2013 leafit. All rights reserved.
//

#import "CustomNavigationController.h"

@interface CustomNavigationController ()

@end

@implementation CustomNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ViewOrientation management

//enables autorotation only for map
-(BOOL)shouldAutorotate {
    BOOL returnFlag = false;
    
    //if([[self topViewController] isKindOfClass:[MapViewController class]]) {
    //    returnFlag = true;
    //}
    
    return returnFlag;
}

-(NSUInteger)supportedInterfaceOrientations {
    //if([[self topViewController] isKindOfClass:[MapViewController class]]) {
    //    return UIInterfaceOrientationMaskAllButUpsideDown;
    //} else {
        return UIInterfaceOrientationMaskPortrait;
    //}
}

//force Portrait orientation except for Legendview (show orientation of parent view)
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    //if([[self topViewController] isKindOfClass:[LegendViewController class]]) {
    //    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
    //} else {
        return UIInterfaceOrientationPortrait;
    //}
}

@end
