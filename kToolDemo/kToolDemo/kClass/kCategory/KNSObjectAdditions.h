//
//  NSObject+KNSObjectAdditions.h
//  kToolDemo
//
//  Created by 曹翔 on 2018/4/11.
//  Copyright © 2018年 CX. All rights reserved.
//

#import <objc/runtime.h>


/**
 *  数据校验
 */
NSString *kToString(id obj);

NSArray  *kToArray(id obj);

NSDictionary    *kToDictionary(id obj);

NSMutableArray  *kToMutableArray(id obj);

NSMutableDictionary *kToMutableDictionary(id obj);

BOOL    kIsNull(id value);


@interface NSObject (KNSObjectAdditions)

+ (instancetype)initWithDic:(NSDictionary*)dic;


/**
 *  通过NSDictionary初始化property
 *  为什么要增加这个，目的是避免服务器数据类型错误的问题
 */
- (void)kAutoSetPropertySafety:(NSDictionary *)item;

/**
 *  重置所有property
 */
- (void)kResetAllProperty;

/**
 *  获取当前class的property和value
 */
- (NSDictionary*)kAllPropertiestAndValues;

/**
 *  获取所有属性Properties 【含父类属性】
 *
 *  @return 数组
 */
- (NSMutableArray *)allProperties;

@end
