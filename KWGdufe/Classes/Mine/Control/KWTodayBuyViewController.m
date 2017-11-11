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
    self.navigationItem.title = @"今日交易";
    [SVProgressHUD showWithStatus:@"刷新今日交易"];
    
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    //状态栏高度
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    CGRect rectNav = self.navigationController.navigationBar.frame;
    
    //设置头部
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.contentInset = UIEdgeInsetsMake(rectStatus.size.height + rectNav.size.height, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        // 结束刷新
        [self loadTodayData];
        [tableView.mj_header endRefreshing];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    [self updateTodayData];
}

#pragma mark - 请求json
- (void)loadTodayData {
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    parements[@"cardNum"] = _cardModel.cardNum;
    
    [KWAFNetworking postWithUrlString:GetCurrentBookAPI parameters:parements success:^(id data) {
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
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:nil];
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
                [self loadTodayData];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"WiFi");
                [self loadTodayData];
                break;
            }
            default:
                break;
        }
    }];
    [manager startMonitoring];//开始监听
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _todayBuyModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KWTodayBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"todayBuyCell"];
    if (!cell) {
        cell = [[KWTodayBuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"todayBuyCell"];
    }
    KWTodayBuyModel *model = _todayBuyModel[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108;
}

@end
