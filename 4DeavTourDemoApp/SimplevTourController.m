//
//  SimplevTourController.m
//  4DeavTourDemoApp
//
//  Created by Rohan on 17/03/17.
//  Copyright © 2017 Rohan. All rights reserved.
//

#import "SimplevTourController.h"

@interface SimplevTourController ()
@end

@implementation SimplevTourController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    [self setupUI];
}

-(void)setupUI{
    
    UIBarButtonItem *gyroButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Gyro"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(onGyroClicked)];
    
    UIBarButtonItem *vrButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"VR"
                                   style:UIBarButtonItemStylePlain
                                   target:self
                                   action:@selector(onVRClicked)];
    
    NSArray * buttons = @[gyroButton,vrButton];
    [self.navigationItem setRightBarButtonItems:buttons];
    
}



#pragma mark - Call vTourMethods
-(void)onGyroClicked{
    
}

-(void)onVRClicked{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
