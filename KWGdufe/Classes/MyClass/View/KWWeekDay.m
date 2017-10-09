//
//  KWWeekDay.m
//  KWGdufe
//
//  Created by korwin on 2017/10/8.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWWeekDay.h"
#import "Utils.h"

@interface KWWeekDay(){
    UILabel *day;
//    UILabel *week;
}
@end

@implementation KWWeekDay

-(instancetype)initWithFrame:(CGRect)frame{
    if(self=[super initWithFrame:frame])
    {
        [self setUp];
        self.backgroundColor = [Utils colorWithHexString:@"#FFFFFF"];//
        
    }
    return self;
}

-(void)setUp{
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    day=[[UILabel alloc] initWithFrame:CGRectMake(0, height/3, width, height/3)];
    day.textColor = [UIColor blackColor];//日期字体
    day.font = [UIFont systemFontOfSize:13];
    day.textAlignment = NSTextAlignmentCenter;
//    week = [[UILabel alloc] initWithFrame:CGRectMake(0, height/3+5, width, height/3*2-5)];
//    week.textAlignment = NSTextAlignmentCenter;
//    week.textColor = [UIColor blackColor];//黑色
    self.layer.borderWidth = 0.5;
    self.layer.borderColor = [Utils colorWithHexString:@"#696969"].CGColor;
    self.clipsToBounds = true;
    [self addSubview:day];
//    [self addSubview:week];
    
}

- (void)setDay:(NSString*)Day{
    day.text=Day;
//    week.text=Week;
}

@end
