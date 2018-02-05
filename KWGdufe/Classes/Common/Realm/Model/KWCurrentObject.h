//
//  KWCurrentObject.h
//  KWGdufe
//
//  Created by korwin on 2018/1/31.
//Copyright © 2018年 korwin. All rights reserved.
//

#import <Realm/Realm.h>

@interface KWCurrentObject : RLMObject

@property(nonatomic,strong)NSString *barId;//条码号
@property(nonatomic,strong)NSString *name;//书名
@property(nonatomic,strong)NSString *author;//作者
@property(nonatomic,strong)NSString *borrowedTime;//借阅时间
@property(nonatomic,strong)NSString *returnTime;//应归还时间
@property(nonatomic,assign)NSInteger renewTimes;//已续借次数
@property(nonatomic,strong)NSString *location;//馆藏地
@property(nonatomic,strong)NSString *checkId;//续借用到的码

@end

// This protocol enables typed collections. i.e.:
// RLMArray<KWCurrentObject *><KWCurrentObject>
RLM_ARRAY_TYPE(KWCurrentObject)
