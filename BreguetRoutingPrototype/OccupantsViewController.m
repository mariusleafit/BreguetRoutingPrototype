//
//  OccupantsViewController.m
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 06.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import "OccupantsViewController.h"

@interface OccupantsViewController ()

@end

@implementation OccupantsViewController

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

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
