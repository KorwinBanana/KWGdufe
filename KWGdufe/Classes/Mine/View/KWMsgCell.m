//
//  KWMsgCell.m
//  KWGdufe
//
//  Created by korwin on 2017/10/16.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWMsgCell.h"

@interface KWMsgCell()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *value;

@end

@implementation KWMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setMsgValue:(NSString *)msgValue {
    _msgValue = msgValue;
    _value.text = _msgValue;
}

- (void)setMsgName:(NSString *)msgName {
    _msgName = msgName;
    _name.text = _msgName;
}

@end
