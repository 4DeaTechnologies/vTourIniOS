//
//  vTourController.m
//  4DeavTourDemoApp
//
//  Created by Rohan on 15/03/17.
//  Copyright © 2017 Rohan. All rights reserved.
//

#import "vTourController.h"
#import <4DeavTourLibrary/vTourView.h>
#import <Google/Analytics.h>
#import "DemoConstants.h"
#import "VRController.h"

@interface vTourController ()<ViewerControllerProtocol,UICollectionViewDelegate,UICollectionViewDataSource>{
    UITextView *textView;
    int currentScene;
    NSDate *startTime;
    NSMutableArray *imagesOfThumnails;
    int thumbnailDownloadCount;
    UICollectionView *thumbnailCollectionView;
    DemoConstants *demoConstants;
}
@property (nonatomic,strong) NSDictionary *hotelsData;
@property (nonatomic,strong) vTourView *vtourView;
@end

@implementation vTourController

-(void)viewWillAppear:(BOOL)animated{
    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
    [tracker set:kGAIScreenName value:@"vTourScreen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Hotels" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.hotelsData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    demoConstants = [[DemoConstants alloc]init];
    
    // Do any additional setup after loading the view.
    [self setupvTourView];
    [self setupUI];
}


-(void)setupvTourView{
    self.vtourView = [[vTourView alloc]initWithFrame:self.view.frame withDelegate:self];
    [self.view addSubview:self.vtourView];
    
    NSInteger hotelNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"Hotel_Number"];
    NSArray *hotels = [self.hotelsData objectForKey:@"Hotels"];
    NSDictionary *hotel = [hotels objectAtIndex:hotelNumber];
    
    [self.vtourView setShortURL:[hotel objectForKey:@"ShortURL"]];
    //JSON URL would be something like: BaseURL + ShortURL + "/tourData.json"
    // For Example: "https://cdn.cleartrip.com/" + "Polo_Forest" + "/tourData.json"
    
    //Images URL would be something like: BaseURL + ShortURL + "/Images/" + SceneName + "Thumbnail/thumb.jpg"
    // For Example: "https://cdn.cleartrip.com/" + "Polo_Forest" + "/Images/" + "0ojas.jpg" + "Thumbnail/thumb.jpg"
    
    [self.vtourView enableArrow];
    [self.vtourView setUserSwipeSpeed:2];
    [self.vtourView downloadTourForUrl];
}

-(void)setupUI{
    
    textView = [[UITextView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height*0.4, self.view.frame.size.width, 0.3*self.view.frame.size.height)];
    [textView setText:@"Loading ..."];
    [textView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0]];
    [textView setTextColor:[UIColor colorWithRed:76.0/255.0 green:175.0/255.0 blue:80.0/255.0 alpha:1.0]];
    [textView setTextAlignment:NSTextAlignmentCenter];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setScrollEnabled:FALSE];
    [textView setEditable:FALSE];
    [self.view addSubview:textView];
    

    
    //Gyro Button
    if(demoConstants->makeGyroButtonVisible){
        UIButton *gyroButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [gyroButton setImage:[UIImage imageNamed:@"gyro.png"] forState:UIControlStateNormal];
        [gyroButton setCenter:CGPointMake(0.8*self.view.frame.size.width, 0.1*self.view.frame.size.height)];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gyroClicked)];
        singleTap.numberOfTapsRequired = 1;
        [gyroButton setUserInteractionEnabled:YES];
        [gyroButton addGestureRecognizer:singleTap];
        [self.view addSubview:gyroButton];
    }
    
    //VR Button
    if(demoConstants->makeVRButtonVisible){
        UIButton *vrButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        [vrButton setImage:[UIImage imageNamed:@"vr.png"] forState:UIControlStateNormal];
        [vrButton setCenter:CGPointMake(0.9*self.view.frame.size.width, 0.1*self.view.frame.size.height)];
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(vrClicked)];
        singleTap.numberOfTapsRequired = 1;
        [vrButton setUserInteractionEnabled:YES];
        [vrButton addGestureRecognizer:singleTap];
        [self.view addSubview:vrButton];
    }
    
    if(demoConstants->design == DESIGN1){
        [self setupCollectionView];
    }else if(demoConstants->design == DESIGN2){
        [self setupDesign2];
    }
}

#pragma mark - Protocol Callback Methods

-(void)thumbnailsURL:(NSArray *)thumbnailsURLs
{
    [self startDownloadingThumbnails:thumbnailsURLs];
}

