//
//  KColorManager.h
//  kToolDemo
//
//  Created by 曹翔 on 2018/4/11.
//  Copyright © 2018年 CX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KColorManager : NSObject


+(instancetype)defaultManager;


/**
 *  通过十六进制格式获取UIColor
 *
 *  @param hexColor 如0xffffff 或  #ffffff
 *
 *  @return UIColor 这个方法不会从内存中读取
 */
+ (UIColor*)colorWithHexString:(NSString *)hexColor;


@end
