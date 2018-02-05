//
//  AppDelegate.m
//  KWGdufe
//
//  Created by korwin on 2017/9/27.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "AppDelegate.h"
#import "KWIntroduceViewController.h"
#import "KWTabBarController.h"
#import "NSData+KWAES.h"
#import "KeychainWrapper.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "KWRealm.h"
#import "KWTodayScheduleObject.h"
#import "KWScheduleModel.h"
#import "Utils.h"

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

static NSString *stuTime;
static NSInteger badgeInt = 1;

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];//设置APPHUD样式
    if (![KWRealm getRealmWith:GdufeDataBase]) {
        [KWRealm setDefaultRealmForUser:GdufeDataBase];
    }

    //初始化通知
    //清楚角标和通知列表
    NSArray* scheduledNotifications = [NSArray arrayWithArray:application.scheduledLocalNotifications];
    application.scheduledLocalNotifications = scheduledNotifications;
    [application setApplicationIconBadgeNumber:0];
    badgeInt = 1;
    // 注册通知
    [self replyPushNotificationAuthorization:application];
    
    [self createLocalizedUserNotificationOfClass];
    [self createLocalizedUserNotificationOfMoney];
    [self createLocalizedUserNotificationOfMyBBooks];
    
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
//        KWLoginViewController *loginVc = [[KWLoginViewController alloc]init];
        KWIntroduceViewController *loginVc = [[KWIntroduceViewController alloc]init];
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
    //清楚角标和通知列表 && app换到后台时需要执行的操作
    NSArray* scheduledNotifications = [NSArray arrayWithArray:application.scheduledLocalNotifications];
    application.scheduledLocalNotifications = scheduledNotifications;
    [application setApplicationIconBadgeNumber:0];
    badgeInt = 1;
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

#pragma mark - 申请通知权限
// 申请通知权限
- (void)replyPushNotificationAuthorization:(UIApplication *)application{
    
    if (IOS10_OR_LATER) {
        //iOS 10 later
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        //必须写代理，不然无法监听通知的接收与点击事件
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error && granted) {
                //用户点击允许
                NSLog(@"注册成功");
            }else{
                //用户点击不允许
                NSLog(@"注册失败");
            }
        }];
        
        // 可以通过 getNotificationSettingsWithCompletionHandler 获取权限设置
        //之前注册推送服务，用户点击了同意还是不同意，以及用户之后又做了怎样的更改我们都无从得知，现在 apple 开放了这个 API，我们可以直接获取到用户的设定信息了。注意UNNotificationSettings是只读对象哦，不能直接修改！
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            NSLog(@"========%@",settings);
        }];
    }else if (IOS8_OR_LATER){
        //iOS 8 - iOS 10系统
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
        [application registerUserNotificationSettings:settings];
    }else{
        //iOS 8.0系统以下
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound];
    }
    
    //注册远端消息通知获取device token
    [application registerForRemoteNotifications];
}

#pragma mark - iOS10 收到通知（本地和远端） UNUserNotificationCenterDelegate
//App处于前台接收通知时
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    //收到推送的请求
    UNNotificationRequest *request = notification.request;
    
    //收到推送的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    
    //收到推送消息body
    NSString *body = content.body;
    
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    // 推送消息的标题
    NSString *title = content.title;
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        
    }else {
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n___%ld}",body,title,subtitle,badge,sound,userInfo,badgeInt);
    }
    
    // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
    completionHandler(UNNotificationPresentationOptionBadge|
                      UNNotificationPresentationOptionSound|
                      UNNotificationPresentationOptionAlert);
    
}

//App通知的点击事件
//这个代理方法，只会是用户点击消息才会触发，如果使用户长按（3DTouch）、弹出Action页面等并不会触发。点击Action的时候会触发！
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{
    //收到推送的请求
    UNNotificationRequest *request = response.notification.request;
    
    //收到推送的内容
    UNNotificationContent *content = request.content;
    
    //收到用户的基本信息
    NSDictionary *userInfo = content.userInfo;
    
    //收到推送消息的角标
    NSNumber *badge = content.badge;
    
    //收到推送消息body
    NSString *body = content.body;
    
    //推送消息的声音
    UNNotificationSound *sound = content.sound;
    
    // 推送消息的副标题
    NSString *subtitle = content.subtitle;
    
    // 推送消息的标题
    NSString *title = content.title;
    
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        NSLog(@"iOS10 收到远程通知:%@",userInfo);
        //此处省略一万行需求代码。。。。。。
        
    }else {
        // 判断为本地通知
        //此处省略一万行需求代码。。。。。。
        NSLog(@"iOS10 收到本地通知:{\\\\nbody:%@，\\\\ntitle:%@,\\\\nsubtitle:%@,\\\\nbadge：%@，\\\\nsound：%@，\\\\nuserInfo：%@\\\\n___%ld}",body,title,subtitle,badge,sound,userInfo,badgeInt);
    }
    
    //2016-09-27 14:42:16.353978 UserNotificationsDemo[1765:800117] Warning: UNUserNotificationCenter delegate received call to -userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler: but the completion handler was never called.
    completionHandler(); // 系统要求执行这个方法
}