-(void)onLowQualityLoaded{
    [textView removeFromSuperview];
}

-(void)sceneLoaded{
    if(!demoConstants->makeAutoplayOn){
        [self.vtourView stopAutoplay];
    }
}
-(void)percentLoaded:(float)percent{

}

-(void)tapInTourScene{

}


-(void)onAutoplayCompleted{

}

-(void)onTourDataLoaded{
    currentScene = [self.vtourView getCurrentScene];
    startTime = [NSDate date];
}
-(void)onArrowClicked{
    
}
-(void)onSceneChange{
    NSTimeInterval timeInterval = fabs([startTime timeIntervalSinceNow]);
    [self timeSpent:timeInterval inSceneNumber:currentScene];
    currentScene = [self.vtourView getCurrentScene];
    startTime = [NSDate date];
    [self.view addSubview:textView];
}

-(void)onFailedToLoadTourData{
    
}

-(void)autoplayStopped{
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.vtourView deleteTour]; //Tour dealloction method. (Required)
}

-(void)gyroClicked{
    [self.vtourView setGyroscopeOnOff];
}

-(void)vrClicked{
    [self.vtourView pause];
    VRController *vrController = [[VRController alloc]init];
    [self presentViewController:vrController animated:YES completion:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    if(self.vtourView!=nil){
        [self.vtourView resume];
    }
}

#pragma mark - Sending data to Google Analytics
- (void)timeSpent:(NSTimeInterval)timeSpent inSceneNumber:(int)sceneNumber{
    
    id tracker = [[GAI sharedInstance] defaultTracker];
    
    
    NSInteger hotelNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"Hotel_Number"];
    NSArray *hotels = [self.hotelsData objectForKey:@"Hotels"];
    NSDictionary *hotel = [hotels objectAtIndex:hotelNumber];
    
    NSString *category = [@"iOS - " stringByAppendingString:[hotel objectForKey:@"ShortURL"]];
    
    [tracker send:[[GAIDictionaryBuilder createTimingWithCategory:category
                                                         interval:@((NSUInteger)(timeSpent * 1000))
                                                             name:[category stringByAppendingString:[@"Scene - " stringByAppendingString:[NSString stringWithFormat:@"%d",sceneNumber]]]
                                                            label:nil] build]];
}



#pragma mark - Showing thumbnails Collection View

-(void)startDownloadingThumbnails:(NSArray*)thumbnailsURLs{
        imagesOfThumnails = [[NSMutableArray alloc]initWithCapacity:thumbnailsURLs.count];
        for(int i =0;i<thumbnailsURLs.count;i++){
            [imagesOfThumnails addObject:[self imageWithColor:[UIColor colorWithRed:240.0/255.0 green:90.0/255.0 blue:40.0/255.0 alpha:1.0] andSize:CGSizeMake(300, 200)]];
        
                [self downloadImageWithURL:[NSURL URLWithString:[thumbnailsURLs objectAtIndex:i]] completionBlock:^(BOOL succeeded, UIImage *image) {
                    @synchronized(self) {
                        if (succeeded) {
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [imagesOfThumnails replaceObjectAtIndex:i withObject:image];
                                [thumbnailCollectionView reloadData];
                            });
                        }
                    }
                }];
            }
}

- (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



-(void)downloadImageWithURL:(NSURL *)url completionBlock:(void (^)(BOOL succeeded, UIImage *image))completionBlock{

    NSURLSessionDownloadTask *downloadPhotoTask = [[NSURLSession sharedSession]
                                                   downloadTaskWithURL:url completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                       
                                                       if(!error){
                                                           UIImage *downloadedImage = [UIImage imageWithData:
                                                                                       [NSData dataWithContentsOfURL:location]];
                                                           completionBlock(YES,downloadedImage);
                                                       }else{
                                                           completionBlock(NO,nil);
                                                       }
                                                       
                                                   }];
    [downloadPhotoTask resume];
}


