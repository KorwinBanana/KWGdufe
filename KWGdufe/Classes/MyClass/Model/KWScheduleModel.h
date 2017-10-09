//
//  KWScheduleModel.h
//  KWGdufe
//
//  Created by korwin on 2017/10/8.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWScheduleModel : NSObject

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *teacher;
@property(nonatomic,copy)NSString *location;
@property(nonatomic,copy)NSString *period;
//@property(nonatomic,strong)NSString *colors;
@property(nonatomic,assign)NSInteger dayInWeek;
@property(nonatomic,assign)NSInteger startSec;
@property(nonatomic,assign)NSInteger endSec;

@end
