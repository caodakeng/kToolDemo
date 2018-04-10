//
//  KNavigationVC.m
//  kToolDemo
//
//  Created by 曹翔 on 2018/4/9.
//  Copyright © 2018年 CX. All rights reserved.
//

#import "KNavigationVC.h"

@interface KNavigationVC ()

@property(nonatomic, weak) UIViewController *currentVC;

@end

@implementation KNavigationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationBar setTintColor:White_COLOR_CODE];
}

// 拦截push方法进行操作
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    // 隐藏标签栏
    if (self.viewControllers.count > 0) {
        
        [viewController setHidesBottomBarWhenPushed:YES];
        
    }else{
        [viewController setHidesBottomBarWhenPushed:NO];
    }
    // 统一设置所有导航控制器的返回按钮样式
    self.topViewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [kKeyWindow endEditing:YES];
    
    [super pushViewController:viewController animated:animated];
}



- (BOOL)shouldAutorotate
{
    return self.topViewController.shouldAutorotate;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return self.orietation;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != self.orietation);
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
