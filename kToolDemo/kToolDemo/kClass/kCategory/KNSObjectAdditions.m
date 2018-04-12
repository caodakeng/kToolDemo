//
//  NSObject+KNSObjectAdditions.m
//  kToolDemo
//
//  Created by 曹翔 on 2018/4/11.
//  Copyright © 2018年 CX. All rights reserved.
//

#import "KNSObjectAdditions.h"

static NSSet    *foundationClasses_;    //系统基类集合

@implementation NSObject (KNSObjectAdditions)

+ (instancetype)initWithDic:(NSDictionary*)dic {
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    id obj = [[[self class] alloc] init];
    [obj kAutoSetPropertySafety:dic];
    return obj;
}

- (void)kAutoSetPropertySafety:(NSDictionary *)item
{
    if (!item || ![item isKindOfClass:[NSDictionary class]]) {
        return;
    }
    //获取所有property
    [[self class] enumerateClasses:^(__unsafe_unretained Class class, BOOL *stop) {
        
        [self setClassProperty:class withPropertyDic:item];
        
    }];
}


/**
 *  重置所有property【含父类属性】
 */
- (void)kResetAllProperty
{
    
    [[self class] enumerateClasses:^(__unsafe_unretained Class class, BOOL *stop) {
        
        [self resetPropertyFromClass:class];
        
    }];
}

/**
 *  获取所有的property和value【含父类属性】
 *  @return 字典  key-value
 */
- (NSDictionary*)kAllPropertiestAndValues
{
    //  获取所有propertiest
    NSMutableDictionary *propertiesDic = [NSMutableDictionary dictionary];
    [[self class] enumerateClasses:^(__unsafe_unretained Class class, BOOL *stop) {
        
        [propertiesDic addEntriesFromDictionary:[self propertiesAndValuesFromClass:class]];
    }];
    return propertiesDic;
}


/**
 *  获取所有属性Properties 【含父类属性】
 *
 *  @return 数组
 */
- (NSMutableArray *)allProperties
{
    NSMutableArray *propertiestArray = [NSMutableArray array];
    [[self class] enumerateClasses:^(__unsafe_unretained Class class, BOOL *stop) {
        
        [propertiestArray addObjectsFromArray:[class curClassProperties]];
    }];
    
    return propertiestArray;
}



#pragma mark - 基类方法


/**
 *  设置 class Property 的 value【不含父类property】
 *
 *  @param class 类名
 *  @param item  数据字典
 */
- (void)setClassProperty:(Class)class withPropertyDic:(NSDictionary *)item
{
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        //property名称
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        id value = item[propertyName];
        if (!kIsNull(value)) { // 值存在，才有意义
            //获取该property的数据类型
            const char *attries = property_getAttributes(property);
            NSString *attrString = [NSString stringWithUTF8String:attries];
            [self kSetPropery:attrString value:value propertyName:propertyName];
        }
    }
    if(properties) free(properties);
}

/**
 *  重置当前class 所有property 【不含父类property】
 */
- (void)resetPropertyFromClass:(Class)class
{
    //获取所有property
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        //property名称
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        //获取该property的数据类型
        const char *attries = property_getAttributes(property);
        NSString *attrString = [NSString stringWithUTF8String:attries];
        
        [self kSetPropery:attrString value:nil propertyName:propertyName];
    }
    if(properties) free(properties);
}


/**
 *  获取class中所有的 key - value 【不含父类property】
 */
- (NSMutableDictionary *)propertiesAndValuesFromClass:(Class)class
{
    NSMutableDictionary *props = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(class, &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char *char_f = property_getName(property);
        //property名称
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        //  若存在Value，则赋值给propertyName
        if ([self valueForKey:propertyName]) {
            [props setObject:[self valueForKey:propertyName] forKey:propertyName];
        }
    }
    if(properties) free(properties);
    return props;
}

/**
 *  获取properties 【不含父类property】
 *
 *  @return properties数组
 */
- (NSMutableArray *)curClassProperties
{
    
    NSMutableArray *props = [NSMutableArray array];
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (i = 0; i < outCount; i++)
    {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        //property名称
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        [props addObject:propertyName];
    }
    if(properties) free(properties);
    return props;
}


