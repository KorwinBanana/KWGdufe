//
//  KWReusableView.m
//  KWGdufe
//
//  Created by korwin on 2017/10/8.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWReusableView.h"
#import "Utils.h"

@implementation KWReusableView
-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame]){
        self.num = [[UILabel alloc] initWithFrame:self.bounds];
        _num.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_num];
        self.layer.borderWidth = 0.24;
        self.layer.borderColor = [Utils colorWithHexString:@"#696969"].CGColor;
    }
    return self;
}
@end
