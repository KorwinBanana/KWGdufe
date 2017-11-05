//
//  KWFunctionsCell.m
//  KWGdufe
//
//  Created by korwin on 2017/10/26.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWFunctionsCell.h"

@interface KWFunctionsCell()
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *iconName;
@end

@implementation KWFunctionsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
}

- (void)setName:(NSString *)name {
    [_iconName setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
    _iconName.text = name;
}

- (void)setImageName:(NSString *)imageName {
    _iconImage.image = [UIImage imageNamed:imageName];
}

@end
