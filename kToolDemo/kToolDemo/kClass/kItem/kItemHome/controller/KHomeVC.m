//
//  KHomeVC.m
//  kToolDemo
//
//  Created by 曹翔 on 2018/4/9.
//  Copyright © 2018年 CX. All rights reserved.
//

#import "KHomeVC.h"

@interface KHomeVC ()

@end

@implementation KHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = [self getStr];
    NSLog(@"%@",str);
}

-(NSString *)getStr{
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_queue_t quene = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSLog(@"0");
    dispatch_async(quene, ^{
        NSLog(@"00");
        sleep(1);
        NSLog(@"3");
        dispatch_semaphore_signal(sema);
        NSLog(@"4");
        sleep(1);
        NSLog(@"5");
        dispatch_semaphore_signal(sema);
        NSLog(@"6");
        
    });
    NSLog(@"1");
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"7");
    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    NSLog(@"8");
    dispatch_semaphore_wait(sema, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(NSEC_PER_SEC*10)));

    return @"qwer";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
