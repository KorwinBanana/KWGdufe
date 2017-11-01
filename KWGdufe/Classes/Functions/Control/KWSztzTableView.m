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

@interface KWSztzTableView ()

@property(nonatomic,strong) NSArray *sztzModel;

@end

@implementation KWSztzTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"素拓信息";
    NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
    NSArray *sztzDict = [Utils getCache:account andID:@"SztzModel"];
    if (sztzDict) {
        NSArray *sztzArray = [KWSztzModel mj_objectArrayWithKeyValuesArray:sztzDict];
        _sztzModel = sztzArray;
    } else {
        [self loadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [mgr POST:@"http://api.wegdufe.com:82/index.php?r=info/few-sztz" parameters:parements progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        [responseObject writeToFile:@"/Users/k/iOS-KW/project/KWGdufe/gradeModel.plist" atomically:nil];
        
        //获取字典
        NSDictionary *sztzDict = responseObject[@"data"];

        //缓存到本地
        [Utils saveCache:sno andID:@"SztzModel" andValue:sztzDict];

        //字典转模型
        NSArray *sztzArray = [KWSztzModel mj_objectArrayWithKeyValuesArray:sztzDict];
        _sztzModel = sztzArray;

        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
