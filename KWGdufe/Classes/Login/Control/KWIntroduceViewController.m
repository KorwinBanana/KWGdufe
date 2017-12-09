//
//  KWIntroduceViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/12/9.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWIntroduceViewController.h"
#import "Utils.h"
#import "KWLoginViewController.h"
#import "KWLoginTableViewController.h"
#import "KWNavigationViewController.h"

@interface KWIntroduceViewController ()

@property (nonatomic,strong) UIView  *introduceView;
@property (nonatomic,strong) UIView  *buttonView;

@property (nonatomic,strong) UIButton  *loginBtn;
@property (nonatomic,strong) UIButton  *tryBtn;

@end

@implementation KWIntroduceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadBackground];
    [self loadIntroduceView];
    
}

#pragma mark - 初始化背景
- (void)loadBackground {
    self.view.backgroundColor = [Utils colorWithHexString:@"2E47AC"];;
}

- (void)loadIntroduceView {
    //下层VIew
    _buttonView = [[UIView alloc]init];
    _buttonView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_buttonView];
    [_buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        make.height.equalTo(@100);
    }];
    
    //上层View
    _introduceView = [[UIView alloc]init];
    _introduceView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_introduceView];
    [_introduceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(_buttonView.mas_top);
    }];
    
    [self loadLoginButton];
}

#pragma mark - 体验登录/登录
- (void)loadLoginButton {
    _loginBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn addTarget:nil action:@selector(pushLoginView) forControlEvents:UIControlEventTouchUpInside];
    [_buttonView addSubview:_loginBtn];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_buttonView.mas_centerY);
//        make.top.equalTo(_buttonView.mas_top);
        make.right.equalTo(_buttonView.mas_right).with.offset(-20);
    }];
    
    _tryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_tryBtn setTitle:@"体验" forState:UIControlStateNormal];
    [_buttonView addSubview:_tryBtn];
    [_tryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(_buttonView.mas_centerY);
//        make.top.equalTo(_buttonView.mas_top);
        make.left.equalTo(_buttonView.mas_left).with.offset(20);
    }];
}

- (void)pushLoginView {
    KWLoginTableViewController *loginView = [[KWLoginTableViewController alloc]init];
    KWNavigationViewController *nav1 = [[KWNavigationViewController alloc]initWithRootViewController:loginView];
    [self presentViewController:nav1 animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
