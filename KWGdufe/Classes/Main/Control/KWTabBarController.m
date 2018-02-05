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
    //获取整个应用程序下的UITabBarItem
    //    UITabBarItem *items = [UITabBarItem appearance];
    
    /*
     appearance:
     1.只有遵守了UIAppearance协议，还要实线这个方法
     2.哪些属性可以通过appearance设置，只有被UI_APPEARANCE_SELECTOR宏修饰的属性，才能设置
     3.只能在控件显示之前设置才有作用（夜间模式）
     */
    
    //获取哪个类中UITabBarItem，传递的参数是NSArry的class。
    UITabBarItem *items = [UITabBarItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    
    //设置按钮选中标题的颜色：富文本：描述一个字体的颜色，字体，阴影，空心，图文混排
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [items setTitleTextAttributes:attrs forState:UIControlStateSelected];
    
    //设置字体尺寸->只有设置正常状态下才会有效果
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
    //    self.tabBar = tabBar;
    
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
//    nav1.tabBarItem.title = @"课程";
    nav1.tabBarItem.image = [UIImage imageNamed:@"tabBar_essence_icon"];
    UIImage *image = [UIImage imageNamed:@"tabBar_essence_click_icon"];
    //返回没有被渲染的图片
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    nav1.tabBarItem.selectedImage = image;
    
    KWNavigationViewController *nav2 = self.childViewControllers[1];
//    nav2.tabBarItem.title = @"快捷";
    nav2.tabBarItem.image = [UIImage imageNamed:@"tabBar_friendTrends_icon"];
    nav2.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"tabBar_friendTrends_click_icon"];
    
    KWNavigationViewController *nav3 = self.childViewControllers[2];
//    nav3.tabBarItem.title = @"个人";
    nav3.tabBarItem.image = [UIImage imageNamed:@"tabBar_me_icon"];
    nav3.tabBarItem.selectedImage = [UIImage imageOriginalWithNamed:@"tabBar_me_click_icon"];
}

@end
