//
//  KWOtherFuncViewCell.h
//  KWGdufe
//
//  Created by korwin on 2017/11/5.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <UIKit/UIKit.h>

/*代理方式让主NavigationController跳转*/
@protocol KWOtherPushDelegate <NSObject>
- (void)pushVc:(id)Vc;
@end

@interface KWOtherFuncViewCell : UITableViewCell

@property (assign, nonatomic) id<KWOtherPushDelegate> delegate;//代理属性

@end
