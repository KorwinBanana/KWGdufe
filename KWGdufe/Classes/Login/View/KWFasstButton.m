//
//  KWFasstButton.m
//  KWGdufe
//
//  Created by korwin on 2017/12/9.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWFasstButton.h"

@implementation KWFasstButton

 - (void)layoutSubviews
 {
     [super layoutSubviews];
     self.imageView.KW_centerY = self.imageView.KW_height * 0.5 + 5;
     self.imageView.KW_centerX = self.KW_width * 0.5;
 
     self.titleLabel.KW_centerY = self.KW_height - self.titleLabel.KW_height + 5;
     self.titleLabel.KW_centerX = self.KW_width * 0.5;
 
     [self.titleLabel sizeToFit];
 }

@end
