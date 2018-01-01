//
//  KWRealm.h
//  KWGdufe
//
//  Created by korwin on 2017/12/26.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWRealm : NSObject

+ (void)setDefaultRealmForUser:(NSString *_Nullable)dataBaseName;//配置数据库
+ (RLMRealm *_Nullable)getRealmWith:(NSString *_Nullable)dataBaseName;//获取数据库

+ (void)saveRLMObject:(RLMRealm *_Nullable)realm rlmObject:(nonnull RLMObject *)myData;//存储数据

+ (void)deleteObject:(RLMRealm *_Nullable)realm rlmObject:(nonnull RLMObject *)myData;//删除指定数据

+ (void)deleteObjectWithArray:(RLMRealm *_Nullable)realm array:(id _Nullable )array;//删除一组数据

+ (void)deleteAllObjects:(RLMRealm *_Nullable)realm;//删除全部数据

+ (void)addOrUpdateObject:(RLMRealm *_Nullable)realm rlmObject:(nonnull RLMObject *)myData;//修改指定数据

+ (void)addOrUpdateObjectsFromArray:(RLMRealm *_Nullable)realm array:(id _Nullable )array;//修改一组数据

+ (void)updateWithrealm:(RLMRealm *_Nullable)realm block:(void (^_Nonnull)(void))block;//封装beginWriteTransaction跟commitWriteTransaction
@end
