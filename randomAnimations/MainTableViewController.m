//
//  MainTableViewController.m
//  randomAnimations
//
//  Created by Pol Quintana on 26/10/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "MainTableViewController.h"
#import "LoaderViewController.h"
#import "Loader.h"
#import "RollingCube.h"
#import "CircularLoader.h"
#import "BarsInCircle.h"

@interface MainTableViewController ()

@property (nonatomic, strong) NSArray *items;

@end

@implementation MainTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.items = @[@"Bouncing Loader",@"Square", @"Circular Loader", @"BarsInCircle"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.items count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = [self.items objectAtIndex:indexPath.row];
    
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    LoaderViewController *vc = [segue destinationViewController];
    NSInteger index = [self.tableView indexPathForSelectedRow].row;
    vc.title = [self.items objectAtIndex:index];
    
    switch (index) {
        case 0:
            vc.view = [[Loader alloc] initWithFrame:vc.view.frame];
            break;
        case 1:
            vc.view = [[RollingCube alloc] initWithFrame:vc.view.frame];
            break;
        case 2:
            vc.view = [[CircularLoader alloc] initWithFrame:vc.view.frame];
            break;
        case 3:
            vc.view = [[BarsInCircle alloc] initWithFrame:vc.view.frame];
            break;
            
        default:
            break;
    }
    
}


@end
