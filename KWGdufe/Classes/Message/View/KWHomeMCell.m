//
//  KWHomeMCell.m
//  KWGdufe
//
//  Created by korwin on 2018/2/6.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWHomeMCell.h"
#import "Utils.h"

@interface KWHomeMCell()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *massageTitle;
@property (weak, nonatomic) IBOutlet UILabel *massagebody;

@end

@implementation KWHomeMCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    self.backView.layer.cornerRadius = 10;
    self.backView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.backView.layer.shadowOffset = CGSizeMake(2, 5);
    self.backView.layer.shadowOpacity = 0.5;
    self.backView.layer.shadowRadius = 5;
    
    [_massageTitle setFont:[UIFont fontWithName:@"Helvetica-Bold" size:17]];
    [_massagebody setFont:[UIFont systemFontOfSize:12]];
}

-(void)setMasgBody:(NSString *)masgBody {
    _masgBody = masgBody;
    _massagebody.text = masgBody;
}

- (void)setMasgTitle:(NSString *)masgTitle {
    _masgTitle = masgTitle;
    _massageTitle.text = masgTitle;
}

- (void)setBackGColor:(NSString *)backGColor {
    _backGColor = backGColor;
    self.backView.backgroundColor = [Utils colorWithHexString:backGColor];
}

@end
