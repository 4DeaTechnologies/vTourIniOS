# 4Dea vTour Demo App

### Integration
1. In the first step, add **4DeavTourLibrary.framework** and **4DeavTourLibrary.bundle** to your Xcode Project.

2. In the next step, import vTourView.h file into your ViewController. In addition, adopt ViewerControllerProtocol in your ViewController class and implement protocol methods.

3. Now, declare an object of vTourView and set the options for vTourView to download your tour. Options include setting the JSONBaseURL, ImagesBaseURL and ShortURL for the tour. Finally, add the vTourView to your ViewController and call downloadTourForUrl of vTourView.

4. In the next step, create another View Controller for VR Mode. In the VRController, declare an object of VRModeView and add it to VRController. (VRController should be call from ViewController by first calling pause method of vTourView and resume method should be called in viewDidAppear of ViewController, and deleteTourAndGetSceneNumber should be called before coming back to ViewController from VRController).

5. And, that's it. You have your own vTour embedded in your own app.

### vTourMethods
This method sets the base URL for vTour.
```
-(void)setBaseURL:(NSString*)baseURL;
```

This method sets the short URL for the tour you want to display.
```
-(void)setShortURL:(NSString*)shortURL;
```

This method sets the base URL for vTour JSON.
```
-(void)setJSONBaseURL:(NSString*)jsonBaseURL;
```

This method enables the arrows in vTour.
```
-(void)enableArrow;
```

This method disables the arrows in vTour.
```
-(void)disableArrow;
```

This method sets the swipe speed for touch fluidity in vTour. Default value is 0.8.
```
-(void)setUserSwipeSpeed:(float)speed;
```

This method is used to set the initial scene number from where the vTour should start. This method should be called before downloadTourForUrl.
```
-(void)setInitialSceneNumber:(int)sceneNumber;
```

This starts downloading the vTour after certain options for vTour has been set.
```
-(void)downloadTourForUrl;
```

This method should be called when you want to change scene in vTour.
```
-(void)changeSceneToSceneNumer:(int)sceneNumber;
```

This method is used to change the time interval for autoplay feature of vTour.
```
-(void)changeTimeInterval:(int)time;
```

This method is used to turn vTour Gyroscope On/Off.
```
-(void)setGyroscopeOnOff;
```

This method starts the autoplay feature of vTour. By default, this feature is set to on. 
```
-(void)startAutoplay;
```

This method starts the autoplay feature from the Scene you want to start with.
```
-(void)startAutoplayWithSceneNumber:(int)currentScene;
```

This method stops the autoplay feature of vTour.
```
-(void)stopAutoplay;
```

This method returns the index of Current Scene in vTour.
```
-(int)getCurrentScene;
```

This method fetches all the Scene names of vTour.
```
-(NSArray*)getSceneNames;
```

This method returns the name of Current Scene in vTour.
```
-(NSString*)getCurrentSceneName;
```

This method pauses the vTour. This method should be called before moving to VR Mode.
```
-(void)pause;
```

This method resumes the vTour, and should be called in viewDidAppear of ViewController,
```
-(void)resume;
```

This method resumes the vTour with the Scene specified. This method should be called after returning from VRMode.
```
-(void)resumeWithSceneNumber:(int)sceneNumber;
```

This method clears the cache of vTour.
```
-(void)clearCache;
```
### Callback Methods
This callback method fetches all the Scene thumbnail URLs to download from.
```
-(void)thumbnailsURL:(NSArray*)thumbnailsURLArray;
```

This callback method will be called when low quality image of any scene has been downloaded.
```
-(void)onLowQualityLoaded;
```

This callback method will be called when a scene of vTour has been loaded.
```
-(void)sceneLoaded;
```

This callback method gets the percentage of any scene that has been downloaded.
```
-(void)percentLoaded:(float)percent;
```

This callback method notifies whenever user taps inside the vTour Scene.
```
-(void)tapInTourScene;
```

This callback method notifies when the vTour changes from current scene to next scene.
```
-(void)onSceneChange;
```

This callback method notifies when autoplay has been completed for the vTour.
```
-(void)onAutoplayCompleted;
```

This callback method notifies when the JSON for vTour has been downloaded.
```
-(void)onTourDataLoaded;
```

This callback method notifies when an arrow inside a scene has been clicked.
```
9. -(void)onArrowClicked;
```

This callback method notifies when downloading for vTour JSON has failed.
```
10. -(void)onFailedToLoadTourData;
```

This callback method notifies when autoplay has been stopped using vTourView stopAutoplay method.
```
11. -(void)autoplayStopped;
```
