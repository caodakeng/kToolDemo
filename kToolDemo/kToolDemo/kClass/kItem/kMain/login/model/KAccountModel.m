//
//  KAccountModel.m
//  kToolDemo
//
//  Created by 曹翔 on 2018/4/9.
//  Copyright © 2018年 CX. All rights reserved.
//

#import "KAccountModel.h"

@interface KAccountModel()<NSCoding>

@end

@implementation KAccountModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"ID":@"id"};
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    return self;
}

- (void)encodeWithCoder:(nonnull NSCoder *)aCoder {
    [aCoder encodeObject:self.name forKey:@"name"];
}

@end

