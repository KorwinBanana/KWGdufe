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
    
    [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"gradeSelectYear"]];
    
    [self setupRefreshing];
    
    RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
    RLMResults *results = [KWGradeObject allObjectsInRealm:real];
    NSInteger dataCount = [KWRealm getNumOfLine:results];
    if (!dataCount) {
        [self.tableView.mj_header beginRefreshing];
    } else {
        NSMutableArray *array = [NSMutableArray array];
        
        if ([[Utils getCache:gdufeAccount andID:@"gradeSelectYear"] isEqualToString:@"全部"]) {
            for (RLMObject *object in results) {
                [array addObject:object];
            }
        } else {
            for (RLMObject *object in results) {
                KWGradeModel *model = object;
                if ([model.time isEqualToString:[Utils getCache:gdufeAccount andID:@"gradeSelect"]])
                    [array addObject:object];
            }
        }
        _gradeModel = array;
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
        RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
        RLMResults *results = [KWGradeObject allObjectsInRealm:real];
        
        if (!results) {
            [self loadDataWithStuTime:0];
        } else {
            if ([[Utils getCache:gdufeAccount andID:@"gradeSelectYear"] isEqualToString:@"全部"]) {
                [self loadDataWithStuTime:0];
            } else {
                [self loadGradeData:[Utils getCache:gdufeAccount andID:@"gradeSelect"]];
            }
            [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"gradeSelectYear"]];
        }
    }];
    
    tableView.mj_header.automaticallyChangeAlpha = YES;
}

- (void)setupNavBarRightName:(NSString *)rightName {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithString:rightName target:self action:@selector(selectYear)];
    self.navigationItem.title = @"我的成绩";
}

- (void)selectYear {
    NSMutableArray *stuTimes = [Utils getCache:gdufeAccount andID:@"stuTimes"];
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]initWithTitle:@"学期" rows:stuTimesForGrade initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        dispatch_queue_t HUDQueue = dispatch_queue_create("HUDQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(HUDQueue, ^{
            [SVProgressHUD show];
            sleep(1);
            if(selectedIndex == 0){
                [Utils updateCache:gdufeAccount andID:@"gradeSelect" andValue:@"全部"];
                [Utils updateCache:gdufeAccount andID:@"gradeSelectYear" andValue:selectedValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadGradeAllData];
                    [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"gradeSelectYear"]];
                });
            } else {
                [Utils updateCache:gdufeAccount andID:@"gradeSelect" andValue:stuTimes[selectedIndex-1]];
                [Utils updateCache:gdufeAccount andID:@"gradeSelectYear" andValue:selectedValue];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self loadGradeData:stuTimes[selectedIndex-1]];
                    [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"gradeSelectYear"]];
                });
            }
        });
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
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    parements[@"stu_time"] = stuTimeForGrade;
    
    [KWAFNetworking postWithUrlString:GetGradeAPI vController:self parameters:parements success:^(id data) {
        NSDictionary *gradeDict = data[@"data"];
        
        [Utils saveCache:gdufeAccount andID:@"GradeModel" andValue:gradeDict];
        
        NSArray *gradeModel = [KWGradeModel mj_objectArrayWithKeyValuesArray:gradeDict];
        RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
        KWGradeObject *gradeObject = [[KWGradeObject alloc] init];
        RLMResults *results = [KWGradeObject allObjectsInRealm:real];
        if (!results) {
            for (int i = 0; i<gradeModel.count; i++) {
                gradeObject = [[KWGradeObject alloc] initWithValue:gradeModel[i]];
                [KWRealm saveRLMObject:real rlmObject:gradeObject];
            }
        } else {
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
        NSLog(@"%@",docDir);
        
        _gradeModel = array;
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
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
    [SVProgressHUD dismiss];
    [self.tableView.mj_header endRefreshing];
}

//请求整个学期课程
- (void)loadGradeAllData {
    RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
    RLMResults *results = [KWGradeObject allObjectsInRealm:real];
    
    NSMutableArray *array = [NSMutableArray array];
    for (RLMObject *object in results) {
            [array addObject:object];
    }
    
    _gradeModel = array;
    
    [self.tableView reloadData];
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
