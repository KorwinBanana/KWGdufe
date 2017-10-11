//
//  KWTabBar.m
//  KWGdufe
//
//  Created by korwin on 2017/10/11.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWTabBar.h"

@implementation KWTabBar

//添加中间按钮
//- (UIButton *) plusButton
//{
//    if (_plusButton == nil) {
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
//        [btn setImage:[UIImage imageNamed:@"tabBar_publish_Click_icon"] forState:UIControlStateHighlighted];
//        //调用sizeThatFits:以当前的视图边界和更改范围大小。
//        [btn sizeToFit];
//        [self addSubview:btn];
//        _plusButton = btn;
//    }
//    return _plusButton;
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.items.count;
    int i = 0;
    CGFloat btnW = self.KW_width / count;
    CGFloat btnH = self.KW_height;
    CGFloat x = 0;
    //跳转tabBar按钮位置
    //遍历子控件 调整布局
    for (UIView *tabBarButton in self.subviews) {
        if([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            x = i * btnW;
            tabBarButton.frame = CGRectMake(x, btnH/8, btnW, btnH);//设置tabBarButton的位置
            i++;
        }
    }
//    //调整发布按钮的位置
//    self.plusButton.center = CGPointMake(self.KW_width * 0.5, self.KW_height * 0.5);
}


@end
