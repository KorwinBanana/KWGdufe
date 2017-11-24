//
//  KWSBookShowCell.m
//  KWGdufe
//
//  Created by korwin on 2017/11/24.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWSBookShowCell.h"
#import "KWSBookModel.h"

@interface KWSBookShowCell()

@property(nonatomic,strong) UILabel *location;
@property(nonatomic,strong) UILabel *serial;
@property(nonatomic,strong) UILabel *state;

@end

@implementation KWSBookShowCell

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
        
        _location = [[UILabel alloc]init];
        [_location setFont:[UIFont systemFontOfSize:14]];
        [view1 addSubview:_location];
        [_location mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view1.mas_left).with.offset(10);
            make.right.equalTo(view1.mas_right);
            make.centerY.mas_equalTo(view1.mas_centerY);
        }];
        
        _serial = [[UILabel alloc]init];
        [_serial setFont:[UIFont systemFontOfSize:14]];
        [view2 addSubview:_serial];
        [_serial mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view2.mas_left).with.offset(10);
            make.right.equalTo(view1.mas_right);
            make.centerY.mas_equalTo(view2.mas_centerY);
        }];
        
        _state = [[UILabel alloc]init];
        _state.font = [UIFont systemFontOfSize:14];
        [view3 addSubview:_state];
        [_state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(view3.mas_left).with.offset(10);
            make.centerY.mas_equalTo(view3.mas_centerY);
        }];
    }
    return self;
}

- (void)setModel:(KWSBookModel *)model {
    _model = model;
    _location.text = model.location;
    _serial.text = model.serial;
    _state.text = model.state;
//    _num.text = [NSString stringWithFormat:@"可借/总数:%ld/%ld",(long)model.numCan,(long)model.numAll];
}
@end
