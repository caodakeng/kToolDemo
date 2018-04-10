//
//  KRootTabBarController.m
//  kToolDemo
//
//  Created by 曹翔 on 2018/4/9.
//  Copyright © 2018年 CX. All rights reserved.
//

#import "KRootTabBarController.h"

#import "KHomeVC.h"
#import "KItemSecondVC.h"
#import "KItemThirdVC.h"
#import "KItemMeVC.h"
#import "KNavigationVC.h"



@interface KRootTabBarController ()

@end

@implementation KRootTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UITabBar appearance].tintColor = [UIColor redColor];
    [self addChildVC];
}

-(void)addChildVC{
    [self addChildVC:[[KHomeVC alloc] init] title:@"首页" index:0];
    [self addChildVC:[[KItemSecondVC alloc] init] title:@"第二页" index:1];
    [self addChildVC:[[KItemThirdVC alloc] init] title:@"第三页" index:2];
    [self addChildVC:[[KItemMeVC alloc] init] title:@"我的" index:3];
}

-(void)addChildVC:(UIViewController*)vc title:(NSString *)title index:(NSInteger)index{
    vc.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_item%ld_normal_img",index]];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:[NSString stringWithFormat:@"tabbar_item%ld_selected_img",index]];
    [self addChildViewController:[[KNavigationVC alloc] initWithRootViewController:vc]];
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
