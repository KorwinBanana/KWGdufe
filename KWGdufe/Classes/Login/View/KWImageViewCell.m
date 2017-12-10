//
//  KWImageViewCell.m
//  KWImageMaxView
//
//  Created by korwin on 2017/10/10.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWImageViewCell.h"

@interface KWImageViewCell()
@property (weak, nonatomic) IBOutlet UILabel *label1;

@end

@implementation KWImageViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _label1.textAlignment = NSTextAlignmentCenter;
    _label1.textColor = [UIColor blackColor];
    _label = _label1;
    // Initialization code
}

@end
