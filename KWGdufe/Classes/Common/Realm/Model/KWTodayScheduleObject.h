//
//  KWTodayScheduleObject.h
//  KWGdufe
//
//  Created by korwin on 2018/2/2.
//Copyright © 2018年 korwin. All rights reserved.
//

#import <Realm/Realm.h>

@interface KWTodayScheduleObject : RLMObject

@property(nonatomic,assign)NSInteger num;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *teacher;
@property(nonatomic,copy)NSString *location;
@property(nonatomic,copy)NSString *period;
@property(nonatomic,assign)NSInteger dayInWeek;
@property(nonatomic,assign)NSInteger startSec;
@property(nonatomic,assign)NSInteger endSec;

@end

// This protocol enables typed collections. i.e.:
// RLMArray<KWTodayScheduleObject *><KWTodayScheduleObject>
RLM_ARRAY_TYPE(KWTodayScheduleObject)
