//
//  KWNavigationController.m
//  KWGdufe
//
//  Created by korwin on 2017/9/28.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWNavigationViewController.h"

@interface KWNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation KWNavigationViewController

+ (void)load
{
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    //设置导航栏标题——富文本
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:19];
    [navBar setTitleTextAttributes:attrs];
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    //添加全屏滑动手势
    [self.view addGestureRecognizer:pan];
    //代理手势什么时候触发，只有非跟控制器才需要手势触发
    pan.delegate = self;
    //禁止之前的手势
    self.interactivePopGestureRecognizer.enabled = NO;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    //统一设置返回按钮，只有非根控制器
    if(self.childViewControllers.count > 0){//如果大于0，就是非根控制器。第一次meVc加进来是0
        
        viewController.hidesBottomBarWhenPushed = YES;//隐藏底部tabBar
        
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] hightImage:[UIImage imageNamed:@"navigationButtonReturn"] target:self action:@selector(back) title:@"返回"];
    }
    
    //真正在跳转
    [super pushViewController:viewController animated:animated];
}

//返回上一个控制器
-(void)back
{
    [self popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.childViewControllers.count > 1;
}

/*
 UIPanGestureRecognizer：全屏滑动手势
 UIScreenEdgePanGestureRecognizer：导航条的手势：边缘滑动手势，继承与UIPanGestureRecognizer
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
