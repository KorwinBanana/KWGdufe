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
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#import "KWCashModel.h"
#import "KWTodayBuyViewController.h"
#import "KWAFNetworking.h"
#import "KWRequestUrl.h"

@interface KWMineViewController ()

@property(nonatomic,strong) KWStuModel *stuModel;
@property (nonatomic,strong) KWCashModel *cardModel;
@property (nonatomic,strong) KWMineMsgViewController  *msgVc;
@property (nonatomic,strong) KWTodayBuyViewController *todayBuyVc;

@end

@implementation KWMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化当前学期
    NSString *sno = [wrapper myObjectForKey:(id)kSecAttrAccount];
    _stuTime = [Utils getCache:sno andID:@"stuTime"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.msgVc = [[KWMineMsgViewController alloc]init];//初始化二级页面
    self.todayBuyVc = [[KWTodayBuyViewController alloc]init];//初始化二级页面

    [self setupNavBar];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.bounds style:UITableViewStyleGrouped];
    
    CGRect frame = CGRectMake(0, 0, 0, 0.1);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
    
    [SVProgressHUD showWithStatus:@"加载数据中"];
    
    NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
    NSDictionary *cashAry = [Utils getCache:account andID:@"CardModel"];
    _cardModel = [KWCashModel mj_objectWithKeyValues:cashAry];
    self.todayBuyVc.cardModel = _cardModel;
    
    [self getDataFromCache];//加载数据
    
    [self updateCashData];//加载校园卡余额
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
    
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    
    [KWAFNetworking postWithUrlString:GetBasicAPI parameters:parements success:^(id data) {
        //获取字典
        NSDictionary *stuDict = data[@"data"];
        
        //缓存到本地
        [Utils saveCache:gdufeAccount andID:@"StuModel" andValue:stuDict];
        
        //字典转模型
        _stuModel = [KWStuModel mj_objectWithKeyValues:stuDict];
        self.msgVc.stuModel = _stuModel;
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        
    }];
}

//有网络时，更新本地Cash余额
- (void)loadCardData {
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    
    [KWAFNetworking postWithUrlString:GetCashAPI parameters:parements success:^(id data) {
        //获取字典
        NSDictionary *cardDict = data[@"data"];
        
        //更新本地Cash
        [Utils updateCache:gdufeAccount andID:@"CardModel" andValue:cardDict];
        //        NSLog(@"更新成功");
        
        //字典转模型
        _cardModel = [KWCashModel mj_objectWithKeyValues:cardDict];
        //        self.msgVc.stuModel = _stuModel;
        self.todayBuyVc.cardModel = _cardModel;
        //        NSLog(@"cardNum",_cardModel.cardNum);
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

/*
 缓存余额数据:有网络的时候，更新本地余额数据，无网络的时候不更新
 */
- (void) updateCashData {
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager  sharedManager];
    //2.监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus  status) {
        switch (status) {
            case  AFNetworkReachabilityStatusUnknown: {
                NSLog(@"未知");
                //缓存获取Cash余额
                NSDictionary *cashAry = [Utils getCache:gdufeAccount andID:@"CardModel"];
                _cardModel = [KWCashModel mj_objectWithKeyValues:cashAry];
                self.todayBuyVc.cardModel = _cardModel;
                [self.tableView reloadData];
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"没有网络");
                //缓存获取Cash余额
                NSDictionary *cashAry = [Utils getCache:gdufeAccount andID:@"CardModel"];
                _cardModel = [KWCashModel mj_objectWithKeyValues:cashAry];
                self.todayBuyVc.cardModel = _cardModel;
                [self.tableView reloadData];
                 break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                NSLog(@"3G|4G");
                [self loadCardData];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"WiFi");
                [self loadCardData];
                break;
            }
            default:
                break;
        }
    }];
    [manager startMonitoring];//开始监听
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
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"stuTimeCell"];
            cell.textLabel.text = [NSString stringWithFormat:@"校园卡余额(卡号:%@)",_cardModel.cardNum];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",_cardModel.cash];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中无色
        } else {
            cell.textLabel.text = @"选项待定";
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
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
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self toTodayBuyVc];
        }
    } else if (indexPath.section == 2) {
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
    [Utils removeCache:account andID:@"CurrentBookModel"];
    [Utils removeCache:account andID:@"stuTimes"];
    [Utils removeCache:account andID:@"stuTime"];
    [Utils removeCache:account andID:@"TodayBuyModel"];
    [Utils removeCache:account andID:@"CardModel"];
    [Utils removeCache:account andID:@"schoolWeek"];
    [Utils removeCache:account andID:@"schoolYear"];
    [Utils removeCache:account andID:@"stuTimeForGrade"];
    [Utils removeCache:account andID:@"schoolYearForGrade"];
    
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

//点击跳转到今日交易界面
- (void)toTodayBuyVc {
    [self.navigationController pushViewController:self.todayBuyVc animated:YES];
}

@end
