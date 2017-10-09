//
//  UIImage+Image.m
//  BuDeJie
//
//  Created by korwin on 2017/7/20.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "UIImage+Image.h"

@implementation UIImage (Image)

+ (UIImage *)imageOriginalWithNamed:(NSString *)imageName
{
    //渲染的图片
    UIImage *image = [UIImage imageNamed:imageName];
    //返回没有被渲染的图片
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
