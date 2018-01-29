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
#import <ActionSheetPicker-3.0/ActionSheetStringPicker.h>
#import "KWRealm.h"
#import "KWGradeObject.h"

@interface KWGradeView ()

@property(nonatomic,strong) NSArray *gradeModel;

@end

@implementation KWGradeView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"schoolYearForGrade"]];
    
    [self setupRefreshing];
    
//    NSArray *gradeDict = [Utils getCache:gdufeAccount andID:@"GradeModel"];
//    if (gradeDict) {
//        NSArray *gradeModel = [KWGradeModel mj_objectArrayWithKeyValuesArray:gradeDict];
//        _gradeModel = gradeModel;
//        [self.tableView reloadData];
//    } else {
//        [self.tableView.mj_header beginRefreshing];
//    }
    
    RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
    RLMResults *results = [KWGradeObject allObjectsInRealm:real];
    
    if (!results) {
        //无
        [self.tableView.mj_header beginRefreshing];
    } else {
        //有
//        [self loadGradeData:[Utils getCache:gdufeAccount andID:@"schoolYearForGrade"]];
        NSMutableArray *array = [NSMutableArray array];
        for (RLMObject *object in results) {
            KWGradeModel *model = object;
            if ([model.time isEqualToString:[Utils getCache:gdufeAccount andID:@"stuTimeForGrade"]])
                [array addObject:object];
        }
        _gradeModel = array;
//        [self.tableView reloadData];
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
        [self loadDataWithStuTime:0];
        [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"schoolYearForGrade"]];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    tableView.mj_header.automaticallyChangeAlpha = YES;
}

- (void)setupNavBarRightName:(NSString *)rightName {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithString:rightName target:self action:@selector(selectYear)];
    self.navigationItem.title = @"我的成绩";
}

- (void)selectYear {
    NSMutableArray *stuTimes = [Utils getCache:gdufeAccount andID:@"stuTimes"];
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]initWithTitle:@"学期" rows:stuTimesForGrade initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if(selectedIndex == 0){
            [KWAFNetworking iSNetWorkingWithController:self isNetworking:^{
                [SVProgressHUD showWithStatus:@"刷新中~"];
                [self loadDataWithStuTime:0];
                [Utils updateCache:gdufeAccount andID:@"schoolYearForGrade" andValue:selectedValue];
                [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"schoolYearForGrade"]];
            } noNetworking:^{
                NSLog(@"Block Picker Canceled");
            }];
        } else {
            [KWAFNetworking iSNetWorkingWithController:self isNetworking:^{
                [SVProgressHUD showWithStatus:@"刷新中~"];
                [Utils updateCache:gdufeAccount andID:@"stuTimeForGrade" andValue:stuTimes[selectedIndex-1]];
//                [self loadDataWithStuTime:[Utils getCache:gdufeAccount andID:@"stuTimeForGrade"]];
                [self loadGradeData:stuTimes[selectedIndex-1]];
                [Utils updateCache:gdufeAccount andID:@"schoolYearForGrade" andValue:selectedValue];
                [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"schoolYearForGrade"]];
            } noNetworking:^{
                NSLog(@"Block Picker Canceled");
            }];
        }
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        NSLog(@"Block Picker Canceled");
    } origin:self.view];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[Utils colorWithHexString:@"#2E47AC"] forState:UIControlStateHighlighted];
    [cancelButton setFrame:CGRectMake(0, 0, 32, 32)];
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:[Utils colorWithHexString:@"#2E47AC"] forState:UIControlStateHighlighted];
    [doneButton setFrame:CGRectMake(0, 0, 32, 32)];
    [picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    [picker showActionSheetPicker];
}

#pragma mark - 加载数据
- (void)loadDataWithStuTime:(NSString *)stuTimeForGrade {
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    parements[@"stu_time"] = stuTimeForGrade;
    
    [KWAFNetworking postWithUrlString:GetGradeAPI vController:self parameters:parements success:^(id data) {
        //获取字典
        NSDictionary *gradeDict = data[@"data"];
        
        //缓存到本地
        [Utils saveCache:gdufeAccount andID:@"GradeModel" andValue:gradeDict];
        
        //字典转模型
        NSArray *gradeModel = [KWGradeModel mj_objectArrayWithKeyValuesArray:gradeDict];
        
//        NSMutableArray *gradeDictTimes = [[NSMutableArray alloc]init];
//
//        //获取大三下学期成绩
//        for (KWGradeModel *gradeDictTime in gradeModel) {
//            if ([gradeDictTime.time isEqualToString:@"2016-2017-2"]) {
//                [gradeDictTimes addObject:gradeDictTime];
//            }
//        }
        
        //存入数据库
        RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
        KWGradeObject *gradeObject = [[KWGradeObject alloc] init];
        RLMResults *results = [KWGradeObject allObjectsInRealm:real];
        if (!results) {
            //没有数据
            for (int i = 0; i<gradeModel.count; i++) {
                gradeObject = [[KWGradeObject alloc] initWithValue:gradeModel[i]];
                [KWRealm saveRLMObject:real rlmObject:gradeObject];
            }
        } else {
            //有数据
            for (int i = 0; i<gradeModel.count; i++) {
                gradeObject = [[KWGradeObject alloc] initWithValue:gradeModel[i]];
                [KWRealm addOrUpdateObject:real rlmObject:gradeObject];
            }
        }

        NSMutableArray *array = [NSMutableArray array];
        for (RLMObject *object in results) {
            [array addObject:object];
        }
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docDir = [paths objectAtIndex:0];
        NSLog(@"****************results******************* = %@",results);
        NSLog(@"****************array******************* = %@",array);
        NSLog(@"%ld",results.count);
        NSLog(@"%@",docDir);
        
        _gradeModel = array;
        
        NSLog(@"%@",gradeModel);
        
        dispatch_async(dispatch_get_main_queue(), ^{ //主线程刷新界面
            [self.tableView reloadData];
            NSLog(@"请求成绩数据成功~");
            [SVProgressHUD dismiss];
            [self.tableView.mj_header endRefreshing];
        });
    } failure:^(NSError *error) {
        
    } noNetworking:^{
        [self.tableView.mj_header endRefreshing];
    }];
}

- (void)loadGradeData:(NSString *)stuTimeForGrade {
    RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
    RLMResults *results = [KWGradeObject allObjectsInRealm:real];

    NSMutableArray *array = [NSMutableArray array];
    for (RLMObject *object in results) {
        KWGradeModel *model = object;
        if ([model.time isEqualToString:stuTimeForGrade])
            [array addObject:object];
    }

    _gradeModel = array;

    [self.tableView reloadData];
    NSLog(@"选择学期成绩数据成功~");
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
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
