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
#import "KWLoginCell.h"

@interface KWLoginTableViewController ()

@property (nonatomic,strong) KWAccountPwdTextField  *sno;
@property (nonatomic,strong) KWAccountPwdTextField  *pwd;

@end

@implementation KWLoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.bounds style:UITableViewStyleGrouped];
    CGRect frame = CGRectMake(0, 0, 0, 20);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
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
            _sno.clearButtonMode = UITextFieldViewModeWhileEditing;
            return cell;
        } else if (indexPath.row == 1) {
            cell.placeholderText = @"密码";
            _pwd = cell.accountLogin;
            _pwd.snoOrPwd = 1;
            _pwd.secureTextEntry = YES;
            _pwd.clearButtonMode = UITextFieldViewModeWhileEditing;
            return cell;
        }
    } else if (indexPath.section == 1) {
        KWLoginCell *cell = [[KWLoginCell alloc]init];
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([KWLoginCell class]) owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
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
            //UIAlertController风格：UIAlertControllerStyleAlert
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"使用声明"
                                                                                     message:@"当前使用的茶珂APP系广财同学个人作品，非广东财经大学官方APP，但开发者保证数据传输的安全性，对重要数据进行了加密处理，请放心使用！"
                                                                              preferredStyle:UIAlertControllerStyleAlert ];
            
            //添加取消到UIAlertController中
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"不同意" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
                [_sno becomeFirstResponder];
            }];
            [alertController addAction:cancelAction];
            
            //添加确定到UIAlertController中
            UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"同意" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
                [SVProgressHUD show];
                [self loadData];
            }];
            [alertController addAction:OKAction];
            
            [self presentViewController:alertController animated:YES completion:nil];
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
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleCancel handler:nil];
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
            
            //初始化参数
            //计算当前学期
            [Utils getNowYear];
            
            //获取第几周
            NSString *schoolWeek = [NSString stringWithFormat:@"4"];
            [Utils saveCache:gdufeAccount andID:@"schoolWeek" andValue:schoolWeek];
            
            //保存当前大学
            [Utils getStuTimeSchool:[Utils getCache:gdufeAccount andID:@"stuTime"]];
            
            [Utils saveCache:gdufeAccount andID:@"gradeSelect" andValue:@"年"];//成绩查询页面gradeSelectYear
            [Utils saveCache:gdufeAccount andID:@"gradeSelectYear" andValue:@"全部"];
            
            KWTabBarController *tabVc = [[KWTabBarController alloc]init];
            [UIApplication sharedApplication].keyWindow.rootViewController = tabVc;
            [self.view endEditing:YES];
            [SVProgressHUD dismiss];
        } else if ([codeStr isEqualToString:@"3000"]) {
            NSLog(@"学号或者密码为空啦～～");
            //添加提示框
            alert.message = @"请输入学号/密码";
//            alert.title = @"登录失败";
            [self presentViewController:alert animated:YES completion:nil];
        } else if ([codeStr isEqualToString:@"3001"]) {
            NSLog(@"喵～学号或密码错误啦～～");
            //添加提示框
            alert.message = @"请输入正确的学号/密码";
//            alert.title = @"登录失败";
            [self presentViewController:alert animated:YES completion:nil];
        } else {
            alert.title = @"系统崩溃";
            [self presentViewController:alert animated:YES completion:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"失败啦～～");
        [SVProgressHUD dismiss];
    }];
}

@end
