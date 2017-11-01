//
//  KWSztzCell.m
//  KWGdufe
//
//  Created by korwin on 2017/11/1.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWSztzCell.h"
#import "KWSztzModel.h"

@interface KWSztzCell()

@property(nonatomic,strong) UILabel *name;
@property(nonatomic,strong) UILabel *requireScore;
@property(nonatomic,strong) UILabel *score;

@end

@implementation KWSztzCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *view1 = [[UIView alloc]init];
//        view1.backgroundColor = [UIColor blueColor];
        [self addSubview:view1];
        
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(22));
        }];
        
        UIView *view2 = [[UIView alloc]init];
//        view2.backgroundColor = [UIColor blueColor];
        [self addSubview:view2];
        
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view1.mas_bottom).with.offset(10);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right).with.offset(-(10 + (KWSCreenW-10)/2));
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        }];
        
        //        NSLog(@"self.frame.size.width = %f",KWSCreenW);
        
        UIView *view3 = [[UIView alloc]init];
//          view3.backgroundColor = [UIColor redColor];
        [self addSubview:view3];
        
        [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view1.mas_bottom).with.offset(10);
            make.left.equalTo(view2.mas_right).with.offset(10);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
        }];
        
        _name = [[UILabel alloc] init];
        [view1 addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view1.mas_left);
            make.top.equalTo(view1.mas_top);
        }];
        
        _requireScore = [[UILabel alloc] init];
        [view2 addSubview:_requireScore];
        [_requireScore mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view2.mas_centerX);
            make.centerY.mas_equalTo(view2.mas_centerY);
        }];
        
        _score = [[UILabel alloc] init];
        [view3 addSubview:_score];
        [_score mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(view3.mas_centerX);
            make.centerY.mas_equalTo(view3.mas_centerY);
        }];
        
    }
    return self;
}

- (void)setModel:(KWSztzModel *)model {
    _model = model;
    _name.text = _model.name;
    _requireScore.text = [NSString stringWithFormat:@"所需学分:%@",_model.requireScore];
    _score.text = [NSString stringWithFormat:@"已修学分:%@",_model.score];;
}

@end
    
