//
//  UIButton+Click.h
//  kToolDemo
//
//  Created by 曹翔 on 2018/5/30.
//  Copyright © 2018年 CX. All rights reserved.
//

#import <UIKit/UIKit.h>
#define defaultBtnInterval  .3  //默认点击事件响应间隔0.3秒

@interface UIButton (Click)
@property (nonatomic,assign)    NSTimeInterval  timeInterval;//手动修改事件间隔

@end
