//
//  KWSBookModel.h
//  KWGdufe
//
//  Created by korwin on 2017/11/23.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWSBookModel : NSObject

@property(nonatomic,strong) NSString *barId;//条码号
@property(nonatomic,strong) NSString *serial;//序列号
@property(nonatomic,strong) NSString *volume;//年卷期，有"-"，""的情况
@property(nonatomic,strong) NSString *location;//馆藏地
@property(nonatomic,strong) NSString *state;//可借状态

@end
