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
            make.left.equalTo(self.mas_left).with.offset(10);
            make.bottom.equalTo(self.mas_bottom).with.offset(-10);
            make.width.mas_equalTo(@((self.bounds.size.width - 30)*0.75));
        }];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameANumView.mas_top);
            make.left.equalTo(nameANumView.mas_right).with.offset(10);
            make.right.equalTo(self.mas_right).with.offset(-10);
            make.bottom.equalTo(nameANumView.mas_bottom);
        }];
        
        UILabel *name = [[UILabel alloc]init];
        name.text = @"你的名字";
//        name.backgroundColor = [UIColor blueColor];
        [nameANumView addSubview:name];
        
        UILabel *num = [[UILabel alloc]init];
        num.text = @"14251101256";
//        num.backgroundColor = [UIColor blueColor];
        [nameANumView addSubview:num];
        
        [name mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(nameANumView.mas_top);
            make.left.equalTo(nameANumView.mas_left).with.offset(10);
            make.right.equalTo(nameANumView.mas_right);
            make.height.mas_equalTo(40);
        }];
        
        [num mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(name.mas_bottom).with.offset(10);
            make.left.equalTo(nameANumView.mas_left).with.offset(10);
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

@end