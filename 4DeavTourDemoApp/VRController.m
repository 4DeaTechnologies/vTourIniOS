//
//  VRController.m
//  4DeavTourDemoApp
//
//  Created by Rohan on 16/03/17.
//  Copyright © 2017 Rohan. All rights reserved.
//

#import "VRController.h"
#import <4DeavTourLibrary/VRModeView.h>

@interface VRController ()
@property (nonatomic,strong) VRModeView *vrModeView;
@end

@implementation VRController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(GLKMathDegreesToRadians(90));
    [self.view setTransform:landscapeTransform];

    self.vrModeView = [[VRModeView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) withSceneNumber:0 withDelegate:self];
    [self.view addSubview:self.vrModeView];
    
    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [backButton setImage:[UIImage imageNamed:@"vr_back.png"] forState:UIControlStateNormal];
    [backButton setCenter:CGPointMake(0.05*self.view.frame.size.width, 0.05*self.view.frame.size.height)];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackPressed)];
    singleTap.numberOfTapsRequired = 1;
    [backButton setUserInteractionEnabled:YES];
    [backButton addGestureRecognizer:singleTap];
    [self.view addSubview:backButton];
    // Do any additional setup after loading the view.
}


-(void)onBackPressed{
    [self.vrModeView deleteTourAndGetSceneNumber];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
