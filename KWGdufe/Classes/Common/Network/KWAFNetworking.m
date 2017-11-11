//
//  KWAFNetworking.m
//  KWGdufe
//
//  Created by korwin on 2017/11/11.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWAFNetworking.h"
#import <AFNetworking/AFNetworking.h>

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
+ (void)postWithUrlString:(NSString *)urlString parameters:(NSDictionary *)parameters success:(HttpSuccess)success failure:(HttpFailure)failure{
    
    //创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //post请求
    [manager POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        //数据请求的进度
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

@end
