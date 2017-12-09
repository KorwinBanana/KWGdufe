//
//  KWAPTextFieldCell.h
//  KWGdufe
//
//  Created by korwin on 2017/12/9.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KWAccountPwdTextField;

@interface KWAPTextFieldCell : UITableViewCell

@property(nonatomic,strong) NSString *placeholderText;
@property(nonatomic,strong) KWAccountPwdTextField  *accountLogin;

@end
