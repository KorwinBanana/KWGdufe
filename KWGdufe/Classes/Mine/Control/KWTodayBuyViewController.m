//
//  KWTodayBuyViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/11/5.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWTodayBuyViewController.h"
#import "KWTodayBuyModel.h"
#import "KWTodayBuyCell.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "KeychainWrapper.h"
#import "Utils.h"
#import "KWCashModel.h"
#import <MJRefresh/MJRefresh.h>
#import "KWAFNetworking.h"
#import "KWRequestUrl.h"


@interface KWTodayBuyViewController ()

@property(nonatomic,strong) NSArray *todayBuyModel;

@end

@implementation KWTodayBuyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"校园卡";
    
    [self setupRefreshing];
    
    [self updateTodayData];
}

#pragma mark - setupRefreshing
- (void)setupRefreshing {
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    //设置头部
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //    self.tableView.contentInset = UIEdgeInsetsMake(rectStatus.size.height + rectNav.size.height, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 结束刷新
        [self loadTodayData];
        [tableView.mj_header endRefreshing];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
}

#pragma mark - 请求json
- (void)loadTodayData {
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    parements[@"cardNum"] = _cardModel.cardNum;
    
    [KWAFNetworking postWithUrlString:GetTodayCashAPI parameters:parements success:^(id data) {
        //获取字典
        NSDictionary *todayDict = data[@"data"];
        
        //更新本地Cash
        [Utils updateCache:gdufeAccount andID:@"TodayBuyModel" andValue:todayDict];
        NSLog(@"更新成功");
        
        //字典数组转模型
        _todayBuyModel = [KWTodayBuyModel mj_objectArrayWithKeyValuesArray:todayDict];
        
        [SVProgressHUD dismiss];
        
        if(_todayBuyModel.count == 0) {
            //添加警告框
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            alert.message = @"喵~没有交易记录哦~";
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

/*
 缓存余额数据:有网络的时候，更新本地余额数据，无网络的时候显示昨天的信息
 */
- (void) updateTodayData {
    //1.创建网络状态监测管理者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager  sharedManager];
    //2.监听改变
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus  status) {
        switch (status) {
            case  AFNetworkReachabilityStatusUnknown: {
                NSLog(@"未知");
                //缓存获取Cash余额
                NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
                NSDictionary *todayAry = [Utils getCache:account andID:@"TodayBuyModel"];
                _todayBuyModel = [KWTodayBuyModel mj_objectArrayWithKeyValuesArray:todayAry];
                [self.tableView reloadData];
                
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"没有网络");
                //缓存获取Cash余额
                NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
                NSDictionary *todayAry = [Utils getCache:account andID:@"TodayBuyModel"];
                _todayBuyModel = [KWTodayBuyModel mj_objectArrayWithKeyValuesArray:todayAry];
                [self.tableView reloadData];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                NSLog(@"3G|4G");
                [self.tableView.mj_header beginRefreshing];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"WiFi");
                [self.tableView.mj_header beginRefreshing];
                break;
            }
            default:
                break;
        }
    }];
    [manager startMonitoring];//开始监听
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return _todayBuyModel.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KWTodayBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todayBuyCell"];
    if (!cell) {
        cell = [[KWTodayBuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"todayBuyCell"];
    }
    if (indexPath.section == 0) {
        UITableViewCell *moneyCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"moneyCell"];
        moneyCell.textLabel.text = [NSString stringWithFormat:@"卡号(%@)",_cardModel.cardNum];
        moneyCell.detailTextLabel.text = [NSString stringWithFormat:@"%@元",_cardModel.cash];;
        return moneyCell;
    } else {
        KWTodayBuyModel *model = _todayBuyModel[indexPath.row];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 108;
    } else return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [NSString stringWithFormat:@"校园卡余额"];
    } else {
        return @"今日交易";
    }
}

@end
