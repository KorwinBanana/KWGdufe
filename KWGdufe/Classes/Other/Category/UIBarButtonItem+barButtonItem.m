//
//  UIBarButtonItem+barButtonItem.m
//  BuDeJie
//
//  Created by korwin on 2017/7/21.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "UIBarButtonItem+barButtonItem.h"

@implementation UIBarButtonItem (barButtonItem)

+ (UIBarButtonItem *) itemWithImage:(UIImage *)image hightImage:(UIImage *)hightImage target:( id)target action:(SEL)action
{
    //1.左边按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:hightImage forState:UIControlStateHighlighted];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    //把Button先包装成UIView，在把UIView包装成UIButtonItem
    UIView *containView = [[UIView alloc]initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    //把UIButton包装成UIButtonItem.就会导致按钮点击区域扩大，
    return [[UIBarButtonItem alloc]initWithCustomView:containView];
}

+ (UIBarButtonItem *) itemWithImage:(UIImage *)image selectImage:(UIImage *)selectImage target:( id)target action:(SEL)action
{
    //1.左边按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:image forState:UIControlStateNormal];
    [btn setImage:selectImage forState:UIControlStateSelected];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn sizeToFit];
    
    //把Button先包装成UIView，在把UIView包装成UIButtonItem
    UIView *containView = [[UIView alloc]initWithFrame:btn.bounds];
    [containView addSubview:btn];
    
    //把UIButton包装成UIButtonItem.就会导致按钮点击区域扩大，
    return [[UIBarButtonItem alloc]initWithCustomView:containView];
}

+ (UIBarButtonItem *) backItemWithImage:(UIImage *)image hightImage:(UIImage *)hightImage target:( id)target action:(SEL)action title:(NSString *)title
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setTitle:title forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    return [[UIBarButtonItem alloc]initWithCustomView:backButton];
}

@end
