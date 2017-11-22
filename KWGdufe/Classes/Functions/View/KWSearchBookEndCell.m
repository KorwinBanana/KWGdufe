//
//  KWSearchBookEndCell.m
//  KWGdufe
//
//  Created by korwin on 2017/11/22.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWSearchBookEndCell.h"
#import "KWSearchBookModel.h"

@interface KWSearchBookEndCell()

@property(nonatomic,strong) UILabel *name;
@property(nonatomic,strong) UILabel *author;
@property(nonatomic,strong) UILabel *publisher;
@property(nonatomic,strong) UILabel *num;

@end

@implementation KWSearchBookEndCell

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
        
        _publisher = [[UILabel alloc]init];
        _publisher.font = [UIFont systemFontOfSize:14];
        [view3 addSubview:_publisher];
        [_publisher mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view3.mas_left).with.offset(10);
            make.centerY.mas_equalTo(view3.mas_centerY);
        }];
        
        _num = [[UILabel alloc]init];
        _num.font = [UIFont systemFontOfSize:14];
        [view4 addSubview:_num];
        [_num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view4.mas_left).with.offset(10);
            make.centerY.mas_equalTo(view4.mas_centerY);
        }];
    }
    return self;
}

- (void)setModel:(KWSearchBookModel *)model {
    _model = model;
    _name.text = model.name;
    _author.text = model.author;
    _publisher.text = model.publisher;
    _num.text = [NSString stringWithFormat:@"可借/总数:%ld/%ld",(long)model.numCan,(long)model.numAll];
}

@end
