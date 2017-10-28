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
        self.name = [[UILabel alloc] initWithFrame:CGRectMake(1, 1,CGRectGetWidth(frame)-2, CGRectGetHeight(frame)-2)];
        self.backgroundColor = [UIColor clearColor];
        _name.layer.cornerRadius = 4;
        _name.layer.masksToBounds = YES;
        _name.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_name];
    }
    return self;
}

- (void)setModel:(KWScheduleModel *)model{
    _model=model;
    _name.text = [NSString stringWithFormat:@"%@\n\n%@",model.name,model.location];
    _name.font = [UIFont systemFontOfSize:12];
    _name.numberOfLines = 0;
    //    if(![model.colors isEqualToString:@"#f5f5f5"])
    _name.textColor = [UIColor whiteColor];
    _name.alpha = 1;

}


@end
