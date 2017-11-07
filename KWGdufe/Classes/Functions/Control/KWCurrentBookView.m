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
//#import "KWSztzCell.h"

@interface KWCurrentBookView ()

@property(nonatomic,strong) NSArray *currentModel;

@end

@implementation KWCurrentBookView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = _vcName;
    
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
        dispatch_async(dispatch_get_main_queue(), ^{
            // 结束刷新
            [self loadData];
            [tableView.mj_header endRefreshing];
        });
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
    
    NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
    NSArray *currentDict = [Utils getCache:account andID:_modelSaveName];
    if (currentDict) {
        NSArray *currentModel = [KWCurrentModel mj_objectArrayWithKeyValuesArray:currentDict];
        _currentModel = currentModel;
    } else {
        [tableView.mj_header beginRefreshing];
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
    [mgr POST:_url parameters:parements progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        [responseObject writeToFile:@"/Users/k/iOS-KW/project/KWGdufe/currentModel.plist" atomically:nil];
        
        //获取字典
        NSDictionary *currentBookDict = responseObject[@"data"];
        
        //缓存到本地
        [Utils saveCache:sno andID:_modelSaveName andValue:currentBookDict];
        
        //字典转模型
        NSArray *currentArray = [KWCurrentModel mj_objectArrayWithKeyValuesArray:currentBookDict];
        _currentModel = currentArray;
        
        [self.tableView reloadData];
        NSLog(@"刷新成功");
//        [self.tableView.mj_header beginRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 174;
}

@end
