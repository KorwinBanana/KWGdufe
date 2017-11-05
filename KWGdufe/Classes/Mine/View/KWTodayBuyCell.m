//
//  KWTodayBuyCell.m
//  KWGdufe
//
//  Created by korwin on 2017/11/5.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWTodayBuyCell.h"
#import "KWTodayBuyModel.h"

@interface KWTodayBuyCell()

@property(nonatomic,strong) UILabel *time;
@property(nonatomic,strong) UILabel *shop;
@property(nonatomic,strong) UILabel *change;
@property(nonatomic,strong) UILabel *cash;

@end

@implementation KWTodayBuyCell

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
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(22));
        }];
        
        UIView *view3 = [[UIView alloc]init];
//        view3.backgroundColor = [UIColor blueColor];
        [self addSubview:view3];
        
        [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view2.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
//                        make.width.equalTo(@((self.bounds.size.width)/3));
            make.height.equalTo(@(22));
        }];
        
        //        NSLog(@"self.frame.size.width = %f",KWSCreenW);
        
        UIView *view4 = [[UIView alloc]init];
//        view4.backgroundColor = [UIColor redColor];
        [self addSubview:view4];
        
        [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view3.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(22));
        }];
        
        _time = [[UILabel alloc]init];
        [_time setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [view1 addSubview:_time];
        [_time mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view1.mas_left).with.offset(10);
            make.right.equalTo(view1.mas_right);
            make.centerY.mas_equalTo(view1.mas_centerY);
        }];
        
        _shop = [[UILabel alloc]init];
//        [_shop setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        _shop.font = [UIFont systemFontOfSize:14];
        [view2 addSubview:_shop];
        [_shop mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view2.mas_left).with.offset(10);
            make.right.equalTo(view1.mas_right);
            make.centerY.mas_equalTo(view2.mas_centerY);
        }];
        
        _change = [[UILabel alloc]init];
        _change.font = [UIFont systemFontOfSize:14];
        [view3 addSubview:_change];
        [_change mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view3.mas_left).with.offset(10);
            make.centerY.mas_equalTo(view3.mas_centerY);
        }];
        
        _cash = [[UILabel alloc]init];
        _cash.font = [UIFont systemFontOfSize:14];
        [view4 addSubview:_cash];
        [_cash mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view4.mas_left).with.offset(10);
            make.centerY.mas_equalTo(view4.mas_centerY);
        }];
    }
    return self;
}

- (void)setModel:(KWTodayBuyModel *)model {
    _model = model;
//    _time.text = [NSString stringWithFormat:@"交易时间:  %@",_model.time];
    _time.text = _model.time;
    _shop.text = [NSString stringWithFormat:@"交易商户：%@",_model.shop];
    _change.text = [NSString stringWithFormat:@"交易额：%@元",_model.change];
    _cash.text = [NSString stringWithFormat:@"校园卡余额：%@元",_model.cash];
}
@end
