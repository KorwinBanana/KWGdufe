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
    NSDictionary *cashAry = [Utils getCache:gdufeAccount andID:@"CardModel"];
    _cardModel = [KWCashModel mj_objectWithKeyValues:cashAry];
    if ([_cardModel.cardNum isEqualToString:@""]) {
        [self.tableView.mj_header beginRefreshing];
    } else {
        [self updateTodayData];
    }
    
}

#pragma mark - setupRefreshing
- (void)setupRefreshing {
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_queue_t queue = dispatch_queue_create("myCostom", DISPATCH_QUEUE_SERIAL);
        NSLog(@"updateCashData start");
        dispatch_async(queue, ^{
            [self updateCashData];
            NSLog(@"updateCashData end");
        });
        
        NSLog(@"updateTodayData start");
        dispatch_async(queue, ^{
            [self loadTodayData];
            NSLog(@"updateTodayData end");
        });
        [tableView.mj_header endRefreshing];
    }];
    
    tableView.mj_header.automaticallyChangeAlpha = YES;
}

#pragma mark - 请求json
- (void)loadTodayData {
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    parements[@"cardNum"] = _cardModel.cardNum;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        [KWAFNetworking postWithUrlString:GetTodayCashAPI parameters:parements success:^(id data) {
            NSDictionary *todayDict = data[@"data"];
            
            [Utils updateCache:gdufeAccount andID:@"TodayBuyModel" andValue:todayDict];
            NSLog(@"更新成功");
            
            _todayBuyModel = [KWTodayBuyModel mj_objectArrayWithKeyValuesArray:todayDict];
            
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                if(_todayBuyModel.count == 0) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:okAction];
                    alert.message = @"喵~没有交易记录哦~";
                    [self presentViewController:alert animated:YES completion:nil];
                }
                [self.tableView reloadData];
                [SVProgressHUD dismiss]; // 3
            });
        } failure:^(NSError *error) {
            
        }];
    });
}

- (void) updateTodayData {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager  sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus  status) {
        switch (status) {
            case  AFNetworkReachabilityStatusUnknown: {
                NSLog(@"未知");
                NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
                NSDictionary *todayAry = [Utils getCache:account andID:@"TodayBuyModel"];
                _todayBuyModel = [KWTodayBuyModel mj_objectArrayWithKeyValuesArray:todayAry];
                [self.tableView reloadData];
                
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"没有网络");
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

- (void) updateCashData {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager  sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus  status) {
        switch (status) {
            case  AFNetworkReachabilityStatusUnknown: {
                NSLog(@"未知");
                NSDictionary *cashAry = [Utils getCache:gdufeAccount andID:@"CardModel"];
                _cardModel = [KWCashModel mj_objectWithKeyValues:cashAry];
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"没有网络");
                //缓存获取Cash余额
                NSDictionary *cashAry = [Utils getCache:gdufeAccount andID:@"CardModel"];
                _cardModel = [KWCashModel mj_objectWithKeyValues:cashAry];
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

- (void)loadCardData {
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        [KWAFNetworking postWithUrlString:GetCashAPI parameters:parements success:^(id data) {
            NSDictionary *cardDict = data[@"data"];
            
            [Utils updateCache:gdufeAccount andID:@"CardModel" andValue:cardDict];
            
            _cardModel = [KWCashModel mj_objectWithKeyValues:cardDict];
            
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                [self.tableView reloadData]; // 3
            });
        } failure:^(NSError *error) {
            
        }];
    });
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
