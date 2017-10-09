//
//  KWMyClassCollectionCell.h
//  KWGdufe
//
//  Created by korwin on 2017/9/29.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KWScheduleModel.h"

@interface KWMyClassCollectionCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *schedule;
@property (nonatomic,strong) KWScheduleModel *model;

@end
