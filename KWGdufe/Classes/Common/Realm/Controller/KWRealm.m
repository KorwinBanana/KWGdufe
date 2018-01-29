//
//  KWRealm.m
//  KWGdufe
//
//  Created by korwin on 2017/12/26.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWRealm.h"
#import <Realm/Realm.h>

@implementation KWRealm

+ (void)setDefaultRealmForUser:(NSString *_Nullable)dataBaseName {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    
    // 使用默认的目录，但是请将文件名替换为用户名
    config.fileURL = [[[config.fileURL URLByDeletingLastPathComponent]
                       URLByAppendingPathComponent:dataBaseName]
                      URLByAppendingPathExtension:@"realm"];
    
    // 将该配置设置为默认 Realm 配置
    [RLMRealmConfiguration setDefaultConfiguration:config];
}

+ (RLMRealm *)getRealmWith:(NSString *)dataBaseName {
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    
    // 使用默认的目录，但是请将文件名替换为用户名
    config.fileURL = [[[config.fileURL URLByDeletingLastPathComponent]
                       URLByAppendingPathComponent:dataBaseName]
                      URLByAppendingPathExtension:@"realm"];
    
    // 使用该配置来打开 Realm 数据库
    RLMRealm *realm = [RLMRealm realmWithConfiguration:config error:nil];
    
    return realm;
}

+ (void)saveRLMObject:(RLMRealm *)realm rlmObject:(nonnull RLMObject *)myData {
    [realm beginWriteTransaction];
    [realm addObject:myData];
    [realm commitWriteTransaction];
}

+ (void)deleteObject:(RLMRealm *)realm rlmObject:(nonnull RLMObject *)myData {
    [realm beginWriteTransaction];
    [realm deleteObject:myData];
    [realm commitWriteTransaction];
}

+ (void)deleteObjectWithArray:(RLMRealm *)realm array:(id)array {
    [realm beginWriteTransaction];
    [realm deleteObjects:array];
    [realm commitWriteTransaction];
}

+ (void)deleteAllObjects:(RLMRealm *)realm {
    [realm beginWriteTransaction];
    [realm deleteAllObjects];
    [realm commitWriteTransaction];
}

+ (void)addOrUpdateObject:(RLMRealm *)realm rlmObject:(nonnull RLMObject *)myData {
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:myData];
    [realm commitWriteTransaction];
}

+ (void)addOrUpdateObjectsFromArray:(RLMRealm *)realm array:(id)array {
    [realm beginWriteTransaction];
    [realm addOrUpdateObjectsFromArray:array];
    [realm commitWriteTransaction];
}

+ (void)updateWithrealm:(RLMRealm *)realm block:(void (^)(void))block {
    [realm beginWriteTransaction];
    block();
    [realm commitWriteTransaction];
}
@end
