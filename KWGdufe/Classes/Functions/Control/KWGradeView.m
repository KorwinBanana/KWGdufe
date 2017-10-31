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

@interface KWGradeView ()

@property(nonatomic,strong) NSArray *gradeModel;

@end

@implementation KWGradeView

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的成绩";
    NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
    NSArray *gradeDict = [Utils getCache:account andID:@"GradeModel"];
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
    NSLog(@"self.frame.size.width2 = %f",KWSCreenW);
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
    [mgr POST:@"http://api.wegdufe.com:82/index.php?r=jw/get-grade" parameters:parements progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        [responseObject writeToFile:@"/Users/k/iOS-KW/project/KWGdufe/gradeModel.plist" atomically:nil];
        
        //获取字典
        NSDictionary *gradeDict = responseObject[@"data"];
        
        //缓存到本地
        [Utils saveCache:sno andID:@"GradeModel" andValue:gradeDict];
        
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
//        [SVProgressHUD dismiss];//
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
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
