//
//  VRModeView.h
//  4DeavTourSDK
//
//  Created by Rohan on 31/08/16.
//  Copyright © 2016 Rohan. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface VRModeView : GLKView
- (instancetype)initWithFrame:(CGRect)frame withSceneNumber:(int)sceneNumber withDelegate:(id)controllerDelegate;
-(int)deleteTourAndGetSceneNumber;
@end