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
        imageBaseURL = @"https://s3.eu-central-1.amazonaws.com/4dea-development-commonpanos/vtour/";
        jsonBaseURL = @"https://s3.eu-central-1.amazonaws.com/testingpurpose4dea/vtour/";
    }
    return self;
}

@end
