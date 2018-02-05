//
//  KWAPTextFieldCell.m
//  KWGdufe
//
//  Created by korwin on 2017/12/9.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWAPTextFieldCell.h"
#import "KWAccountPwdTextField.h"

@interface KWAPTextFieldCell()<UITextFieldDelegate>

@property (nonatomic,strong) NSMutableDictionary *attrs;

@end

@implementation KWAPTextFieldCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        _accountLogin = [[KWAccountPwdTextField alloc] init];
        _accountLogin.delegate = self;
        [self addSubview:_accountLogin];
        [_accountLogin mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.mas_left).with.offset(16);
            make.right.equalTo(self.mas_right).with.offset(-16);
        }];
    }
    return self;
}

- (void)setPlaceholderText:(NSString *)placeholderText {
    _placeholderText = placeholderText;
    //定义占位文默认颜色
    _attrs = [NSMutableDictionary dictionary];
    _attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    _accountLogin.borderStyle = UITextBorderStyleNone;
    _accountLogin.placeholder = _placeholderText;
    _accountLogin.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_accountLogin.placeholder attributes:_attrs];
}

@end
