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

    RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
    RLMResults *results = [KWSztzObject allObjectsInRealm:real];
    NSInteger dataCount = [KWRealm getNumOfLine:results];
    if (!dataCount) {
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
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //    self.tableView.contentInset = UIEdgeInsetsMake(rectStatus.size.height + rectNav.size.height, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadData];
    }];
    
    tableView.mj_header.automaticallyChangeAlpha = YES;
}

#pragma mark - 加载数据
- (void)loadData {
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    
    [KWAFNetworking postWithUrlString:GetSztzAPI vController:self parameters:parements success:^(id data) {
        NSDictionary *sztzDict = data[@"data"];
        
        NSArray *sztzArray = [KWSztzModel mj_objectArrayWithKeyValuesArray:sztzDict];
        
        //存入数据库
        RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
        KWSztzObject *sztzObject = [[KWSztzObject alloc] init];
        RLMResults *results = [KWSztzObject allObjectsInRealm:real];
        if (!results) {
            for (int i = 0; i<sztzArray.count; i++) {
                sztzObject = [[KWSztzObject alloc] initWithValue:sztzArray[i]];
                [KWRealm saveRLMObject:real rlmObject:sztzObject];
            }
        } else {
            for (int i = 0; i<sztzArray.count; i++) {
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            NSLog(@"请求素拓数据成功~");
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
