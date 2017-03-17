//
//  ViewController.m
//  4DeavTourDemoApp
//
//  Created by Rohan on 15/03/17.
//  Copyright © 2017 Rohan. All rights reserved.
//

#import "ViewController.h"
#import "HotelViewController.h"

@interface ViewController (){
    NSMutableArray *imagesOfThumnails;
}
@property (nonatomic,strong) UICollectionView *hotelCollectionView;
@property (nonatomic,strong) NSDictionary *hotelsData;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Loading JSON Data
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Hotels" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    self.hotelsData = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    [self setupCollectionView];
    [self downloadSmallThumbnails];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)setupCollectionView{
    imagesOfThumnails = [[NSMutableArray alloc]init];
    NSArray *hotels = [self.hotelsData objectForKey:@"Hotels"];
    for (int i=0;i<hotels.count; i++) {
        [imagesOfThumnails addObject:[self imageWithColor:[UIColor grayColor] andSize:CGSizeMake(300, 200)]];
    }
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.hotelCollectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0.1*self.view.frame.size.width, 0.1*self.view.frame.size.height, 0.8*self.view.frame.size.width, 0.8*self.view.frame.size.height) collectionViewLayout:layout];
    [self.hotelCollectionView setDataSource:self];
    [self.hotelCollectionView setDelegate:self];
    self.hotelCollectionView.backgroundColor = [UIColor clearColor];
    [self.hotelCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell1"];
    [self.hotelCollectionView setTag:1];
    [self.hotelCollectionView setBounces:YES];
    [self.view addSubview:self.hotelCollectionView];
    [self.hotelCollectionView setShowsHorizontalScrollIndicator:NO];
    [self.hotelCollectionView setShowsVerticalScrollIndicator:NO];
    
    [self.view addSubview:self.hotelCollectionView];
}

-(void)downloadSmallThumbnails{
    
    NSArray *hotels = [self.hotelsData objectForKey:@"Hotels"];
    for (int i=0;i<hotels.count; i++) {
        NSDictionary *hotel = [hotels objectAtIndex:i];
        NSString *urlString = [[@"https://s3.eu-central-1.amazonaws.com/4dea-development-commonpanos/vtour/" stringByAppendingString:[hotel objectForKey:@"ShortURL"]] stringByAppendingString:@"/images/MainThumbnail_small.jpg"];
        NSURL *url = [NSURL URLWithString:urlString];
        [self downloadImageWithURL:url completionBlock:^(BOOL succeeded, UIImage *image) {
            @synchronized(self) {
                if (succeeded) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [imagesOfThumnails replaceObjectAtIndex:i withObject:image];
                        [self.hotelCollectionView reloadData];
                    });
                }
            }
            
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSArray *hotels = [self.hotelsData objectForKey:@"Hotels"];
    return hotels.count;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"cell1";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    UIImage *image = [imagesOfThumnails objectAtIndex:indexPath.item];
    UIView *v = [[UIView alloc] init];
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0.02*cell.bounds.size.width, 0.1*cell.bounds.size.height, 0.3*cell.bounds.size.width, 0.8*cell.bounds.size.height)];
    [iv setImage:image];
    [v addSubview:iv];
    
    UITextView *hotelName = [[UITextView alloc]initWithFrame:CGRectMake(0.35*cell.bounds.size.width, 0.1*cell.bounds.size.height, 0.65*cell.bounds.size.width, 0.3*cell.bounds.size.height)];
    
    NSArray *hotels = [self.hotelsData objectForKey:@"Hotels"];
    NSDictionary *hotel = [hotels objectAtIndex:indexPath.item];
    
    [hotelName setText:[hotel objectForKey:@"Title"]];
    [hotelName setScrollEnabled:FALSE];
    [hotelName setEditable:FALSE];
    [hotelName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16.0]];
    
    [v addSubview:hotelName];
    
    UITextView *hotelPrice = [[UITextView alloc]initWithFrame:CGRectMake(0.35*cell.bounds.size.width, 0.5*cell.bounds.size.height, 0.65*cell.bounds.size.width, 0.2*cell.bounds.size.height)];
    [hotelPrice setText:@"Price Rs. 5000"];
    [hotelPrice setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
    [hotelPrice setEditable:FALSE];
    [hotelPrice setScrollEnabled:FALSE];
    
    [v addSubview:hotelPrice];
    
    
    cell.backgroundView = v;
    cell.layer.masksToBounds = YES;
    cell.layer.borderWidth = 1;
    cell.layer.cornerRadius = 6;
    cell.layer.borderColor = [UIColor blackColor].CGColor;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath*)indexPath{
    return CGSizeMake(0.8*self.view.frame.size.width, 0.2*self.view.frame.size.width);
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    HotelViewController *hotelViewController = [[HotelViewController alloc]init];
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInteger:indexPath.item] forKey:@"Hotel_Number"];
    [self.navigationController pushViewController:hotelViewController animated:YES];
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



@end
