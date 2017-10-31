//
//  KWGradeCell.m
//  KWGdufe
//
//  Created by korwin on 2017/10/30.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWGradeCell.h"
#import "KWGradeModel.h"
#import <Masonry/Masonry.h>

@interface KWGradeCell()
@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *examType;
@property (nonatomic,strong) UILabel *dailyScore;
@property (nonatomic,strong) UILabel *paperScore;
@property (nonatomic,strong) UILabel *score;

@end

@implementation KWGradeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *view1 = [[UIView alloc]init];
//        view1.backgroundColor = [UIColor blueColor];
        [self addSubview:view1];
        
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(22));
        }];
        
        UIView *view2 = [[UIView alloc]init];
//        view2.backgroundColor = [UIColor redColor];
        [self addSubview:view2];

        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view1.mas_bottom);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-self.bounds.size.width/2);
            make.height.equalTo(@(22));
        }];

        UIView *view3 = [[UIView alloc]init];
//        view3.backgroundColor = [UIColor blueColor];
        [self addSubview:view3];

        [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view2.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right).with.offset(-(20 + 2 * (KWSCreenW-20)/3));
//            make.width.equalTo(@((self.bounds.size.width)/3));
            make.bottom.equalTo(self.mas_bottom);
        }];
        
//        NSLog(@"self.frame.size.width = %f",KWSCreenW);

        UIView *view4 = [[UIView alloc]init];
//        view4.backgroundColor = [UIColor redColor];
        [self addSubview:view4];

        [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view2.mas_bottom);
            make.left.equalTo(view3.mas_right).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(- (10 + (KWSCreenW-20)/3));
            make.bottom.equalTo(self.mas_bottom);
        }];
//
        UIView *view5 = [[UIView alloc]init];
//        view5.backgroundColor = [UIColor blueColor];
        [self addSubview:view5];

        [view5 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view2.mas_bottom);
            make.left.equalTo(view4.mas_right).with.offset(10);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom);
        }];
        
        _name = [[UILabel alloc]init];
        _name.text = @"我是帅哥";
        [view1 addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view1.mas_left).with.offset(10);
            make.top.equalTo(view1.mas_top);
//            make.height.equalTo(view1.mas_height);
        }];
        
        _examType = [[UILabel alloc]init];
        _examType.text = @"我是帅哥,你是吗？";
        [view2 addSubview:_examType];
        [_examType mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view2.mas_left);
            make.top.equalTo(view2.mas_top);
//            make.height.equalTo(view2.mas_height);
        }];
        
        _dailyScore = [[UILabel alloc]init];
        _dailyScore.text = @"平时：90";
        [view3 addSubview:_dailyScore];
        [_dailyScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view3.mas_centerX);
            make.centerY.mas_equalTo(view3.mas_centerY);
        }];
        
        _paperScore = [[UILabel alloc]init];
        _paperScore.text = @"期末：90";
        [view4 addSubview:_paperScore];
        [_paperScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view4.mas_centerX);
            make.centerY.mas_equalTo(view4.mas_centerY);
        }];
        
        _score = [[UILabel alloc]init];
        _score.text = @"总分：90";
        [view5 addSubview:_score];
        [_score mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view5.mas_centerX);
            make.centerY.mas_equalTo(view5.mas_centerY);
        }];
        
    }
    return self;
}

- (void)setModel:(KWGradeModel *)model {
    _model = model;
//    _name.text = KWGradeModel
    _name.text = _model.name;
    _examType.text = _model.examType;
    _dailyScore.text = [NSString stringWithFormat:@"平时分:%ld",(long)_model.dailyScore];
    _paperScore.text = [NSString stringWithFormat:@"期末:%ld",(long)_model.paperScore];
    _score.text = [NSString stringWithFormat:@"总分:%ld",(long)_model.score];
}

@end
