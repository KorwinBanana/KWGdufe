//
//  UIButton+KWButton.h
//  BuDeJie
//
//  Created by korwin on 2017/7/27.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (KWButton)

//自定义按钮
+ (UIButton *)buttonWithTitle:(NSString *)title titleColorN:(UIColor *)colorN titleColorH:(UIColor *)colorH image:(UIImage *)image hightImage:(UIImage *)hightImage target:(id)target action:(SEL)action;

+ (UIButton *)buttonStretWithTitle:(NSString *)title titleColorN:(UIColor *)colorN titleColorH:(UIColor *)colorH image:(UIImage *)image hightImage:(UIImage *)hightImage target:(id)target action:(SEL)action Cap:(float)cap;
@end
