//
//  KAddressBook.m
//  kToolDemo
//
//  Created by 曹翔 on 2018/6/21.
//  Copyright © 2018年 CX. All rights reserved.
//

#import "KAddressBook.h"

#import <AddressBook/AddressBook.h>

@implementation KAddressBook

#pragma mark -- 读取通讯录

+(NSMutableArray *)getAddressBook{
    
    
    int __block tip = 0;
    ABAddressBookRef addBook = nil;
    
    
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        addBook = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addBook, ^(bool granted, CFErrorRef error) {
            if (!granted) {
                tip = 1;
            } else {
                
            }
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    } else {
        addBook = ABAddressBookCreate();
    }
    
    if (tip) {
        return nil;
    }
    
    
    NSMutableArray * addrBookArr = [NSMutableArray array];
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
    CFIndex number = ABAddressBookGetPersonCount(addBook);
    
    for (int i=0; i<number; i++) {
        //获取联系人对象的引用
        ABRecordRef people = CFArrayGetValueAtIndex(allLinkPeople, i);
        //获取当前联系人名字
        NSString*firstName = (__bridge NSString*)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
    }
    
    
    
    
    return nil;
}

@end