#pragma mark -iOS 10之前收到通知

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"iOS6及以下系统，收到通知:%@", userInfo);
    //此处省略一万行需求代码。。。。。。
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSLog(@"iOS7及以上系统，收到通知:%@", userInfo);
    completionHandler(UIBackgroundFetchResultNewData);
    //此处省略一万行需求代码。。。。。。
}

//定时推送
- (void)createLocalizedUserNotificationOfMyBBooks {
    
    // 设置触发条件 UNNotificationTrigger
    UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:10.0f repeats:NO];
    
    //在每周一的14点3分提醒
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.weekday = 0;
    components.hour = 22;
    components.minute = 30;
    // components 日期
    UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    
    // 创建通知内容 UNMutableNotificationContent, 注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"图书馆";
    content.body =  [NSString stringWithFormat:@"截止今日，您共借阅图书%@本。",[Utils getCache:gdufeAccount andID:@"MyBBooks"]];
    content.badge = [NSNumber numberWithInteger:badgeInt++];
    content.sound = [UNNotificationSound defaultSound];
    content.userInfo = @{@"key1":@"value1",@"key2":@"value2"};
    
    // 创建通知标示
    NSString *requestIdentifier = @"Dely.MyBBooks.time";
    
    // 创建通知请求 UNNotificationRequest 将触发条件和通知内容添加到请求中
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:calendarTrigger];
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    // 将通知请求 add 到 UNUserNotificationCenter
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"推送已添加成功 %@ %ld", requestIdentifier,badgeInt);
//            badgeInt++;
            //此处省略一万行需求。。。。
        }
    }];
    
}

- (void)createLocalizedUserNotificationOfMoney {
    
    // 设置触发条件 UNNotificationTrigger
    UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3.0f repeats:NO];
    
    //在每天21：30提醒
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = 21;
    components.minute = 30;
    // components 日期
    UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    
    // 创建通知内容 UNMutableNotificationContent, 注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
    content.title = @"一卡通";
    content.body = [NSString stringWithFormat:@"截止今日，您的校园卡余额是%@元",[Utils getCache:gdufeAccount andID:@"Money"]];
    content.badge = [NSNumber numberWithInteger:badgeInt++];
    content.sound = [UNNotificationSound defaultSound];
    content.userInfo = @{@"key1":@"value1",@"key2":@"value2"};
    
    // 创建通知标示
    NSString *requestIdentifier = @"Dely.Money.time";
    
    // 创建通知请求 UNNotificationRequest 将触发条件和通知内容添加到请求中
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:calendarTrigger];
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    // 将通知请求 add 到 UNUserNotificationCenter
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"推送已添加成功 %@ %ld", requestIdentifier,badgeInt);
        }
    }];
    
}

- (void)createLocalizedUserNotificationOfClass {
    
    //读取数据库
    //使用数据库获取
    RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
    RLMResults *results = [KWTodayScheduleObject allObjectsInRealm:real];
//    NSInteger dataCount = [KWRealm getNumOfLine:results];
    NSMutableArray *arraySchedule = [NSMutableArray array];
    for (RLMObject *object in results) {
        KWScheduleModel *todayModel = object;
        if (todayModel.dayInWeek == [Utils getNowWeekday]+1) {
            [arraySchedule addObject:object];
        }
    }
    
    
    // 设置触发条件 UNNotificationTrigger
    UNTimeIntervalNotificationTrigger *timeTrigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:3.0f repeats:NO];
    
    //在每天19：30提醒
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = 19;
    components.minute = 30;
    // components 日期
    UNCalendarNotificationTrigger *calendarTrigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:YES];
    
    // 创建通知内容 UNMutableNotificationContent, 注意不是 UNNotificationContent ,此对象为不可变对象。
    UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
//    content.title = @"明日课程";
    content.title = [NSString stringWithFormat:@"明天有%ld节课。",arraySchedule.count];
    
    //获取课程具体
    NSString *classArrayName = [[NSString alloc]init];
    for (int i = 0; i<arraySchedule.count; i++) {
        KWScheduleModel *oneClassModel = arraySchedule[i];
        classArrayName = [NSString stringWithFormat:@"%@%@(第%ld-%ld节)",classArrayName,oneClassModel.name,oneClassModel.startSec,oneClassModel.endSec];
        if (i < arraySchedule.count - 1) {
            classArrayName = [NSString stringWithFormat:@"%@\n",classArrayName];
        }
    }
    
    content.body = classArrayName;
    content.badge = [NSNumber numberWithInteger:badgeInt++];
    content.sound = [UNNotificationSound defaultSound];
    content.userInfo = @{@"key1":@"value1",@"key2":@"value2"};
    
    // 创建通知标示
    NSString *requestIdentifier = @"Dely.Class.time";
    
    // 创建通知请求 UNNotificationRequest 将触发条件和通知内容添加到请求中
    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:requestIdentifier content:content trigger:calendarTrigger];
    
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    // 将通知请求 add 到 UNUserNotificationCenter
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"推送已添加成功 %@ %ld", requestIdentifier,badgeInt);
        }
    }];
    
}

@end
