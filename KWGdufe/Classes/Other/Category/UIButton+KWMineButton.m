//
//  UIButton+KWMineButton.m
//  KWGdufe
//
//  Created by korwin on 2017/12/9.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "UIButton+KWMineButton.h"

@implementation UIButton (KWMineButton)

//设置带按钮标题，按钮背景图片，跳转的按钮
+ (UIButton *)buttonWithTitle:(NSString *)title titleColorN:(UIColor *)colorN titleColorH:(UIColor *)colorH image:(UIImage *)image hightImage:(UIImage *)hightImage target:(id)target action:(SEL)action
{
    //    //设置图片不要拉伸
    //    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.width * 0.5];
    //    hightImage = [image stretchableImageWithLeftCapWidth:hightImage.size.width * 0.5 topCapHeight:hightImage.size.width * 0.5];
    
    UIButton *toLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toLoginBtn setTitle:title forState:UIControlStateNormal];
    [toLoginBtn setTitleColor:colorN forState:UIControlStateNormal];
    [toLoginBtn setTitleColor:colorH forState:UIControlStateHighlighted];
    [toLoginBtn setBackgroundImage: image forState:UIControlStateNormal];
    [toLoginBtn setBackgroundImage:hightImage forState:UIControlStateHighlighted];
    [toLoginBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return toLoginBtn;
}

//按钮背景图片未拉伸 利用Cap设置
+ (UIButton *)buttonStretWithTitle:(NSString *)title titleColorN:(UIColor *)colorN titleColorH:(UIColor *)colorH image:(UIImage *)image hightImage:(UIImage *)hightImage target:(id)target action:(SEL)action Cap:(float)cap
{
    //设置图片不要拉伸
    image = [image stretchableImageWithLeftCapWidth:image.size.width * cap topCapHeight:image.size.width * cap];
    hightImage = [hightImage stretchableImageWithLeftCapWidth:hightImage.size.width * cap topCapHeight:hightImage.size.width * cap];
    
    UIButton *toLoginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [toLoginBtn setTitle:title forState:UIControlStateNormal];
    [toLoginBtn setTitleColor:colorN forState:UIControlStateNormal];
    [toLoginBtn setTitleColor:colorH forState:UIControlStateHighlighted];
    [toLoginBtn setBackgroundImage: image forState:UIControlStateNormal];
    [toLoginBtn setBackgroundImage:hightImage forState:UIControlStateHighlighted];
    [toLoginBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return toLoginBtn;
}

@end
