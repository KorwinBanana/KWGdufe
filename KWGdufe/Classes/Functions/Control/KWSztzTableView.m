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
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    
    [KWAFNetworking postWithUrlString:GetSztzAPI parameters:parements success:^(id data) {
        //获取字典
        NSDictionary *sztzDict = data[@"data"];
        
        //缓存到本地
        [Utils saveCache:gdufeAccount andID:@"SztzModel" andValue:sztzDict];
        
        //字典转模型
        NSArray *sztzArray = [KWSztzModel mj_objectArrayWithKeyValuesArray:sztzDict];
        _sztzModel = sztzArray;
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
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
