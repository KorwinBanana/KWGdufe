//
//  AppDelegate.m
//  KWGdufe
//
//  Created by korwin on 2017/9/27.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "AppDelegate.h"
#import "KWLoginViewController.h"
#import "KWTabBarController.h"
#import "NSData+KWAES.h"
#import "KeychainWrapper.h"
#import <UserNotifications/UserNotifications.h>

static NSString *stuTime;

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

/*
 *开始界面优化。
 */

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    //通知
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //监听回调事件
    center.delegate = self;
    
    //iOS 10 使用以下方法注册，才能得到授权，注册通知以后，会自动注册 deviceToken，如果获取不到 deviceToken，Xcode8下要注意开启 Capability->Push Notification。
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert + UNAuthorizationOptionSound)
                          completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              // Enable or disable features based on authorization.
                          }];
    
    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
    }];
    
    //初始化窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    //初始化stuTime
    stuTime = @"2015-2016-2";
    
    //检测是否存在用户名和密码
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSData *encryptedData  = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
//    NSString *pwd = [[NSString alloc] initWithData:[encryptedData DecryptAES:uuid] encoding:NSUTF8StringEncoding];
    
    //KeychainWrapper
    NSString *sno = [wrapper myObjectForKey:(id)kSecAttrAccount];
    if (![sno isEqualToString:@"Account"]) {
        //设置窗口控制器为主界面
        KWTabBarController *tabVc = [[KWTabBarController alloc]init];
        self.window.rootViewController = tabVc;//设置根控制器
    } else {
        //Load Login View if no username is found
        //设置窗口控制器为登陆View
        KWLoginViewController *loginVc = [[KWLoginViewController alloc]init];
        self.window.rootViewController = loginVc;//设置根控制器
    }

    //3.显示窗口 1.成为UIApplication主窗口 2.
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
