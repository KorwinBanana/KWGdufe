//
//  KWGoOnBookViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/12/19.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWGoOnBookViewController.h"
#import "KWCurrentModel.h"
//#import "NSData+Base64.h"
#import <MJExtension/MJExtension.h>
#import "KWAFNetworking.h"
#import "KeychainWrapper.h"
#import "KWVerifyModel.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "KWCurrentBookView.h"
#import <MJRefresh/MJRefresh.h>
#import "Utils.h"

@interface KWGoOnBookViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *verifyImage;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
//@property(nonatomic,strong) NSArray *verifyArray;

@end

@implementation KWGoOnBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self loadData];//请求验证码
    });
    _verifyTextField.delegate = self;
    _verifyTextField.accessibilityLabel = @"请输入验证码";
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_verifyTextField becomeFirstResponder];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.view endEditing:YES];
    //UIAlertController风格：UIAlertControllerStyleAlert
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"是否续借\n《%@》",_name]
                                                                             message:nil
                                                                      preferredStyle:UIAlertControllerStyleAlert ];
    
    //添加取消到UIAlertController中
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
        [_verifyTextField becomeFirstResponder];//呼出键盘
    }];
    [alertController addAction:cancelAction];
    
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"续借" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        //post请求续借
        [self renewBookWithVerify:textField.text];
    }];
    [alertController addAction:OKAction];
    [self presentViewController:alertController animated:YES completion:nil];
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (string.length > 3) {
        //截取
        string = [string substringToIndex:3];
    }
    return [self validateNumberByRegExp:string];
}

//判断是否为字母
- (BOOL)validateNumberByRegExp:(NSString *)string {
    BOOL isValid = YES;
    NSUInteger len = string.length;
    if (len > 0) {
        NSString *ALPHA = @"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
        NSPredicate *ALPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ALPHA];
        isValid = [ALPredicate evaluateWithObject:string];
    }
    return isValid;
}

#pragma mark - 加载验证码
- (void)loadData {
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    
    [KWAFNetworking postWithUrlString:@"http://api.wegdufe.com:82/index.php?r=opac/get-renew-book-verify" vController:self parameters:parements success:^(id data) {
        NSLog(@"%@",data);
        //获取字典
        NSDictionary *sztzDict = data[@"data"];

        //字典转模型
        KWVerifyModel *verifyModel = [KWVerifyModel mj_objectWithKeyValues:sztzDict];

        dispatch_async(dispatch_get_main_queue(), ^{ //主线程刷新界面
            NSString *base64 = verifyModel.data;
            NSData *base64ToData = [[NSData alloc]initWithBase64EncodedString:base64 options:NSDataBase64DecodingIgnoreUnknownCharacters];
            _verifyImage.image = [UIImage imageWithData:base64ToData];
        });
    } failure:^(NSError *error) {
        
    } noNetworking:^{
        
    }];
}

#pragma mark - 续借图书
- (void)renewBookWithVerify:(NSString *)verify {
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    parements[@"barId"] = _barId;
    parements[@"checkId"] = _checkId;
    parements[@"verify"] = verify;
    
//    NSLog(@"%@",_barId);
//    NSLog(@"%@",_checkId);
//    NSLog(@"%@",verify);
    
    [KWAFNetworking postWithUrlString:@"http://api.wegdufe.com:82/index.php?r=opac/renew-book" vController:self parameters:parements success:^(id data) {
//        NSLog(@"%@",data);
        //获取字典
        NSDictionary *renewDict = data[@"data"];
        [data writeToFile:@"/Users/k/iOS-KW/KWGdufe/square.txt" atomically:nil];
        //字典转模型
        KWVerifyModel *renewModel = [KWVerifyModel mj_objectWithKeyValues:renewDict];
        
        //获取code
        NSString *code = [data objectForKey:@"code"];
        NSString *codeStr = [NSString stringWithFormat:@"%@",code];
        NSMutableString *newString = [Utils replaceStringWithString:renewModel.data];
        
        [SVProgressHUD showWithStatus:@"续借中..."];
        dispatch_queue_t HUDQueue = dispatch_queue_create("HUDQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(HUDQueue, ^{
            [SVProgressHUD showWithStatus:@"续借中..."];
            sleep(1.5);
            if ([codeStr isEqualToString:@"0"]) {
                if ([newString isEqualToString:@"续借成功"]) {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"%@\n《%@》",newString,_name]];
                    sleep(1.5);
                    [SVProgressHUD dismiss];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                        [_KWCBVc.tableView.mj_header beginRefreshing];
                    });
                } else if ([newString isEqualToString:@"超过最大续借次数，不得续借！"]) {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"续借失败\n超过最多续借次数"]];
                    sleep(1.5);
                    [SVProgressHUD dismiss];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.navigationController popViewControllerAnimated:YES];
                    });
                } else if ([newString isEqualToString:@"错误的验证码(wrongcheckcode)"]) {
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"续借失败\n验证码错误"]];
                    sleep(1.5);
                    [SVProgressHUD dismiss];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _verifyTextField.text = nil;
                        [_verifyTextField becomeFirstResponder];
                    });
                }
            } else if ([codeStr isEqualToString:@"3301"]) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"续借失败\n参数不完整续借失败"];
                sleep(1.5);
                [SVProgressHUD dismiss];
                dispatch_async(dispatch_get_main_queue(), ^{
                    _verifyTextField.text = nil;
                    [_verifyTextField becomeFirstResponder];
                });
            } else if ([codeStr isEqualToString:@"3303"]) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"续借失败\n图书馆账号已被注销\n请重新登录"];
                sleep(1.5);
                [SVProgressHUD dismiss];
            } else if ([codeStr isEqualToString:@"3001"]) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"续借失败\n学号或密码错误\n请重新登录"];
                sleep(1.5);
                [SVProgressHUD dismiss];
            } else if ([codeStr isEqualToString:@"3000"]) {
                [SVProgressHUD dismiss];
                [SVProgressHUD showErrorWithStatus:@"续借失败\n学号或者密码为空\n请重新登录"];
                sleep(1.5);
                [SVProgressHUD dismiss];
            }
        });
    } failure:^(NSError *error) {
        
    } noNetworking:^{
        
    }];
}

- (void)setName:(NSString *)name {
    _name = name;
}

- (void)setBarId:(NSString *)barId {
    _barId = barId;
}

- (void)setCheckId:(NSString *)checkId {
    _checkId = checkId;
}

@end
