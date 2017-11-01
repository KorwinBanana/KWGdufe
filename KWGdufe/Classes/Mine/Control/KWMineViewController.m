//
//  KWMineViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/9/28.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWMineViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "KWStuModel.h"
#import "KWMineMsgViewController.h"
#import "KWLoginViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "KeychainWrapper.h"
#import "KWMyMsgCell.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Utils.h"

@interface KWMineViewController ()

@property(nonatomic,strong) KWStuModel *stuModel;
@property (nonatomic,strong) KWMineMsgViewController  *msgVc;

@end

@implementation KWMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.msgVc = [[KWMineMsgViewController alloc]init];//初始化

    [self setupNavBar];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.bounds style:UITableViewStyleGrouped];
    
    CGRect frame = CGRectMake(0, 0, 0, 0.1);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
    
    [SVProgressHUD showWithStatus:@"加载数据中"];
    
    [self getDataFromCache];//加载数据
}

- (void)getDataFromCache {
    NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
    NSDictionary *stuDict = [Utils getCache:account andID:@"StuModel"];
    if (stuDict) {
        //字典转模型
        _stuModel = [KWStuModel mj_objectWithKeyValues:stuDict];
        self.msgVc.stuModel = _stuModel;
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    } else {
        [self loadData];
    }
}

#pragma mark - 加载数据
- (void)loadData {
    //创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //获取登陆的账号密码
    NSString *sno = [wrapper myObjectForKey:(id)kSecAttrAccount];
    NSString *pwd = [wrapper myObjectForKey:(id)kSecValueData];
    
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = sno;
    parements[@"pwd"] = pwd;

    //发送请求
    [mgr POST:@"http://api.wegdufe.com:82/index.php?r=jw/get-basic" parameters:parements progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        [responseObject writeToFile:@"/Users/k/iOS-KW/project/stuModel.plist" atomically:nil];
        
        //获取字典
        NSDictionary *stuDict = responseObject[@"data"];
        
        //缓存到本地
        [Utils saveCache:sno andID:@"StuModel" andValue:stuDict];
        
        //字典转模型
        _stuModel = [KWStuModel mj_objectWithKeyValues:stuDict];
        self.msgVc.stuModel = _stuModel;
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];//
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
    }];
}

#pragma mark - 设置导航条
-(void)setupNavBar
{
    //设置按钮
    self.navigationItem.title = @"我";
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    if (indexPath.section == 0) {
        //nil加载cell
//        KWMineCell *cell = [[KWMineCell alloc]init];
//        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([KWMineCell class]) owner:nil options:nil][0];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        cell.model = _stuModel;
        KWMyMsgCell *cell = [[KWMyMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中无色
        cell.model = _stuModel;
        return cell;
    } if (indexPath.section == 2) {
        cell.textLabel.text = @"退出";
    } else {
        cell.textLabel.text = @"选项待定";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//禁止选中
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 88;
    } else return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self tomsgVc];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self logout];
        }
    }
}

#pragma mark - 退出注销服务器缓存
- (void)logout {
    NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
    //删除课程表缓存
    [Utils removeCache:account andID:@"ClassModel"];
    [Utils removeCache:account andID:@"GradeModel"];
    
    //删除账号密码
    [wrapper resetKeychainItem];
    
    //跳转页面
    KWLoginViewController *loginVc = [[KWLoginViewController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginVc;
}

//点击跳转到设置页面
- (void)tomsgVc {
    [self.navigationController pushViewController:self.msgVc animated:YES];
}

@end
