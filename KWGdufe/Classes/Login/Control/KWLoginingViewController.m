//
//  KWLoginingViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/12/9.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWLoginingViewController.h"
#import "KWFasstButton.h"
#import "KWAccountPwdTextField.h"
#import "KWTabBarController.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+KWMD5.h"
#import "NSData+KWAES.h"
#import "KeychainWrapper.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Utils.h"
#import "KWAFNetworking.h"
#import "KWRequestUrl.h"

@interface KWLoginingViewController ()

@property (nonatomic,strong) UIImageView  *backgroundImage;//暂时未使用
@property (nonatomic,strong) UIView *midView;

@property (nonatomic,strong) UIView *loginView;

//mid
@property (nonatomic,strong) NSMutableDictionary *attrs;
//登录
@property (nonatomic,strong) UIView  *loginView2;
@property (nonatomic,strong) UIImageView  *loginImage;
@property (nonatomic,strong) KWAccountPwdTextField  *accountLogin;
@property (nonatomic,strong) KWAccountPwdTextField  *passwardLogin;
@property (nonatomic,strong) UIButton  *loginBtn;
@property (nonatomic,strong) UIButton  *forgetBtn;

@end

@implementation KWLoginingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadBackground];
    [self loadLoginView];
}

#pragma mark - 初始化背景
- (void) loadBackground
{
    self.view.backgroundColor = [Utils colorWithHexString:@"2E47AC"];

}

#pragma mark - 初始化界面
- (void) loadLoginView
{
//    [self loadTop];
    [self loadMid];
//    [self loadBoottom];
    
    /*
     越复杂的界面 ，封装，效果越复杂的界面，也需要封装
     1. 文本框光标变成白色
     2. 占位文字颜色变成白色，开始编辑的时候占位文字变成白色
     3.
     */
}



- (void) loadMid
{
    UIView *subview = self.view;
    _midView = [[UIView alloc]init];
    _midView.backgroundColor = [UIColor clearColor];
    [subview addSubview:_midView];
    
    //定义占位文默认颜色
    _attrs = [NSMutableDictionary dictionary];
    _attrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    
    //midView 控件
    _loginView = [[UIView alloc]init];
    _loginView.backgroundColor = [UIColor clearColor];
    [_midView addSubview:_loginView];
    
    //View位置
    [_midView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subview.mas_bottom).with.offset(-300);
        make.left.equalTo(subview.mas_left);
        make.width.equalTo(@(self.view.KW_width));
        make.height.equalTo(@300);
    }];
    
    //midView 注册/登录控件位置
    [_loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_midView.mas_left);
        make.top.equalTo(_midView.mas_top);
        make.bottom.equalTo(_midView.mas_bottom);
        make.width.equalTo(subview.mas_width);
    }];
    
    //登录界面
    [self KWLoginView];
    
}

