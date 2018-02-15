//
//  KWTabBar.m
//  KWGdufe
//
//  Created by korwin on 2017/10/11.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWTabBar.h"
#import "Utils.h"

@implementation KWTabBar

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger count = self.items.count;
    int i = 0;
    CGFloat btnW = self.KW_width / count;
    CGFloat btnH = self.KW_height;
    NSLog(@"btnH = %lf",btnH);
    if (btnH == 83.00) {
        btnH = btnH - 17;
    }
    CGFloat x = 0;
    CGFloat tabBarButtonCenterY = btnH/8;
    if ([Utils getIsIpad]) {
        tabBarButtonCenterY = btnH/30;
    }
    NSLog(@"self.KW_height = %lf",self.KW_height);

    for (UIView *tabBarButton in self.subviews) {
        if([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")])
        {
            x = i * btnW;
            tabBarButton.frame = CGRectMake(x, tabBarButtonCenterY, btnW, btnH);
            i++;
        }
    }
}


@end
