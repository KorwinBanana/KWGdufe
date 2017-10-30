//
//  KWLibraryViewCell.h
//  KWGdufe
//
//  Created by korwin on 2017/10/30.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <UIKit/UIKit.h>

/*代理方式让主NavigationController跳转*/
@protocol KWLibraryPushDelegate <NSObject>
- (void)pushVc:(id)gradeVc;
@end

@interface KWLibraryViewCell : UITableViewCell

@property (assign, nonatomic) id<KWLibraryPushDelegate> delegate;//这个是代理属性

@end
