//
//  UIBarButtonItem+barButtonItem.h
//  BuDeJie
//
//  Created by korwin on 2017/7/21.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (barButtonItem)
//快速创建对象的方法
+ (UIBarButtonItem *) itemWithImage:(UIImage *)image hightImage:(UIImage *)hightImage target:( id)target action:(SEL)action;

+ (UIBarButtonItem *) itemWithImage:(UIImage *)image selectImage:(UIImage *)selectImage target:( id)target action:(SEL)action;

+ (UIBarButtonItem *) backItemWithImage:(UIImage *)image hightImage:(UIImage *)hightImage target:( id)target action:(SEL)action title:(NSString *)title;
@end