#pragma mark - 登录View
- (void) KWLoginView
{
    //loginView 控件
    _loginView2 = [[UIView alloc]init];
    _loginView2.backgroundColor = [UIColor clearColor];
    [_loginView addSubview:_loginView2];
    
    _loginImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"login_rgister_textfield_bg"]];
    [_loginView2 addSubview:_loginImage];
    
    _loginBtn = [UIButton buttonStretWithTitle:@"登录" titleColorN:[UIColor whiteColor] titleColorH:[UIColor whiteColor] image:[UIImage imageNamed:@"loginBtnBg"] hightImage:[UIImage imageNamed:@"loginBtnBgClick"] target:self action:@selector(login) Cap:0.7];
    [_loginView addSubview:_loginBtn];
    
    _accountLogin = [[KWAccountPwdTextField alloc] init];
    _accountLogin.borderStyle = UITextBorderStyleNone;
    _accountLogin.placeholder = @"手机号";
    _accountLogin.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_accountLogin.placeholder attributes:_attrs];
    [_loginView2 addSubview:_accountLogin];
    
    _passwardLogin = [[KWAccountPwdTextField alloc] init];
    _passwardLogin.borderStyle = UITextBorderStyleNone;
    _passwardLogin.placeholder = @"密码";
    _passwardLogin.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_passwardLogin.placeholder attributes:_attrs];
    [_loginView2 addSubview:_passwardLogin];
    
    _forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_forgetBtn setTitle:@"忘记密码？" forState:UIControlStateNormal];
    _forgetBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [_forgetBtn addTarget:self action:@selector(forgetPassword) forControlEvents:UIControlEventTouchUpInside];
    [_loginView addSubview:_forgetBtn];
    
    
    //loginView 控件位置
    [_loginView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_loginView);
        make.top.equalTo(_loginView.mas_top).with.offset(20);
        make.width.equalTo(@266);
        make.height.equalTo(@92);
    }];
    
    [_loginImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_loginView2);
        make.width.equalTo(_loginView2.mas_width);
        make.height.equalTo(_loginView2.mas_height);
    }];
    
    [_accountLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginView2.mas_top);
        make.left.equalTo(_loginView2.mas_left).with.offset(5);
        make.right.equalTo(_loginView2.mas_right).with.offset(-5);
        make.height.equalTo(@46);
    }];
    
    [_passwardLogin mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountLogin.mas_bottom);
        make.left.equalTo(_loginView2.mas_left).with.offset(5);
        make.right.equalTo(_loginView2.mas_right).with.offset(-5);
        make.height.equalTo(@46);
    }];
    
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_loginView);
        make.top.equalTo(_loginView2.mas_bottom).with.offset(30);
        make.width.equalTo(_loginView2.mas_width);
        make.height.equalTo(@30);
    }];
    
    [_forgetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_loginBtn.mas_bottom).with.offset(20);
        make.right.equalTo(_loginBtn.mas_right);
    }];
    
}

#pragma mark - 返回上一级ViewControl
- (void) dismissView
{
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 登录
- (void) login
{
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = _accountLogin.text;
    parements[@"pwd"] = _passwardLogin.text;
    
    [KWAFNetworking postWithUrlString:LoginAPI parameters:parements success:^(id data) {
        //添加警告框
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:okAction];
        
        //获取字典
        NSString *code = [data objectForKey:@"code"];
        NSString *codeStr = [NSString stringWithFormat:@"%@",code];
        //NSLog(@"self.loginBoolModel.code = %@",codeStr);
        
        [SVProgressHUD dismiss];
        
        //判断是否登陆
        if ([codeStr isEqualToString:@"0"]) {
            /** 初始化一个保存用户帐号的KeychainWrapper */
            //            NSLog(@"%@",uuid);
            //            NSData *data = [_pwd.text dataUsingEncoding:NSUTF8StringEncoding];
            //            NSData *encryptedData = [data EncryptAES:uuid];
            
            //保存密码
            [wrapper mySetObject:_accountLogin.text forKey:(id)kSecValueData];
            [wrapper mySetObject:_passwardLogin.text forKey:(id)kSecAttrAccount];
            
            //把学期保存到NSUserDefaults
            NSString *whenStuTime = [_accountLogin.text substringToIndex:2];
            //            NSLog(@"whenStuTime = %@",whenStuTime);
            [Utils getStuYears:whenStuTime mySno:[wrapper myObjectForKey:(id)kSecAttrAccount]];
            
            //计算当前学期
            [Utils getNowYear];
            //保存当前大学
            [Utils getStuTimeSchool:[Utils getCache:gdufeAccount andID:@"stuTime"]];
            //获取第几周
            [Utils getSchoolWeek];
            
            //使用md5加密
            //            NSString *pwdByMD5 = [NSString md5To32bit:_pwd.text];
            //            [userDefaults setObject:pwdByMD5 forKey:@"pwd"];
            
            //AES加密
            KWTabBarController *tabVc = [[KWTabBarController alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabVc;
            
        } else if ([codeStr isEqualToString:@"3000"]) {
            NSLog(@"喵～学号或者密码为空啦～～");
            //添加提示框
            alert.message = @"喵～学号或者密码为空啦～～";
            [self presentViewController:alert animated:YES completion:nil];
        } else if ([codeStr isEqualToString:@"3001"]) {
            NSLog(@"喵～学号或密码错误啦～～");
            //添加提示框
            alert.message = @"喵～学号或密码错误啦～～";
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            alert.message = @"喵～系统崩溃啦～～";
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"失败啦～～");
        [SVProgressHUD dismiss];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
