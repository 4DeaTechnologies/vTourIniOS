//
//  SimplevTourController.m
//  4DeavTourDemoApp
//
//  Created by Rohan on 17/03/17.
//  Copyright © 2017 Rohan. All rights reserved.
//

#import "SimplevTourController.h"
#import <4DeavTourLibrary/vTourView.h>

@interface SimplevTourController ()<ViewerControllerProtocol>
@property (nonatomic,strong) vTourView *myvTourView;
@end

@implementation SimplevTourController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupvTourView];
    [self setupUI];
}

-(void)setupvTourView{
    self.myvTourView = [[vTourView alloc]initWithFrame:self.view.frame withDelegate:self];
    [self.myvTourView setBaseURL:@"https://s3.eu-central-1.amazonaws.com/4dea-development-commonpanos/vtour/"]; //Pass baseURL of cleartrip web server structure
    [self.myvTourView setJSONBaseURL:@"https://s3.eu-central-1.amazonaws.com/testingpurpose4dea/vtour/"];
    [self.myvTourView setShortURL:@"Polo_Forest"];
    [self.myvTourView setUserSwipeSpeed:2];
    [self.myvTourView downloadTourForUrl];
    
    [self.view addSubview:self.myvTourView];
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
    [self.myvTourView setGyroscopeOnOff];
}

-(void)onVRClicked{
    
}


#pragma mark - Implementing callback methods for vTourView
-(void)thumbnailsURL:(NSArray*)thumbnailsURLArray{
    
}

-(void)onLowQualityLoaded{
    
}

-(void)sceneLoaded{
    [self.myvTourView stopAutoplay];
}

-(void)percentLoaded:(float)percent{
    
}

-(void)tapInTourScene{
    
}

-(void)onSceneChange{
    
}

-(void)onAutoplayCompleted{
    
}

-(void)onTourDataLoaded{
    
}

-(void)onArrowClicked{
    
}

-(void)onFailedToLoadTourData{
    
}

-(void)autoplayStopped{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
