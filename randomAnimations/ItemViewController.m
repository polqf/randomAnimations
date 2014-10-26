//
//  ItemViewController.m
//  randomAnimations
//
//  Created by Pol Quintana on 24/10/14.
//  Copyright (c) 2014 Pol Quintana. All rights reserved.
//

#import "ItemViewController.h"
#import "Loader.h"
#import "RollingCube.h"

@interface ItemViewController ()

@property (weak, nonatomic) IBOutlet UIView *storyboardView;

@end

@implementation ItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.item == 0) {
        [self loader];
    }
    if (self.item == 1) {
        [self square];
    }
}

- (void)loader {
    self.storyboardView = [[Loader alloc] initWithFrame:self.view.frame];
}

- (void)square {
    self.storyboardView = [[RollingCube alloc] initWithFrame:self.view.frame];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
