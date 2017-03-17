//
//  ViewerGLView.h
//  4DeavTourLibrary
//
//  Created by Rohan on 03/08/16.
//  Copyright © 2016 Rohan. All rights reserved.
//

#import <GLKit/GLKit.h>

@protocol ViewerControllerProtocol <NSObject>

-(void)thumbnailsURL:(NSArray*)thumbnailsURLArray;
-(void)onLowQualityLoaded;
-(void)sceneLoaded;
-(void)percentLoaded:(float)percent;
-(void)tapInTourScene;

-(void)onSceneChange;

-(void)onAutoplayCompleted;
-(void)onTourDataLoaded;
-(void)onArrowClicked;
-(void)onFailedToLoadTourData;
-(void)autoplayStopped;
@end

@interface vTourView : GLKView

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id)glk;
-(void)setBaseURL:(NSString*)baseURL;
-(void)setShortURL:(NSString*)shortURL;
-(void)setJSONBaseURL:(NSString*)jsonBaseURL;
-(void)disableArrow;
-(void)enableArrow;
-(void)setUserSwipeSpeed:(float)speed;
-(void)setInitialSceneNumber:(int)sceneNumber;
-(void)downloadTourForUrl;
-(void)changeSceneToSceneNumer:(int)sceneNumber;
-(void)changeTimeInterval:(int)time;
-(void)setGyroscopeOnOff;
-(void)startAutoplay;
-(void)startAutoplayWithSceneNumber:(int)currentScene;
-(void)stopAutoplay;
-(int)getCurrentScene;
-(NSArray*)getSceneNames;
-(NSString*)getCurrentSceneName;
-(void)pause;
-(void)resume;
-(void)resumeWithSceneNumber:(int)sceneNumber;
-(void)showDefaultUI;
-(void)clearCache;
-(void)deleteTour;
@end
