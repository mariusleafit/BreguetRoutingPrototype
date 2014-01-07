//
//  DestinationViewController.m
//  BreguetRoutingPrototype
//
//  Created by Marius Gächter on 06.01.14.
//  Copyright (c) 2014 leafit. All rights reserved.
//

#import "DestinationViewController.h"
#import "AppDelegate.h"
#import "OccupantsViewController.h"
#import "FloorsViewController.h"

@interface DestinationViewController ()
@property (nonatomic, weak) AppDelegate *appDelegate;
@end

@implementation DestinationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	self.appDelegate = GetAppDelegate();
    
    self.navigationItem.title = @"Déstination";
}

-(void)viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    #define main_group 0
        #define occupants_entry 0
        #define locaux_entry 1
    
    //get the indexPath
    NSUInteger selection[2];
    [indexPath getIndexes: selection];
    
    //call the corresponding method of the listEntry
    switch (selection[0]) {
        case main_group:
            switch(selection[1]) {
                case occupants_entry:
                    [self showOccupants];
                    break;
                case locaux_entry:
                    [self showLocaux];
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }

}

#pragma mark listEntryMethods

-(void) showOccupants {
    UIStoryboard *destinationStoryboard = [UIStoryboard storyboardWithName:@"destination" bundle:nil];
    OccupantsViewController  *occupantsViewController = [destinationStoryboard instantiateViewControllerWithIdentifier:@"occupants"];
    [self.appDelegate.navigationController pushViewController:occupantsViewController animated:YES];
}

-(void) showLocaux {
    UIStoryboard *destinationStoryboard = [UIStoryboard storyboardWithName:@"destination" bundle:nil];
    FloorsViewController  *floorsViewController = [destinationStoryboard instantiateViewControllerWithIdentifier:@"floors"];
    [self.appDelegate.navigationController pushViewController:floorsViewController animated:YES];
}

@end
