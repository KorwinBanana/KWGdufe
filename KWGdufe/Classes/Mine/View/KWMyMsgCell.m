//
//  KWMyMsgCell.m
//  KWGdufe
//
//  Created by korwin on 2017/10/28.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWMyMsgCell.h"
#import "KWStuModel.h"
#import <Masonry/Masonry.h>
#import "KeychainWrapper.h"

@interface KWMyMsgCell()

@property (nonatomic,strong) UILabel *name;
@property (nonatomic,strong) UILabel *num;
@end

@implementation KWMyMsgCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        
        UIView *nameANumView = [[UIView alloc]init];
//        nameANumView.backgroundColor = [UIColor redColor];
        [self addSubview:nameANumView];
        
        UIView *imageView = [[UIView alloc]init];
//        imageView.backgroundColor = [UIColor blueColor];
        [self addSubview:imageView];
        
        [nameANumView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(10);
            make.left.equalTo(self.mas_left).with.offset(15);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
            make.width.mas_equalTo(@((self.bounds.size.width - 50)*0.75));
        }];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameANumView.mas_top);
            make.left.equalTo(nameANumView.mas_right).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-40);
            make.bottom.equalTo(nameANumView.mas_bottom);
        }];
        
        _name = [[UILabel alloc]init];
//        _name.backgroundColor = [UIColor blueColor];
        [_name setFont:[UIFont fontWithName:@"Helvetica-Bold" size:30]];
        [nameANumView addSubview:_name];
        
        _num = [[UILabel alloc]init];
//        _num.backgroundColor = [UIColor blueColor];
        _num.font = [UIFont systemFontOfSize:14];
        [nameANumView addSubview:_num];
        
        [_name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameANumView.mas_top);
            make.left.equalTo(nameANumView.mas_left).with.offset(0);
            make.right.equalTo(nameANumView.mas_right);
            make.height.mas_equalTo(40);
        }];
        
        [_num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_name.mas_bottom).with.offset(10);
            make.left.equalTo(nameANumView.mas_left).with.offset(0);
            make.right.equalTo(nameANumView.mas_right);
            make.bottom.equalTo(nameANumView.mas_bottom);
        }];
        
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"setup-head-default"]];
        [imageView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(imageView.mas_top);
            make.bottom.equalTo(imageView.mas_bottom);
            make.right.equalTo(imageView.mas_right);
//            make.left.equalTo(imageView.mas_left);
            make.width.mas_equalTo(68);
        }];
    }
    return self;
}

- (void)setModel:(KWStuModel *)model {
    _model = model;
    if (_model.name != nil) {
        _name.text = _model.name;
        
    } else {
        _name.text = @"你的名字是~";
    }
    NSString *number = [wrapper myObjectForKey:(id)kSecAttrAccount];
    if (number != nil) {
        _num.text = [NSString stringWithFormat:@"学号:%@",number];
    } else {
        _num.text = @"你的学号是~";
    }
}
@end
