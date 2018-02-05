//
//  KWCurrentBookView.m
//  KWGdufe
//
//  Created by korwin on 2017/11/1.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWHisCurrentBookView.h"
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
#import "KWBorrowCell.h"
#import "KWGoOnBookViewController.h"
#import "KWHisCurrentObject.h"
#import "KWRealm.h"
//#import "KWSztzCell.h"

@interface KWHisCurrentBookView ()

@property(nonatomic,strong) NSArray *currentModel;

@end

@implementation KWHisCurrentBookView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _vcName;
    
    [self setupHeadView];
    
//    NSArray *currentDict = [Utils getCache:gdufeAccount andID:_modelSaveName];
//    if (currentDict) {
//        NSArray *currentModel = [KWCurrentModel mj_objectArrayWithKeyValuesArray:currentDict];
//        _currentModel = currentModel;
//        [self.tableView reloadData];
//    } else {
//        [self.tableView.mj_header beginRefreshing];
//    }
    RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
    RLMResults *results = [KWHisCurrentObject allObjectsInRealm:real];
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
        _currentModel = array;
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
    
    [KWAFNetworking postWithUrlString:_url vController:self parameters:parements success:^(id data) {
        //获取字典
        NSDictionary *borrowBookDict = data[@"data"];
        //获取code
        NSString *code = [data objectForKey:@"code"];
        NSString *codeStr = [NSString stringWithFormat:@"%@",code];
        
        if ([codeStr isEqualToString:@"0"]) {
            //字典转模型
            NSArray *borrowArray = [KWCurrentModel mj_objectArrayWithKeyValuesArray:borrowBookDict];
            
            //缓存到本地
            //        [Utils saveCache:gdufeAccount andID:_modelSaveName andValue:currentBookDict];
            
            //存入数据库
            RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
            KWHisCurrentObject *borrowObject = [[KWHisCurrentObject alloc] init];
            RLMResults *results = [KWHisCurrentObject allObjectsInRealm:real];
            if (!results) {
                //没有数据
                for (int i = 0; i<borrowArray.count; i++) {
                    borrowObject = [[KWHisCurrentObject alloc] initWithValue:borrowArray[i]];
                    [KWRealm saveRLMObject:real rlmObject:borrowObject];
                }
            } else {
                //有数据
                for (int i = 0; i<borrowArray.count; i++) {
                    borrowObject = [[KWHisCurrentObject alloc] initWithValue:borrowArray[i]];
                    [KWRealm addOrUpdateObject:real rlmObject:borrowObject];
                }
            }
            
            _currentModel = borrowArray;
            
            dispatch_async(dispatch_get_main_queue(), ^{ //主线程刷新界面
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];//结束下拉刷新
            });
        } else if ([codeStr isEqualToString:@"3001"]) {
            dispatch_async(dispatch_get_main_queue(), ^{ //主线程刷新界面
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"密码错误"]];
                [self.tableView.mj_header endRefreshing];//结束下拉刷新
            });
        } else if ([codeStr isEqualToString:@"2003"]) {
            dispatch_async(dispatch_get_main_queue(), ^{ //主线程刷新界面2003
                [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"图书馆系统崩溃了"]];
                [self.tableView.mj_header endRefreshing];//结束下拉刷新
            });
        }
    } failure:^(NSError *error) {
        
    } noNetworking:^{
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _currentModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_boolHistory == 0) {
        KWCurrentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[KWCurrentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        KWCurrentModel *model = _currentModel[indexPath.row];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        KWBorrowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        if (!cell) {
            cell = [[KWBorrowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
        }
        KWCurrentModel *model = _currentModel[indexPath.row];
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_boolHistory == 0) {
        return 174;
    } else return 152;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_boolHistory == 0) {
        KWCurrentModel *model = _currentModel[indexPath.row];
        //UIAlertController风格：UIAlertControllerStyleAlert
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"续借《%@》",model.name]
                                                                                 message:nil
                                                                          preferredStyle:UIAlertControllerStyleAlert ];
        
        //添加取消到UIAlertController中
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        
        //添加确定到UIAlertController中
        UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            KWGoOnBookViewController *goOnView = [[KWGoOnBookViewController alloc]init];
            goOnView.title = [NSString stringWithFormat:@"续借:%@",model.name];
            goOnView.name = model.name;
            goOnView.barId = model.barId;
            goOnView.checkId = model.checkId;
            goOnView.KWCBVc = self;
            [self.navigationController pushViewController:goOnView animated:YES];
            NSLog(@"确认续借");
        }];
        [alertController addAction:OKAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

@end
