//
//  KWAFNetworking.m
//  KWGdufe
//
//  Created by korwin on 2017/11/11.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWAFNetworking.h"
#import <AFNetworking/AFNetworking.h>
#import "Utils.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import <MJRefresh/MJRefresh.h>

@implementation KWAFNetworking

//GET请求
+ (void)getWithUrlString:(NSString *)urlString success:(HttpSuccess)success failure:(HttpFailure)failure{
    //创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    //内容类型
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html", nil];
    
    //get请求
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

//POST请求
+ (void)postWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure {
    
    //创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
    
}

//POST请求
+ (void)postWithUrlString:(NSString *)urlString vController:(UIViewController *)vController parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure noNetworking:(HttpNoNetworking) noNetworking{
    //异步处理网络请求
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        //创建请求管理者
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        //创建网络状态监测管理者
        AFNetworkReachabilityManager *networkManager = [AFNetworkReachabilityManager sharedManager];
        
        //监听改变
        [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus  status) {
            switch (status) {
                case  AFNetworkReachabilityStatusUnknown: {
                    NSLog(@"未知");
                    [Utils showDismissWithTitle:@"未知网络" message:nil parent:vController time:1];
                    [SVProgressHUD dismiss];
                    noNetworking();
                    break;
                }
                case AFNetworkReachabilityStatusNotReachable:{
                    NSLog(@"没有网络");
                    [Utils showDismissWithTitle:@"没有网络" message:nil parent:vController time:1];
                    [SVProgressHUD dismiss];
                    noNetworking();
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWWAN: {
                    NSLog(@"3G|4G");
                    //post请求
                    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                        //数据请求的进度
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        success(responseObject);
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        failure(error);
                    }];
                    break;
                }
                case AFNetworkReachabilityStatusReachableViaWiFi: {
                    NSLog(@"WiFi");
                    //post请求
                    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
                        //数据请求的进度
                    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                        success(responseObject);
                    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                        failure(error);
                    }];
                    break;
                }
                default:
                    break;
            }
        }];
        [networkManager startMonitoring];//开始监听
    });
}

#pragma mark - NetWorkingByAFNetWorking
//网络监听
+ (void)iSNetWorkingWithController:(UIViewController *)vController isNetworking:(HttpIsNetworking)isNetworking noNetworking:(HttpNoNetworking) noNetworking {
    //创建网络状态监测管理者
    AFNetworkReachabilityManager *networkManager = [AFNetworkReachabilityManager sharedManager];
    
    //监听改变
    [networkManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus  status) {
        switch (status) {
            case  AFNetworkReachabilityStatusUnknown: {
                NSLog(@"未知");
                [Utils showDismissWithTitle:@"未知网络" message:nil parent:vController time:1];
                noNetworking();
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"没有网络");
                [Utils showDismissWithTitle:@"没有网络" message:nil parent:vController time:1];
                noNetworking();
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                NSLog(@"3G|4G");
                //post请求
                isNetworking();
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"WiFi");
                //post请求
                isNetworking();
                break;
            }
            default:
                break;
        }
    }];
    [networkManager startMonitoring];//开始监听
}

@end
