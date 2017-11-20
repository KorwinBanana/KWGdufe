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

@interface KWGradeView ()

@property(nonatomic,strong) NSArray *gradeModel;

@end

@implementation KWGradeView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"schoolYearForGrade"]];
    [SVProgressHUD showWithStatus:@"刷新中~"];
    NSArray *gradeDict = [Utils getCache:gdufeAccount andID:@"GradeModel"];
    if (gradeDict) {
        NSArray *gradeModel = [KWGradeModel mj_objectArrayWithKeyValuesArray:gradeDict];
        _gradeModel = gradeModel;
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
    } else {
        [self loadDataWithStuTime:[Utils getCache:gdufeAccount andID:@"stuTimeForGrade"]];
    }
}

- (void)setupNavBarRightName:(NSString *)rightName {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithString:rightName target:self action:@selector(selectYear)];
    self.navigationItem.title = @"我的成绩";
}

- (void)selectYear {
    NSMutableArray *stuTimes = [Utils getCache:gdufeAccount andID:@"stuTimes"];
    
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]initWithTitle:@"学期" rows:stuTimesForGrade initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        if(selectedIndex == 0){
            [SVProgressHUD showWithStatus:@"刷新中~"];
            [self loadDataWithStuTime:0];
            [Utils updateCache:gdufeAccount andID:@"schoolYearForGrade" andValue:selectedValue];
            [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"schoolYearForGrade"]];
        } else {
            [SVProgressHUD showWithStatus:@"刷新中~"];
            [Utils updateCache:gdufeAccount andID:@"stuTimeForGrade" andValue:stuTimes[selectedIndex-1]];
            [self loadDataWithStuTime:[Utils getCache:gdufeAccount andID:@"stuTimeForGrade"]];
            [Utils updateCache:gdufeAccount andID:@"schoolYearForGrade" andValue:selectedValue];
            [self setupNavBarRightName:[Utils getCache:gdufeAccount andID:@"schoolYearForGrade"]];
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
    
    [KWAFNetworking postWithUrlString:GetGradeAPI parameters:parements success:^(id data) {
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
        
        _gradeModel = gradeModel;
        
        [self.tableView reloadData];
        [SVProgressHUD dismiss];
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
