//
//  KWAFNetworking.h
//  KWGdufe
//
//  Created by korwin on 2017/11/11.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <Foundation/Foundation.h>

//宏定义成功block 回调成功后得到的信息
typedef void (^HttpSuccess)(id data);
//宏定义失败block 回调失败信息
typedef void (^HttpFailure)(NSError *error);
//无网络
typedef void (^HttpNoNetworking)(void);
//有网络
typedef void (^HttpIsNetworking)(void);

@interface KWAFNetworking : NSObject

//get请求
+(void)getWithUrlString:(NSString *)urlString success:(HttpSuccess)success failure:(HttpFailure)failure;

//post请求
+ (void)postWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure;

+ (void)postWithUrlString:(NSString *)urlString vController:(UIViewController *)vController parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure noNetworking:(HttpNoNetworking) noNetworking;

+ (void)iSNetWorkingWithController:(UIViewController *)vController isNetworking:(HttpIsNetworking)isNetworking noNetworking:(HttpNoNetworking) noNetworking;

@end
