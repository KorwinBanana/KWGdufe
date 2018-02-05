//
//  KWEducationalViewCell.h
//  KWGdufe
//
//  Created by korwin on 2017/10/26.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <UIKit/UIKit.h>

/*代理方式让主NavigationController跳转*/
@protocol KWPushDelegate <NSObject>
- (void)pushVc:(id)gradeVc;
@end

@interface KWEducationalViewCell : UITableViewCell

//@property (nonatomic,weak) UINavigationController  *superViewController;
@property (assign, nonatomic) id<KWPushDelegate> delegate;//这个是代理属性

@end
