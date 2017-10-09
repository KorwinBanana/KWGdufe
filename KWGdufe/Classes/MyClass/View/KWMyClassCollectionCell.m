//
//  KWMyClassCollectionCell.m
//  KWGdufe
//
//  Created by korwin on 2017/9/29.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWMyClassCollectionCell.h"
#import "Utils.h"

@implementation KWMyClassCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame]){
        self.schedule = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame)-2, CGRectGetHeight(frame)-2)];
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        _schedule.layer.cornerRadius = 3;
        _schedule.layer.masksToBounds =YES;
        [self addSubview:_schedule];
    }
    return self;
}

- (void)setModel:(KWScheduleModel *)model{
    _model=model;
    _schedule.text = model.name;
    _schedule.font = [UIFont systemFontOfSize:12];
    _schedule.numberOfLines = 0;
    _schedule.backgroundColor = [UIColor whiteColor];
//    if(![model.colors isEqualToString:@"#f5f5f5"])
        _schedule.textColor = [UIColor blackColor];
    _schedule.alpha = 1;
//    _schedule.backgroundColor = [Utils colorWithHexString:model.colors];
    _schedule.backgroundColor = [UIColor whiteColor];
}


@end
