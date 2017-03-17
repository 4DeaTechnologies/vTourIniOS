//
//  HotelViewController.m
//  4DeavTourDemoApp
//
//  Created by Rohan on 15/03/17.
//  Copyright © 2017 Rohan. All rights reserved.
//

#import "HotelViewController.h"
#import "vTourController.h"

@interface HotelViewController (){
    UIImageView *imageView;
    UIActivityIndicatorView *spinner;
}
@property (nonatomic,strong) NSDictionary *hotelsData;
@end

@implementation HotelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Load JSON Data
    NSInteger hotelNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"Hotel_Number"];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Hotels" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.hotelsData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    spinner.alpha = 1.0;
    [spinner setCenter:CGPointMake(0.5*self.view.frame.size.width, 0.2*self.view.frame.size.height)];
    [self.view addSubview:spinner];
    [spinner startAnimating];

    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 0.4*self.view.frame.size.height)];
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped)];
    singleTap.numberOfTapsRequired = 1;
    [imageView setUserInteractionEnabled:YES];
    [imageView addGestureRecognizer:singleTap];
    
    UITextView *textView = [[UITextView alloc]initWithFrame:CGRectMake(0.1*self.view.frame.size.width, 0.45*self.view.frame.size.height, 0.8*self.view.frame.size.width, 0.5*self.view.frame.size.height)];
    NSArray *hotels = [self.hotelsData objectForKey:@"Hotels"];
    NSDictionary *hotel = [hotels objectAtIndex:(int)hotelNumber];
    
    [textView setText:[hotel objectForKey:@"Description"]];
    [textView setScrollEnabled:FALSE];
    [textView setEditable:FALSE];
    [textView setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14.0]];
     
     [self.view addSubview:textView];
    
    UIButton *bookHotelButton = [[UIButton alloc]initWithFrame:CGRectMake(0.2*self.view.frame.size.width, 0.9*self.view.frame.size.height, 0.6*self.view.frame.size.width, 50)];
    [bookHotelButton setTitle:@"Book this Hotel" forState:UIControlStateNormal];
    [bookHotelButton setBackgroundColor:[UIColor colorWithRed:76.0/255.0 green:175.0/255.0 blue:80.0/255.0 alpha:1.0]];
    [self.view addSubview:bookHotelButton];
    
    [self downloadTourThumbnail];
    
}

-(void)imageTapped{
    NSLog(@"Image Tapped");
    vTourController *vtour = [[vTourController alloc]init];
    [self.navigationController pushViewController:vtour animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)downloadTourThumbnail{
    
    NSInteger hotelNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"Hotel_Number"];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Hotels" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.hotelsData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    NSArray *hotels = [self.hotelsData objectForKey:@"Hotels"];
    NSDictionary *hotel = [hotels objectAtIndex:(int)hotelNumber];
    
    
    NSString *url = [[@"https://s3.eu-central-1.amazonaws.com/4dea-development-commonpanos/vtour/" stringByAppendingString:[hotel objectForKey:@"ShortURL"]] stringByAppendingString:@"/images/MainThumbnail.jpg"];
    NSURL *thumbnailURL = [NSURL URLWithString:url];
    
    [self downloadImageWithURL:thumbnailURL completionBlock:^(BOOL succeeded, UIImage *image) {
        @synchronized(self) {
            if (succeeded) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [spinner removeFromSuperview];
                    
                    [imageView setImage:image];
                    [self.view addSubview:imageView];
                });
            }
        }
    }];
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




@end
