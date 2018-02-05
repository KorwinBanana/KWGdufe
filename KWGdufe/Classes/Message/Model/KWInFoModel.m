//
//  KWInFoModel.m
//  KWGdufe
//
//  Created by korwin on 2018/2/2.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWInFoModel.h"
#import <MJExtension/MJExtension.h>

@implementation KWInFoModel

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             // 模型属性: JSON key, MJExtension 会自动将 JSON 的 key 替换为你模型中需要的属性
             @"ID":@"id",
             @"descrip":@"description",
             };
}

@end
