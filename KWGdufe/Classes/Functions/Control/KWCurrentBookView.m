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
    
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    
    NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
    NSArray *currentDict = [Utils getCache:account andID:_modelSaveName];
    if (currentDict) {
        NSArray *currentModel = [KWCurrentModel mj_objectArrayWithKeyValuesArray:currentDict];
        _currentModel = currentModel;
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
