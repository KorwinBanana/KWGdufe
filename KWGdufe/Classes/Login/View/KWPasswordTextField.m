//
//  KWPasswordTextField.m
//  KWGdufe
//
//  Created by korwin on 2017/12/15.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWPasswordTextField.h"

@implementation KWPasswordTextField
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    //1. 设置光标颜色为白色
    self.tintColor = [UIColor blueColor];
    
//    self.secureTextEntry = YES;// 密码模式,加密
    self.keyboardType = UIKeyboardTypeDefault;//设置键盘类型
    
    //2. 监听文本框编辑：1.代理 2.通知 3. target
    //原则不能成为自己代理
    [self addTarget:self action:@selector(textBgein) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
    return self;
}

- (void) textBgein
{
    //设置占位文字变成白色
    //    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    //    attrs[NSForegroundColorAttributeName] = [UIColor whiteColor];
    //    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
}

- (void) textEnd
{
    //设置占位文字变成白色
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
}
@end
