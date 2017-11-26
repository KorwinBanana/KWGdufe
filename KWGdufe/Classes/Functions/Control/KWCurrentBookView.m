//
//  KWCurrentBookView.m
//  KWGdufe
//
//  Created by korwin on 2017/11/1.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWCurrentBookView.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "KWCurrentModel.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Utils.h"
#import "KeychainWrapper.h"
#import "KWCurrentCell.h"
#import <MJRefresh/MJRefresh.h>
#import "KWAFNetworking.h"
#import "KWRequestUrl.h"
#import "KWSBookMostMsgView.h"
//#import "KWSztzCell.h"

@interface KWCurrentBookView ()

@property(nonatomic,strong) NSArray *currentModel;

@end

@implementation KWCurrentBookView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _vcName;
    
    [self setupHeadView];
    
    NSArray *currentDict = [Utils getCache:gdufeAccount andID:_modelSaveName];
    if (currentDict) {
        NSArray *currentModel = [KWCurrentModel mj_objectArrayWithKeyValuesArray:currentDict];
        _currentModel = currentModel;
        [self.tableView reloadData];
    } else {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (void)setupHeadView {
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    //设置头部
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //    self.tableView.contentInset = UIEdgeInsetsMake(-rectStatus.size.height - rectNav.size.height, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    // 下拉刷新
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            // 结束刷新
            [self loadData];
        });
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
    
//    [KWAFNetworking postWithUrlString:_url parameters:parements success:^(id data) {
//        //获取字典
//        NSDictionary *currentBookDict = data[@"data"];
//
//        //缓存到本地
//        [Utils saveCache:gdufeAccount andID:_modelSaveName andValue:currentBookDict];
//
//        //字典转模型
//        NSArray *currentArray = [KWCurrentModel mj_objectArrayWithKeyValuesArray:currentBookDict];
//        _currentModel = currentArray;
//
//        [self.tableView reloadData];
//        NSLog(@"刷新成功");
//    } failure:^(NSError *error) {
//
//    }];
    [KWAFNetworking postWithUrlString:_url vController:self parameters:parements success:^(id data) {
        //获取字典
        NSDictionary *currentBookDict = data[@"data"];
        
        //缓存到本地
        [Utils saveCache:gdufeAccount andID:_modelSaveName andValue:currentBookDict];
        
        //字典转模型
        NSArray *currentArray = [KWCurrentModel mj_objectArrayWithKeyValuesArray:currentBookDict];
        _currentModel = currentArray;
        
        dispatch_async(dispatch_get_main_queue(), ^{ //主线程刷新界面
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];//结束下拉刷新
//            NSLog(@"刷新成功");
        });
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KWCurrentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[KWCurrentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    KWCurrentModel *model = _currentModel[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KWSBookMostMsgView *sbVc = [[KWSBookMostMsgView alloc]init];
    [self.navigationController pushViewController:sbVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 174;
}

@end
