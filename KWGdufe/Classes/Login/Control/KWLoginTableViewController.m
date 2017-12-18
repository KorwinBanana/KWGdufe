//
//  KWLoginTableViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/12/9.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWLoginTableViewController.h"
#import "KWAPTextFieldCell.h"
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
#import "KWPasswordTextField.h"

@interface KWLoginTableViewController ()

@property (nonatomic,strong) KWAccountPwdTextField  *sno;
@property (nonatomic,strong) KWAccountPwdTextField  *pwd;

@end

@implementation KWLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.bounds style:UITableViewStyleGrouped];
    [self setupNavBar];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_sno becomeFirstResponder];
}

#pragma mark - 设置导航条
- (void)setupNavBar{
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"login_close_icon"] hightImage:[UIImage imageNamed:@"login_close_icon"] target:self action:@selector(pushDownView)];
    self.navigationItem.title = @"登录";
}

- (void)pushDownView {
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    } else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.text = @"登录";
    if (indexPath.section == 0) {
        KWAPTextFieldCell *cell = [[KWAPTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0) {
            cell.placeholderText = @"学号";
            _sno = cell.accountLogin;
            _sno.snoOrPwd = 0;
            _sno.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            return cell;
        } else if (indexPath.row == 1) {
            cell.placeholderText = @"密码";
            _pwd = cell.accountLogin;
            _pwd.snoOrPwd = 1;
            _pwd.secureTextEntry = YES;
            return cell;
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self.view endEditing:YES];
            [SVProgressHUD show];
            [self loadData];
        }
    }
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
            
            KWTabBarController *tabVc = [[KWTabBarController alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabVc;
            [SVProgressHUD dismiss];
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
