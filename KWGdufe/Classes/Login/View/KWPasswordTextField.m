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
    
    self.tintColor = [UIColor blueColor];
    
    self.keyboardType = UIKeyboardTypeDefault;
    
    [self addTarget:self action:@selector(textBgein) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
    
    return self;
}

- (void) textBgein
{

}

- (void) textEnd
{
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attrs];
}
@end
