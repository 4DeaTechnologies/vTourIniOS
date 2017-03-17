//
//  VRController.m
//  4DeavTourDemoApp
//
//  Created by Rohan on 16/03/17.
//  Copyright © 2017 Rohan. All rights reserved.
//

#import "VRController.h"
#import <GLKit/GLKit.h>

@interface VRController ()
@end

@implementation VRController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation(GLKMathDegreesToRadians(90));
    [self.view setTransform:landscapeTransform];

    UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [backButton setImage:[UIImage imageNamed:@"left.png"] forState:UIControlStateNormal];
    [backButton setCenter:CGPointMake(0.1*self.view.frame.size.width, 0.1*self.view.frame.size.height)];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackPressed)];
    singleTap.numberOfTapsRequired = 1;
    [backButton setUserInteractionEnabled:YES];
    [backButton addGestureRecognizer:singleTap];
    [self.view addSubview:backButton];
    // Do any additional setup after loading the view.
}


-(void)onBackPressed{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
