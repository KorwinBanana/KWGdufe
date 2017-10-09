//
//  UIView+Frame.h
//  BuDeJie
//
//  Created by korwin on 2017/7/21.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 写分类：避免与其他开发者冲突
 */
@interface UIView (Frame)

@property CGFloat KW_width;
@property CGFloat KW_height;
@property CGFloat KW_x;
@property CGFloat KW_y;
@property CGFloat KW_centerX;
@property CGFloat KW_centerY;

@end
