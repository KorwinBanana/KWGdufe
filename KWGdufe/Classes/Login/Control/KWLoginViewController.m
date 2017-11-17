//
//  KWLoginViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/10/12.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWLoginViewController.h"
#import "KWTabBarController.h"
#import <AFNetworking/AFNetworking.h>
#import "NSString+KWMD5.h"
#import "NSData+KWAES.h"
#import "KeychainWrapper.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Utils.h"
#import "KWAFNetworking.h"
#import "KWRequestUrl.h"
//#import <MJExtension/MJExtension.h>

@interface KWLoginViewController () {
    id loginSuccess;
}
@property (weak, nonatomic) IBOutlet UITextField *sno;
@property (weak, nonatomic) IBOutlet UITextField *pwd;

@end

@implementation KWLoginViewController
- (IBAction)login:(id)sender {
    [SVProgressHUD showWithStatus:@"登录中"];
    [self loadData];
}

- (IBAction)dissKeyB:(id)sender {
    [self.view endEditing:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _pwd.secureTextEntry = YES;// 密码模式,加密
    _pwd.keyboardType = UIKeyboardTypeDefault;//设置键盘类型
    _pwd.returnKeyType = UIReturnKeyDone;// return键名替换
//    _pwd.delegate = self;
    [_pwd addTarget:self action:@selector(dissMissKeyBoard2) forControlEvents:UIControlEventTouchDown];//点击return触发
    
    [_sno addTarget:self action:@selector(dissMissKeyBoard) forControlEvents:UIControlEventEditingDidEndOnExit];

    // Do any additional setup after loading the view from its nib.
}

- (void)dissMissKeyBoard
{
    [self.view endEditing:YES];
}

- (void)dissMissKeyBoard2
{
    [self.view endEditing:YES];
}

#pragma mark - 验证登陆
- (void)loadData
{
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = _sno.text;
    parements[@"pwd"] = _pwd.text;
    
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
            [wrapper mySetObject:_pwd.text forKey:(id)kSecValueData];
            [wrapper mySetObject:_sno.text forKey:(id)kSecAttrAccount];
            
            //把学期保存到NSUserDefaults
            NSString *whenStuTime = [_sno.text substringToIndex:2];
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
@end
