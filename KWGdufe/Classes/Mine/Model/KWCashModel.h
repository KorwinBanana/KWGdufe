//
//  KWCashModel.h
//  KWGdufe
//
//  Created by korwin on 2017/11/5.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KWCashModel : NSObject

@property(nonatomic,copy) NSString *cardNum;
@property(nonatomic,copy) NSString *cash;
@property(nonatomic,copy) NSString *cardState;
@property(nonatomic,copy) NSString *checkState;
@property(nonatomic,copy) NSString *lossState;
@property(nonatomic,copy) NSString *freezeState;

@end
