//
//  Constants.h
//  4DeavTourDemoApp
//
//  Created by Rohan on 16/03/17.
//  Copyright © 2017 Rohan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    DESIGN1,
    DESIGN2
} UI_DESIGN;

@interface DemoConstants : NSObject{
    @public
    BOOL makeGyroButtonVisible;
    BOOL makeVRButtonVisible;
    BOOL makeAutoplayOn;
    UI_DESIGN design;
    NSString *jsonBaseURL;
    NSString *imageBaseURL;
}
@end
