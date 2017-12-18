//
//  KWBorrowCell.m
//  KWGdufe
//
//  Created by korwin on 2017/12/19.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWBorrowCell.h"
#import "KWCurrentModel.h"

@interface KWBorrowCell()

@property(nonatomic,strong) UILabel *name;
@property(nonatomic,strong) UILabel *author;
@property(nonatomic,strong) UILabel *borrowedTime;
@property(nonatomic,strong) UILabel *returnTime;
@property(nonatomic,strong) UILabel *renewTimes;
@property(nonatomic,strong) UILabel *barId;
@property(nonatomic,strong) UILabel *location;

@end

@implementation KWBorrowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UIView *view1 = [[UIView alloc]init];
        //                view1.backgroundColor = [UIColor blueColor];
        [self addSubview:view1];
        
        [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(22));
        }];
        
        UIView *view2 = [[UIView alloc]init];
        //                view2.backgroundColor = [UIColor redColor];
        [self addSubview:view2];
        
        [view2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view1.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(22));
        }];
        
        UIView *view3 = [[UIView alloc]init];
        //                view3.backgroundColor = [UIColor blueColor];
        [self addSubview:view3];
        
        [view3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view2.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            //            make.width.equalTo(@((self.bounds.size.width)/3));
            make.height.equalTo(@(22));
        }];
        
        //        NSLog(@"self.frame.size.width = %f",KWSCreenW);
        
        UIView *view4 = [[UIView alloc]init];
        //                view4.backgroundColor = [UIColor redColor];
        [self addSubview:view4];
        
        [view4 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view3.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(22));
        }];
        
        UIView *view6 = [[UIView alloc]init];
        //        view6.backgroundColor = [UIColor redColor];
        [self addSubview:view6];
        
        [view6 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view4.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(22));
        }];
        
        UIView *view7 = [[UIView alloc]init];
        //        view7.backgroundColor = [UIColor blueColor];
        [self addSubview:view7];
        
        [view7 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(view6.mas_bottom);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.height.equalTo(@(22));
        }];
        
        _name = [[UILabel alloc]init];
        [_name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
        [view1 addSubview:_name];
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view1.mas_left).with.offset(10);
            make.right.equalTo(view1.mas_right);
            make.centerY.mas_equalTo(view1.mas_centerY);
        }];
        
        _author = [[UILabel alloc]init];
        [_author setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [view2 addSubview:_author];
        [_author mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view2.mas_left).with.offset(10);
            make.right.equalTo(view1.mas_right);
            make.centerY.mas_equalTo(view2.mas_centerY);
        }];
        
        _borrowedTime = [[UILabel alloc]init];
        _borrowedTime.font = [UIFont systemFontOfSize:14];
        [view3 addSubview:_borrowedTime];
        [_borrowedTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view3.mas_left).with.offset(10);
            make.centerY.mas_equalTo(view3.mas_centerY);
        }];
        
        _returnTime = [[UILabel alloc]init];
        _returnTime.font = [UIFont systemFontOfSize:14];
        [view4 addSubview:_returnTime];
        [_returnTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view4.mas_left).with.offset(10);
            make.centerY.mas_equalTo(view4.mas_centerY);
        }];
        
        _barId = [[UILabel alloc]init];
        _barId.font = [UIFont systemFontOfSize:14];;
        [view6 addSubview:_barId];
        [_barId mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view6.mas_left).with.offset(10);
            make.centerY.mas_equalTo(view6.mas_centerY);
        }];
        
        _location = [[UILabel alloc]init];
        _location.font = [UIFont systemFontOfSize:14];
        [view7 addSubview:_location];
        [_location mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view7.mas_left).with.offset(10);
            make.centerY.mas_equalTo(view7.mas_centerY);
        }];
        
    }
    return self;
}

- (void)setModel:(KWCurrentModel *)model {
    _model = model;
    _name.text = model.name;
    _author.text = model.author;
    _borrowedTime.text = [NSString stringWithFormat:@"借阅时间:%@",model.borrowedTime];
    _returnTime.text = [NSString stringWithFormat:@"归还时间:%@",model.returnTime];
    _barId.text = [NSString stringWithFormat:@"条码号:%@",model.barId];
    _location.text = [NSString stringWithFormat:@"馆藏地:%@",model.location];
    
}

@end