/**
 *  安全设置 value
 *
 *  @attriString    key的数据类型
 *  @value          值
 *  @propertyName   key名称
 */
- (void)kSetPropery:(NSString*)attriString
               value:(id)value
        propertyName:(NSString*)propertyName
{
    //kvc不支持c的数据类型，所以只能NSNumber转化，NSNumber可以  64位是TB
    if ([attriString hasPrefix:@"T@\"NSString\""]) {
        [self setValue:kToString(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Tc"] || [attriString hasPrefix:@"TB"]) {
        //32位Tc  64位TB
        [self setValue:[NSNumber numberWithBool:[value boolValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Ti"] || [attriString hasPrefix:@"Tq"]) {
        //32位 Ti是int 和 NSInteger  64位后，long 和  NSInteger 都是Tq， int 是Ti
        [self setValue:[NSNumber numberWithInteger:[kToString(value) integerValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"TQ"] || [attriString hasPrefix:@"TI"]) {
        [self setValue:[NSNumber numberWithInteger:[kToString(value) integerValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Tl"]) { //32位 long
        [self setValue:[NSNumber numberWithLongLong:[kToString(value) longLongValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Tf"]) { //float
        [self setValue:[NSNumber numberWithFloat:[kToString(value) floatValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"Td"]) { //CGFloat
        [self setValue:[NSNumber numberWithDouble:[kToString(value) doubleValue]] forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSMutableArray\""]) {
        [self setValue:kToMutableArray(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSArray\""]) {
        [self setValue:kToArray(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSDictionary\""]) {
        [self setValue:kToDictionary(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSMutableDictionary\""]) {
        [self setValue:kToMutableDictionary(value) forKey:propertyName];
    }
    else if ([attriString hasPrefix:@"T@\"NSNumber\""]) {
        [self setValue:@([kToString(value) integerValue]) forKey:propertyName];
    }
    else {
        //超出上面对象的范围
        [self autoSetNotSysClass:attriString value:value propertyName:propertyName];
    }
}


- (void)autoSetNotSysClass:(NSString*)attriString value:(id)value propertyName:(NSString*)propertyName{
    NSString *re = @"<\\S+>";
    NSRange range = [attriString rangeOfString:re options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {  //是protol的类型
        NSString *className = [[attriString substringWithRange:range] stringByReplacingOccurrencesOfString:@"<" withString:@""];
        //获取到class的名字
        className = [className stringByReplacingOccurrencesOfString:@">" withString:@""];
        Class cls = NSClassFromString(className);
        if (([attriString hasPrefix:@"T@\"NSArray<"] || [attriString hasPrefix:@"T@\"NSMutableArray<"])
            && [value isKindOfClass:[NSArray class]]
            && cls
            ) {
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *dic  in  value) {
                id obj = [cls new];
                [obj kAutoSetPropertySafety:kToDictionary(dic)];
                [array addObject:obj];
            }
            [self setValue:array forKey:propertyName];
            return ;
        }
    }
    
    NSString *re1 = @"T@\"\\S+\"";
    NSRange range1 = [attriString rangeOfString:re1 options:NSRegularExpressionSearch];
    if (range1.location != NSNotFound) {  //普通对象类型
        NSString *className = [[attriString substringWithRange:range1] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        //获取到class的名字
        className = [className stringByReplacingOccurrencesOfString:@"T@" withString:@""];
        Class cls = NSClassFromString(className);
        if (!cls) { //class不存在直接返回
            return;
        }
        //NSDictionary 上面已经处理，这里考虑的是class不是NSDictionary
        if ([value isKindOfClass:[NSDictionary class]]) {
            id obj = [cls new];
            [obj kAutoSetPropertySafety:value];
            [self setValue:obj forKey:propertyName];
            return;
        }
        //其他没有在- (void)kSetPropery:value:propertyName: 中的类型，如果对象和property对应，也设置
        if ([value isKindOfClass:cls]) {
            [self setValue:value forKey:propertyName];
        }
    }
    return;
}

#pragma mark - 遍历父类

/**
 *  遍历该class下的所有父类，直到系统类前 【第一个为 self class】
 */
+ (void)enumerateClasses:(void (^)(Class class, BOOL *stop))enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    // 2.停止遍历的标记
    BOOL stop = NO;
    // 3.当前正在遍历的类
    Class curClass = self;
    // 4.开始遍历每一个类
    while (curClass && !stop) {
        // 4.1.执行操作
        enumeration(curClass, &stop);
        // 4.2.获得父类
        curClass = class_getSuperclass(curClass);
        //  如果是系统类 就终止
        if ([self isFoundationClass:curClass]) {
            break;
        }
    }
}

/**
 *  继承于NSOject的系统类
 *
 *  @return 系统类集合
 */
- (NSSet *)foundationClassSet
{
    if (foundationClasses_ == nil) {
        // 集合中没有NSObject，因为几乎所有的类都是继承自NSObject，具体是不是NSObject需要特殊判断
        foundationClasses_ = [NSSet setWithObjects:
                              [NSURL class],
                              [NSDate class],
                              [NSValue class],
                              [NSData class],
                              [NSError class],
                              [NSArray class],
                              [NSDictionary class],
                              [NSString class],
                              [NSAttributedString class], nil];
    }
    return foundationClasses_;
}


/**
 *  是否是 系统类
 *
 *  @return BOOL
 */
- (BOOL)isFoundationClass:(Class)class
{
    //  如果直接是 NSObject ，绝对是系统类
    if (class == [NSObject class] ||
        class == [NSManagedObject class]) {
        return YES;
    }
    
    __block BOOL result = NO;
    [[self foundationClassSet] enumerateObjectsUsingBlock:^(Class foundationClass, BOOL *stop) {
        //  遍历定义集合，若发现是系统类，立即停止
        if ([class isSubclassOfClass:foundationClass]) {
            result = YES;
            *stop = YES;
        }
    }];
    return result;
}



- (NSString*)kJsonEncode {
    if ([self isKindOfClass:[NSArray class]] ||
        [self isKindOfClass:[NSMutableArray class]] ||
        [self isKindOfClass:[NSDictionary class]] ||
        [self isKindOfClass:[NSMutableDictionary class]]) {
        NSError *error = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                           options:NSJSONWritingPrettyPrinted
                                                             error:&error];
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return nil;
}

- (id)kObjectFortKeySafe:(NSString *)key {
    if ([self isKindOfClass:[NSDictionary class]] || [self isKindOfClass:[NSMutableDictionary class]]) {
        return [(NSDictionary*)self objectForKey:key];
    }
    return nil;
}

- (id)kObjectIndexSafe:(NSUInteger)index {
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSMutableArray class]]) {
        if (index < [(NSArray*)self count]) {
            return [(NSArray*)self objectAtIndex:index];
        }
        return nil;
    }
    return nil;
}

#pragma mark - appVersion

+ (NSString *)appVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDic objectForKey:@"CFBundleShortVersionString"];
    
    return appVersion;
}
@end


/**
 *  数据校验
 */
NSString* kToString(id obj) {
    return [obj isKindOfClass:[NSObject class]]?[NSString stringWithFormat:@"%@",obj]:@"";
}

NSArray* kToArray(id obj)  {
    return [obj isKindOfClass:[NSArray class]]?obj:nil;
}

NSDictionary* kToDictionary(id obj) {
    return [obj isKindOfClass:[NSDictionary class]]?obj:nil;
}

NSMutableArray* kToMutableArray(id obj)   {
    return [obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSMutableArray class]] ? [NSMutableArray arrayWithArray:obj] :nil;
}

NSMutableDictionary* kToMutableDictionary(id obj)  {
    return [obj isKindOfClass:[NSDictionary class]] || [obj isKindOfClass:[NSMutableDictionary class]] ? [NSMutableDictionary dictionaryWithDictionary:obj] : nil;
}

BOOL kIsNull(id value)
{
    if (!value) return YES;
    if ([value isKindOfClass:[NSNull class]]) return YES;
    if ([kToString(value) isEqualToString:@"null"]) return YES;
    
    return NO;
}

