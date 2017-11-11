//
//  KWGradeView.m
//  KWGdufe
//
//  Created by korwin on 2017/10/27.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWGradeView.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "KWGradeModel.h"
#import <MJRefresh/MJRefresh.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Utils.h"
#import "KeychainWrapper.h"
#import "KWGradeCell.h"
#import "KWAFNetworking.h"
#import "KWRequestUrl.h"

@interface KWGradeView ()

@property(nonatomic,strong) NSArray *gradeModel;

@end

@implementation KWGradeView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的成绩";
    NSArray *gradeDict = [Utils getCache:gdufeAccount andID:@"GradeModel"];
    if (gradeDict) {
        NSArray *gradeModel = [KWGradeModel mj_objectArrayWithKeyValuesArray:gradeDict];
        NSMutableArray *gradeDictTimes = [[NSMutableArray alloc]init];
        for (KWGradeModel *gradeDictTime in gradeModel) {
            if ([gradeDictTime.time isEqualToString:@"2015-2016-2"]) {
                [gradeDictTimes addObject:gradeDictTime];
            }
        }
        _gradeModel = gradeDictTimes;
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
    
    [KWAFNetworking postWithUrlString:GetGradeAPI parameters:parements success:^(id data) {
        //获取字典
        NSDictionary *gradeDict = data[@"data"];
        
        //缓存到本地
        [Utils saveCache:gdufeAccount andID:@"GradeModel" andValue:gradeDict];
        
        //字典转模型
        NSArray *gradeModel = [KWGradeModel mj_objectArrayWithKeyValuesArray:gradeDict];
        NSMutableArray *gradeDictTimes = [[NSMutableArray alloc]init];
        
        //获取大三下学期成绩
        for (KWGradeModel *gradeDictTime in gradeModel) {
            if ([gradeDictTime.time isEqualToString:@"2016-2017-2"]) {
                [gradeDictTimes addObject:gradeDictTime];
            }
        }
        _gradeModel = gradeDictTimes;
        
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _gradeModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KWGradeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
       cell = [[KWGradeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    KWGradeModel *model = _gradeModel[indexPath.row];
    cell.model = model;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 88;
}

@end
