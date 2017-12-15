//
//  UIBarButtonItem+KWBarButtonItem.m
//  KWGdufe
//
//  Created by korwin on 2017/10/12.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "UIBarButtonItem+KWBarButtonItem.h"

@implementation UIBarButtonItem (KWBarButtonItem)

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

+ (UIBarButtonItem *) itemWithString:(NSString *)name target:( id)target action:(SEL)action
{
    //1.左边按钮
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:name forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];
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
    [backButton setImage:image forState:UIControlStateNormal];
    [backButton setImage:hightImage forState:UIControlStateHighlighted];
    [backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];//未选中的颜色
    [backButton setTitleColor:[UIColor blackColor] forState:UIControlStateHighlighted];//返回的选中title的颜色
    [backButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [backButton sizeToFit];
    backButton.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
    return [[UIBarButtonItem alloc]initWithCustomView:backButton];
}
@end
