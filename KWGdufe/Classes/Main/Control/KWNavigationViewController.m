//
//  KWNavigationController.m
//  KWGdufe
//
//  Created by korwin on 2017/9/28.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWNavigationViewController.h"
#import "Utils.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface KWNavigationViewController ()<UIGestureRecognizerDelegate>

@end

@implementation KWNavigationViewController

+ (void)load
{
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:19];
    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:attrs];
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackground4671172"] forBarMetrics:UIBarMetricsDefault];
    navBar.translucent = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    [self.view addGestureRecognizer:pan];
    pan.delegate = self;
    self.interactivePopGestureRecognizer.enabled = NO;
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if(self.childViewControllers.count > 0){
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithImage:[UIImage imageNamed:@"navigationButtonReturn"] hightImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) title:@"返回"];
    }
    [super pushViewController:viewController animated:animated];
}

-(void)back
{
    [SVProgressHUD dismiss];
    [self popViewControllerAnimated:YES];
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.childViewControllers.count > 1;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
