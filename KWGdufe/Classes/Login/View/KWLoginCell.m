//
//  KWLoginCell.m
//  KWGdufe
//
//  Created by korwin on 2017/12/21.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWLoginCell.h"
#import "Utils.h"

@interface KWLoginCell()
@property (weak, nonatomic) IBOutlet UIView *buttonView;
@end

@implementation KWLoginCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.buttonView.layer.cornerRadius = 5;
    self.buttonView.backgroundColor = [Utils colorWithHexString:@"37C6C0"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
