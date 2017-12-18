//
//  KWGoOnBookViewController.h
//  KWGdufe
//
//  Created by korwin on 2017/12/19.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KWCurrentModel;
@class KWCurrentBookView;

@interface KWGoOnBookViewController : UIViewController

@property(nonatomic,strong) KWCurrentModel *model;
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *barId;
@property(nonatomic,strong) NSString *checkId;
@property(nonatomic,strong) KWCurrentBookView *KWCBVc;

@end
