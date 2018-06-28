//
//  UIButton+Click.m
//  kToolDemo
//
//  Created by 曹翔 on 2018/5/30.
//  Copyright © 2018年 CX. All rights reserved.
//

#import "UIButton+Click.h"
#import <objc/runtime.h>

@interface UIButton ()
@property (nonatomic,assign)    BOOL    isIgnoreEvent;
@end

@implementation UIButton (Click)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL selA = @selector(sendAction:to:forEvent:);
        SEL selB = @selector(mySendAction:to:forEvent:);
        Method methodA = class_getInstanceMethod(self, selA);
        Method methodB = class_getInstanceMethod(self, selB);
        BOOL isAdd = class_addMethod(self, selA, method_getImplementation(methodB), method_getTypeEncoding(methodB));
        if (isAdd) {
            class_replaceMethod(self, selB, method_getImplementation(methodA), method_getTypeEncoding(methodA));
        } else {
            method_exchangeImplementations(methodA, methodB);
        }
    });
}

-(NSTimeInterval)timeInterval{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

-(void)setTimeInterval:(NSTimeInterval)timeInterval{
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)mySendAction:(SEL)action to:(id)target forEvent:(UIEvent*)event{
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"]) {
        if (self.isIgnoreEvent == 0) {
            self.timeInterval = self.timeInterval == 0?defaultBtnInterval:self.timeInterval;
        };
        if (self.isIgnoreEvent) {
            return;
        };
        if (self.timeInterval>0) {
            self.isIgnoreEvent = YES;
            [self performSelector:@selector(setIsIgnoreEvent:) withObject:@(NO) afterDelay:self.timeInterval];
        }
    }
    
    [self mySendAction:action to:target forEvent:event];
}

-(BOOL)isIgnoreEvent{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
-(void)setIsIgnoreEvent:(BOOL)isIgnoreEvent{
    objc_setAssociatedObject(self, @selector(isIgnoreEvent), @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end