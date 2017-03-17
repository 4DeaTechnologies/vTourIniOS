//
//  Constants.m
//  4DeavTourDemoApp
//
//  Created by Rohan on 16/03/17.
//  Copyright © 2017 Rohan. All rights reserved.
//

#import "DemoConstants.h"

@implementation DemoConstants

- (instancetype)init
{
    self = [super init];
    if (self) {
        makeVRButtonVisible = FALSE;
        makeGyroButtonVisible = FALSE;
        makeAutoplayOn = FALSE;
        design = DESIGN2;
        imageBaseURL = @"https://dev-images.4dea.co/vtour/";
        jsonBaseURL = @"https://360-tours-dev.4dea.co/vtour/";
    }
    return self;
}

@end