#pragma mark - User Interface Part
-(void)setupCollectionView{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    thumbnailCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0.8*self.view.frame.size.height, self.view.frame.size.width, 0.2*self.view.frame.size.height) collectionViewLayout:layout];
    [thumbnailCollectionView setDataSource:self];
    [thumbnailCollectionView setDelegate:self];
    thumbnailCollectionView.backgroundColor = [UIColor colorWithRed:0.243 green:0.243 blue:0.243 alpha:1.0];
    [thumbnailCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
    [thumbnailCollectionView setTag:1];
    [thumbnailCollectionView setBounces:YES];
    [self.view addSubview:thumbnailCollectionView];
    [thumbnailCollectionView setShowsHorizontalScrollIndicator:NO];
    [thumbnailCollectionView setShowsVerticalScrollIndicator:NO];
    
    [self.view addSubview:thumbnailCollectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(imagesOfThumnails.count!=0){
        return imagesOfThumnails.count;
    }else{
        return 5;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell1";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImage *image = [imagesOfThumnails objectAtIndex:indexPath.item];
    UIView *v = [[UIView alloc] init];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.bounds.size.width, cell.bounds.size.height)];
    [iv setImage:image];
    [v addSubview:iv];
    
    cell.backgroundView = v;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1;
    cell.layer.cornerRadius = 6;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    return CGSizeMake(0.15*self.view.frame.size.height*1.5, 0.15*self.view.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSLog(@"Selecting item at index: %ld",(long)indexPath.item);
    [self.vtourView changeSceneToSceneNumer:(int)indexPath.item];
}

#pragma mark - Design 2

-(void)setupDesign2{
    UIImage *leftArrowimage = [UIImage imageNamed:@"left.png"];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [iv setCenter:CGPointMake(0+20, 0.5*self.view.frame.size.height-20)];
    [iv setImage:leftArrowimage];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftArrowClicked)];
    singleTap.numberOfTapsRequired = 1;
    [iv setUserInteractionEnabled:YES];
    [iv addGestureRecognizer:singleTap];
    [self.view addSubview:iv];
    
    UIImage *rightArrowimage = [UIImage imageNamed:@"right.png"];
    UIImageView *iv_right = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [iv_right setCenter:CGPointMake(self.view.frame.size.width - 20, 0.5*self.view.frame.size.height-20)];
    [iv_right setImage:rightArrowimage];
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightArrowCliced)];
    singleTap.numberOfTapsRequired = 1;
    [iv_right setUserInteractionEnabled:YES];
    [iv_right addGestureRecognizer:singleTap];
    [self.view addSubview:iv_right];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.9*self.view.frame.size.height, self.view.frame.size.width, 0.1*self.view.frame.size.height)];
    [bottomView setBackgroundColor:[UIColor colorWithRed:0.243 green:0.243 blue:0.243 alpha:1.0]];
    
    UIButton *bookHotelButton = [[UIButton alloc]initWithFrame:CGRectMake(0.55*bottomView.frame.size.width, bottomView.frame.size.height*0.1, 0.4*bottomView.frame.size.width, bottomView.frame.size.height*0.8)];
    [bookHotelButton setTitle:@"Book this Hotel" forState:UIControlStateNormal];
    [bookHotelButton setBackgroundColor:[UIColor colorWithRed:76.0/255.0 green:175.0/255.0 blue:80.0/255.0 alpha:1.0]];
    [bottomView addSubview:bookHotelButton];
    
    UITextView *hotelName = [[UITextView alloc]initWithFrame:CGRectMake(0.1*bottomView.frame.size.width, 0.1*bottomView.frame.size.height, 0.4*bottomView.frame.size.width,0.8*bottomView.frame.size.height)];
    
    NSInteger hotelNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"Hotel_Number"];
    NSArray *hotels = [self.hotelsData objectForKey:@"Hotels"];
    NSDictionary *hotel = [hotels objectAtIndex:hotelNumber];
    
    [hotelName setText:[[hotel objectForKey:@"Title"] stringByAppendingString:@"\n Price : Rs. 5000"]];
    [hotelName setTextColor:[UIColor whiteColor]];
    [hotelName setBackgroundColor:[UIColor clearColor]];
    [hotelName setTextAlignment:NSTextAlignmentCenter];
    [hotelName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18.0]];
    [hotelName setScrollEnabled:FALSE];
    [hotelName setEditable:FALSE];
    [bottomView addSubview:hotelName];
 
    [self.view addSubview:bottomView];
}

-(void)leftArrowClicked{
    int currentSceneNumber = [self.vtourView getCurrentScene];
    if(currentSceneNumber!=0){
        [self.vtourView changeSceneToSceneNumer:currentSceneNumber-1];
    }
}

-(void)rightArrowCliced{
    NSArray *scenesArray = [self.vtourView getSceneNames];
    int currentSceneNumber = [self.vtourView getCurrentScene];
    if(currentSceneNumber<scenesArray.count-1){
         [self.vtourView changeSceneToSceneNumer:currentSceneNumber+1];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
