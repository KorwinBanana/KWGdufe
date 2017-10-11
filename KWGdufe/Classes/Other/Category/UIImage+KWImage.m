//
//  UIImage+KWImage.m
//  KWGdufe
//
//  Created by korwin on 2017/10/11.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "UIImage+KWImage.h"

@implementation UIImage (KWImage)

+ (UIImage *)imageOriginalWithNamed:(NSString *)imageName
{
    //渲染的图片
    UIImage *image = [UIImage imageNamed:imageName];
    //返回没有被渲染的图片
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

@end
