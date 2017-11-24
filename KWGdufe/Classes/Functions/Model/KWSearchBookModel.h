//
//  KWSearchBookModel.h
//  KWGdufe
//
//  Created by korwin on 2017/11/22.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWSearchBookModel : NSObject

@property(nonatomic,strong) NSString *name;//书名
@property(nonatomic,strong) NSString *serial;//序列号
@property(nonatomic,assign) NSInteger numAll;//库藏总数量
@property(nonatomic,assign) NSInteger numCan;//可借数量
@property(nonatomic,strong) NSString *author;//作者
@property(nonatomic,strong) NSString *publisher;//出版社
@property(nonatomic,strong) NSString *macno;//查看书本详细信息时用到的id

@end
