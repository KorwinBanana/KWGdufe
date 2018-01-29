//
//  KWGradeObject.h
//  KWGdufe
//
//  Created by korwin on 2018/1/26.
//Copyright © 2018年 korwin. All rights reserved.
//

#import <Realm/Realm.h>

@interface KWGradeObject : RLMObject
@property(nonatomic,strong) NSString *name;//课程名
@property(nonatomic,strong) NSString *time;//学年学期，格式：2014-2015-2
@property(nonatomic,assign) NSInteger score;//总分，优良中差对应返回98，85，75，65
@property(nonatomic,assign) float credit;//学分，有0.5学分的情况，整数学分则为纯整数
@property(nonatomic,assign) NSInteger classCode;
@property(nonatomic,assign) NSInteger dailyScore;//平时成绩
@property(nonatomic,assign) NSInteger expScore;//实验成绩
@property(nonatomic,assign) NSInteger paperScore;//期末成绩
@property(nonatomic,strong) NSString *examType;//考试类型
@end

// This protocol enables typed collections. i.e.:
// RLMArray<KWGradeObject *><KWGradeObject>
RLM_ARRAY_TYPE(KWGradeObject)
