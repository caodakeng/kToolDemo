//
//  KPublicFunctions.m
//  kToolDemo
//
//  Created by 曹翔 on 2018/4/11.
//  Copyright © 2018年 CX. All rights reserved.
//

#import "KPublicFunctions.h"

UIWindow *mainWindow() {
    id appDelegate = [UIApplication sharedApplication].delegate;
    if (appDelegate && [appDelegate respondsToSelector:@selector(window)]) {
        return [appDelegate window];
    }
    
    
    NSArray *windows = [UIApplication sharedApplication].windows;
    if ([windows count] == 1) {
        return [windows firstObject];
    } else {
        for (UIWindow *window in windows) {
            if (window.windowLevel == UIWindowLevelNormal) {
                return window;
            }
        }
    }
    
    return nil;
}







#pragma mark - appVersion
NSString *KAppVersion()
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return appVersion;
}
