//
//  KWSztzObject.h
//  KWGdufe
//
//  Created by korwin on 2017/12/26.
//Copyright © 2017年 korwin. All rights reserved.
//

#import <Realm/Realm.h>

@interface KWSztzObject : RLMObject
@property NSString *name;//素拓模块名
@property NSString *requireScore;//所需最少学分
@property NSString *score;//已修学分
@end

// This protocol enables typed collections. i.e.:
// RLMArray<KWSztzObject *><KWSztzObject>
RLM_ARRAY_TYPE(KWSztzObject)
