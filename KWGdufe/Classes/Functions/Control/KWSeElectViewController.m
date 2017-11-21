//
//  KWSeElectViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/11/5.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWSeElectViewController.h"
#import "KWAFNetworking.h"
#import <MJExtension/MJExtension.h>

@interface KWSeElectViewController ()

@property (nonatomic,strong) UITextField *dormitory;
@property (nonatomic,strong) UITextField *room;
@property(nonatomic,strong) NSArray *electricModel;

@end

@implementation KWSeElectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"电费查询";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpSeElectView];
}

- (void)setUpSeElectView {
    //状态栏高度
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    CGFloat toTopHeight = rectStatus.size.height + rectNav.size.height;
    
    UIView *view1 = [[UIView alloc]init];
//    view1.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view1];
    [view1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(toTopHeight+20);
        make.width.equalTo(@(KWSCreenW*2/3));
        make.height.equalTo(@(160));
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    UILabel *dormitoryNum = [[UILabel alloc]init];
    dormitoryNum.text = @"宿舍楼号:";
    [dormitoryNum setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [view1 addSubview:dormitoryNum];
    [dormitoryNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view1.mas_top).with.offset(20);
        make.left.equalTo(view1.mas_left);
        make.height.equalTo(@30);
    }];
    
    UILabel *roomNum = [[UILabel alloc]init];
    roomNum.text = @"房  间  号:";
    [roomNum setFont:[UIFont fontWithName:@"Helvetica-Bold" size:18]];
    [view1 addSubview:roomNum];
    [roomNum mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dormitoryNum.mas_bottom).with.offset(20);
        make.left.equalTo(dormitoryNum.mas_left);
        make.height.equalTo(@30);
    }];
    
    UITextField *dormitoryField = [[UITextField alloc]init];
    self.dormitory = dormitoryField;
    dormitoryField.borderStyle = UITextBorderStyleRoundedRect;
    dormitoryField.placeholder = @"楼号";
    dormitoryField.clearButtonMode = UITextFieldViewModeAlways;
    [view1 addSubview:dormitoryField];
    [dormitoryField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dormitoryNum.mas_top);
        make.left.equalTo(dormitoryNum.mas_right).with.offset(10);
        make.right.equalTo(view1.mas_right);
        make.bottom.equalTo(dormitoryNum.mas_bottom);
    }];
    
    UITextField *roomField = [[UITextField alloc]init];
    self.room = roomField;
    roomField.borderStyle = UITextBorderStyleRoundedRect;
    roomField.placeholder = @"房间号";
    roomField.clearButtonMode = UITextFieldViewModeAlways;
    [view1 addSubview:roomField];
    [roomField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(roomNum.mas_top);
        make.left.equalTo(roomNum.mas_right).with.offset(10);
        make.right.equalTo(view1.mas_right);
        make.bottom.equalTo(roomNum.mas_bottom);
    }];
    
    UIButton *findBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [findBtn setTitle:@"查询" forState:UIControlStateNormal];
    [findBtn addTarget:self action:@selector(loadDataPushToView) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:findBtn];
    [findBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(view1.mas_centerX);
        make.bottom.equalTo(view1.mas_bottom);
    }];
}

- (void)loadDataPushToView {
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"building"] = self.dormitory.text;
    parements[@"room"] = self.room.text;
    
    [KWAFNetworking postWithUrlString:@"http://api.wegdufe.com:82/index.php?r=card/get-electric" parameters:parements success:^(id data) {
        //获取字典
//        NSDictionary *gradeDict = data[@"data"];
        NSLog(@"data = %@",data);
        
        //缓存到本地
//        [Utils saveCache:gdufeAccount andID:@"GradeModel" andValue:gradeDict];
        
        //字典转模型
//        NSArray *gradeModel = [KWGradeModel mj_objectArrayWithKeyValuesArray:gradeDict];
//
//        _gradeModel = gradeModel;
//
//        [self.tableView reloadData];
//        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
}

@end
