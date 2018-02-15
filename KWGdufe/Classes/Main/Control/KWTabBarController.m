//
//  KWTabBarController.m
//  KWGdufe
//
//  Created by korwin on 2017/9/27.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWTabBarController.h"
#import "KWHomeMessageViewController.h"
#import "KWMyClassViewController.h"
#import "KWFunctionsViewController.h"
#import "KWMineViewController.h"
#import "KWNavigationViewController.h"
#import "UIImage+KWImage.h"
#import "KWTabBar.h"

@interface KWTabBarController ()

@end

@implementation KWTabBarController

+ (void)load
{
    UITabBarItem *items = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [items setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    NSMutableDictionary *attrsNor = [NSMutableDictionary dictionary];
    attrsNor[NSForegroundColorAttributeName] = [UIColor blackColor];
    attrsNor[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [items setTitleTextAttributes:attrs forState:UIControlStateNormal];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupAllChildViewController];
    
    [self setupAllTitleButton];
    
    [self setupTabBar];
    // Do any additional setup after loading the view.
    
}

#pragma mark - 自定义tabBar
- (void)setupTabBar
{
    KWTabBar *tabBar = [[KWTabBar alloc] init];
    
    [self setValue:tabBar forKey:@"tabBar"];
    
}

- (void)setupAllChildViewController
{
    KWHomeMessageViewController *fcVc = [[KWHomeMessageViewController alloc]init];
    KWNavigationViewController *nav1 = [[KWNavigationViewController alloc]initWithRootViewController:fcVc];
    
    [self addChildViewController:nav1];
    
    KWMyClassViewController *mcVc = [[KWMyClassViewController alloc]init];
    KWNavigationViewController *nav2 = [[KWNavigationViewController alloc]initWithRootViewController:mcVc];
    
    [self addChildViewController:nav2];
    
    KWMineViewController *mineVc = [[KWMineViewController alloc]init];
    KWNavigationViewController *nav3 = [[KWNavigationViewController alloc]initWithRootViewController:mineVc];
    
    [self addChildViewController:nav3];
}

- (void)setupAllTitleButton
{
    KWNavigationViewController *nav1 = self.childViewControllers[0];
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    UIImage *image = [UIImage imageNamed:@"tabBar_essence_click_icon"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem.selectedImage = image;
    
    KWNavigationViewController *nav2 = self.childViewControllers[1];
    nav2.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    nav2.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"tabBar_friendTrends_click_icon"];
    
    KWNavigationViewController *nav3 = self.childViewControllers[2];
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    nav3.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"tabBar_me_click_icon"];
}

@end
