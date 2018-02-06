//
//  KWFunctionsCell.m
//  KWGdufe
//
//  Created by korwin on 2017/10/26.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWFunctionsCell.h"
#import "Utils.h"

@interface KWFunctionsCell()
//@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *iconName;
@property (weak, nonatomic) IBOutlet UIView *backView;
@end

@implementation KWFunctionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    //设置阴影和圆角
    self.backView.layer.cornerRadius = 3;
    self.backView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(2, 1.5);
    self.backView.layer.shadowOpacity = 0.15;
    self.backView.layer.shadowRadius = 1.5;
    
    [_iconName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:13]];
    [_iconName setTextColor:[UIColor whiteColor]];
}

- (void)setName:(NSString *)name {
    _name = name;
//    [_iconName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    _iconName.text = name;
}

- (void)setBackGColor:(NSString *)backGColor {
    _backGColor = backGColor;
    self.backView.backgroundColor = [Utils colorWithHexString:backGColor];
}

@end
