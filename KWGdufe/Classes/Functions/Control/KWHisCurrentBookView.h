//
//  KWCurrentBookView.h
//  KWGdufe
//
//  Created by korwin on 2017/11/1.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KWHisCurrentBookView : UITableViewController

@property (nonatomic,strong) NSString  *url;
@property (nonatomic,strong) NSString  *modelSaveName;
@property (nonatomic,strong) NSString  *vcName;
@property (nonatomic,assign) NSInteger  boolHistory;

@end
