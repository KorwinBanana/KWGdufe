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

@property (nonatomic,strong) UIView  *view;
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel  *className;
@property (nonatomic,strong) KWScheduleModel *model;

@end
