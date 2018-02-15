//
//  KWAccountPwdTextField.m
//  KWGdufe
//
//  Created by korwin on 2017/12/9.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWAccountPwdTextField.h"

@implementation KWAccountPwdTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    self.tintColor = [UIColor blueColor];
    
    [self addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
    return self;
}

- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 11 && _snoOrPwd == 0) {
        textField.text = [textField.text substringToIndex:11];
    } else if (textField.text.length > 25 && _snoOrPwd == 1) {
        textField.text = [textField.text substringToIndex:25];
    }
}

- (void) textEnd
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
}

@end
