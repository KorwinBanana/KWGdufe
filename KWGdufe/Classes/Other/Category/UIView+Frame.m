//
//  UIView+Frame.m
//  BuDeJie
//
//  Created by korwin on 2017/7/21.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

-(void)setKW_height:(CGFloat)KW_height
{
    CGRect rect = self.frame;
    rect.size.height = KW_height;
    self.frame = rect;
}

-(CGFloat)KW_height
{
    return self.frame.size.height;
}

-(void)setKW_width:(CGFloat)KW_width
{
    CGRect rect = self.frame;
    rect.size.width = KW_width;
    self.frame = rect;
}

-(CGFloat)KW_width
{
    return self.frame.size.width;
}

-(void)setKW_x:(CGFloat)KW_x
{
    CGRect rect = self.frame;
    rect.origin.x = KW_x;
    self.frame = rect;
}

-(CGFloat)KW_x
{
    return self.frame.origin.x;
}

-(void)setKW_y:(CGFloat)KW_y
{
    CGRect rect = self.frame;
    rect.origin.x = KW_y;
    self.frame = rect;
}

-(CGFloat)KW_y
{
    return self.frame.origin.y;
}

-(void)setKW_centerX:(CGFloat)KW_centerX
{
    CGPoint center = self.center;
    center.x = KW_centerX;
    self.center = center;
}

-(CGFloat)KW_centerX
{
    return self.center.x;
}

-(void)setKW_centerY:(CGFloat)KW_centerY
{
    CGPoint center = self.center;
    center.y = KW_centerY;
    self.center = center;
}

-(CGFloat)KW_centerY
{
    return self.center.y;
}

@end
