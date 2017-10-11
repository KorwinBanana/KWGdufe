//
//  KWMineCell.m
//  KWGdufe
//
//  Created by korwin on 2017/10/11.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWMineCell.h"

@interface KWMineCell()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *classroom;

@end

@implementation KWMineCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    [self setupModel];
    // Initialization code
}

- (void)setModel:(KWStuModel *)model {
    _model = model;
    _name.text = _model.name;
    _classroom.text = model.classroom;
}

@end
