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

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self=[super initWithFrame:frame]){
        self.view = [[UIView alloc] initWithFrame:CGRectMake(1, 1,CGRectGetWidth(frame)-2, CGRectGetHeight(frame)-2)];
        self.view.backgroundColor = [UIColor clearColor];
//        _view.layer.cornerRadius = 4;
//        _view.layer.masksToBounds = YES;
        [self addSubview:_view];
        
        //课程名
        self.name = [[UILabel alloc] init];
        _name.textAlignment = NSTextAlignmentCenter;
//        _name.font = [UIFont systemFontOfSize:12];
        [_name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        _name.numberOfLines = 0;
        _name.alpha = 1;
        _name.textColor = [UIColor whiteColor];
        [_view addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_view.mas_top);
            make.left.equalTo(_view.mas_left);
            make.right.equalTo(_view.mas_right);
            make.bottom.equalTo(_view.mas_bottom).with.offset(-(_view.bounds.size.height * 0.5));
        }];
        
        //上课地点
        self.className = [[UILabel alloc]init];
        _className.textAlignment = NSTextAlignmentCenter;
//        _className.font = [UIFont systemFontOfSize:12];
        [_className  setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12]];
        _className.numberOfLines = 0;
        _className.alpha = 1;
        _className.textColor = [UIColor whiteColor];
        [_view addSubview:_className];
        [_className mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_name.mas_bottom);
            make.left.equalTo(_view.mas_left);
            make.right.equalTo(_view.mas_right);
            make.bottom.equalTo(_view.mas_bottom);
        }];
    }
    return self;
}

- (void)setModel:(KWScheduleModel *)model{
    _model=model;
    _name.text = _model.name;
    _className.text = _model.location;
}

@end
