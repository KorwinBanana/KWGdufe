//
//  KWSztzTableView.m
//  KWGdufe
//
//  Created by korwin on 2017/10/30.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWSztzTableView.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "KWSztzModel.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Utils.h"
#import "KeychainWrapper.h"
#import "KWSztzCell.h"
#import "KWAFNetworking.h"
#import "KWRequestUrl.h"
#import "KWRealm.h"
#import "KWSztzObject.h"

@interface KWSztzTableView ()

@property(nonatomic,strong) NSArray *sztzModel;

@end

@implementation KWSztzTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"素拓信息";
    [self setupRefreshing];

    RLMRealm *real = [KWRealm getRealmWith:mineDataBase];
    RLMResults *results = [KWSztzObject allObjectsInRealm:real];
    
    if (!results.count) {
        //无
        [self.tableView.mj_header beginRefreshing];
        NSLog(@"无");
    } else {
        //有
        NSMutableArray *array = [NSMutableArray array];
        for (RLMObject *object in results) {
            [array addObject:object];
        }
        NSLog(@"有");
        _sztzModel = array;
    }
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
        [self loadData];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
}

#pragma mark - 加载数据
- (void)loadData {
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    
    [KWAFNetworking postWithUrlString:GetSztzAPI vController:self parameters:parements success:^(id data) {
        //获取字典
        NSDictionary *sztzDict = data[@"data"];
        
        //缓存到本地
//        [Utils saveCache:gdufeAccount andID:@"SztzModel" andValue:sztzDict];
        
        //字典转模型
        NSArray *sztzArray = [KWSztzModel mj_objectArrayWithKeyValuesArray:sztzDict];
//        _sztzModel = sztzArray;
        
        //存入数据库
        RLMRealm *real = [KWRealm getRealmWith:mineDataBase];
        KWSztzObject *sztzObject = [[KWSztzObject alloc] init];
        RLMResults *results = [KWSztzObject allObjectsInRealm:real];
        if (!results) {
            for (int i = 0; i<6; i++) {
                sztzObject = [[KWSztzObject alloc] initWithValue:sztzArray[i]];
                [KWRealm saveRLMObject:real rlmObject:sztzObject];
            }
        } else {
            for (int i = 0; i<6; i++) {
                sztzObject = [[KWSztzObject alloc] initWithValue:sztzArray[i]];
                [KWRealm addOrUpdateObject:real rlmObject:sztzObject];
            }
        }
        
        NSMutableArray *array = [NSMutableArray array];
        for (RLMObject *object in results) {
            [array addObject:object];
        }
        NSLog(@"****************results******************* = %@",results);
        NSLog(@"****************array******************* = %@",array);
        NSLog(@"%ld",(long)array.count);
        _sztzModel = array;
        
        dispatch_async(dispatch_get_main_queue(), ^{ //主线程刷新界面
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
    } failure:^(NSError *error) {
        
    } noNetworking:^{
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _sztzModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KWSztzCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];

    if (!cell) {
        cell = [[KWSztzCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
    }
    KWSztzModel *model = _sztzModel[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 74;
}

@end
