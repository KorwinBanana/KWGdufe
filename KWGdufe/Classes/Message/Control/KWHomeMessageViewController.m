//
//  KWHomeMessageViewController.m
//  KWGdufe
//
//  Created by korwin on 2018/2/2.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWHomeMessageViewController.h"
#import "KeychainWrapper.h"
#import "KWAFNetworking.h"
#import <MJExtension/MJExtension.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "Utils.h"
#import "KWScheduleModel.h"
#import "KWTodayScheduleObject.h"
#import "KWRealm.h"
#import "KWInFoModel.h"
#import "KWHomeMCell.h"
#import <MJRefresh/MJRefresh.h>
#import "KWWebViewController.h"
#import "KWRealm.h"
#import "KWTodayBuyViewController.h"

@interface KWHomeMessageViewController ()

@property (nonatomic,strong) NSArray  *todayScheduleModel;
@property (nonatomic,strong) NSArray  *inFoModel;
@property (nonatomic,strong) NSArray  *homeBackGColors;

@end

@implementation KWHomeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _homeBackGColors = @[@"#1DB0B8",@"#37C6C0",@"#96B8FF",@"#0691CD",@"39A9CF",@"#F26A7A"];
    [self setupNavBar];
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    CGRect frame = CGRectMake(0, 0, 0, 0.1);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self setupHeadView];
    
    NSArray *inFoTipsDict = [Utils getCache:gdufeAccount andID:@"InFoTips"];
    if (inFoTipsDict) {
        NSArray *inFoTipsDModel = [KWInFoModel mj_objectArrayWithKeyValuesArray:inFoTipsDict];
        _inFoModel = inFoTipsDModel;
        [self.tableView reloadData];
    } else {
        [self.tableView.mj_header beginRefreshing];
    }
    NSLog(@"1 = %lf \n 2 = %lf \n 3= %lf \n4 = ",[[UIApplication sharedApplication] statusBarFrame].size.height, self.navigationController.navigationBar.frame.size.height);
}

- (void)setupHeadView {
    __unsafe_unretained UITableView *tableView = self.tableView;
    
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    
    tableView.mj_header= [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"结束刷新");
        [self loadData:[Utils getCache:gdufeAccount andID:@"stuTime"] week:[Utils getCache:gdufeAccount andID:@"schoolWeek"]];
        [self loadInFoTips];
    }];
    
    tableView.mj_header.automaticallyChangeAlpha = YES;
}

- (void)setupNavBar {
    self.navigationItem.title = @"今日";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _inFoModel.count + 2;
}

#pragma mark - cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];

    KWHomeMCell *cell = [[KWHomeMCell alloc]init];
    cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([KWHomeMCell class]) owner:nil options:nil][0];
    cell.backGColor = _homeBackGColors[indexPath.row];
    if (indexPath.row == 0) {
        NSArray *arraySchedule = [self getTodayClass];
        cell.masgTitle = [NSString stringWithFormat:@"【今天有%ld节课】",arraySchedule.count];
        
        NSString *classArrayName = [[NSString alloc]init];
        for (int i = 0; i<arraySchedule.count; i++) {
            KWScheduleModel *oneClassModel = arraySchedule[i];
            classArrayName = [NSString stringWithFormat:@"%@%@(第%ld-%ld节)",classArrayName,oneClassModel.name,oneClassModel.startSec,oneClassModel.endSec];
            if (i < arraySchedule.count - 1) {
                classArrayName = [NSString stringWithFormat:@"%@\n",classArrayName];
            }
        }
        cell.masgBody = classArrayName;
    } else if (indexPath.row == 1) {
        NSArray *arraySchedule = [self getTomorrowClass];
        cell.masgTitle = [NSString stringWithFormat:@"【明天有%ld节课】",arraySchedule.count];
        
        NSString *classArrayName = [[NSString alloc]init];
        for (int i = 0; i<arraySchedule.count; i++) {
            KWScheduleModel *oneClassModel = arraySchedule[i];
            classArrayName = [NSString stringWithFormat:@"%@%@(第%ld-%ld节)",classArrayName,oneClassModel.name,oneClassModel.startSec,oneClassModel.endSec];
            if (i < arraySchedule.count - 1) {
                classArrayName = [NSString stringWithFormat:@"%@\n",classArrayName];
            }
        }
        cell.masgBody = classArrayName;
    } else {
        KWInFoModel *model = _inFoModel[indexPath.row-2];
        cell.masgTitle = model.title;//设置标题
        if (indexPath.row == 2) {
            cell.masgBody = model.descrip;
        } else if (indexPath.row == 3) {
            cell.masgBody = [NSString stringWithFormat:@"您截止到昨天的余额是%@元。",[self charactersString:model.descrip]];
            [Utils saveCache:gdufeAccount andID:@"Money" andValue:[self charactersString:model.descrip]];
            NSLog(@"yue = %@",[self charactersString:model.descrip]);
        } else if (indexPath.row == 4) {
            cell.masgBody = model.descrip;
        } else if (indexPath.row == 5) {
            cell.masgBody = [NSString stringWithFormat:@"您共借阅%@本书。",[self charactersString:model.descrip]];
            [Utils saveCache:gdufeAccount andID:@"MyBBooks" andValue:[self charactersString:model.descrip]];//保存到本地沙盒
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row >= 2 && indexPath.row <=5) {
        if (indexPath.row == 3) {
            KWTodayBuyViewController *todayBuyVc = [[KWTodayBuyViewController alloc]init];
            [self.navigationController pushViewController:todayBuyVc animated:YES];
        } else {
            KWInFoModel *item = _inFoModel[indexPath.row-2];
            KWWebViewController *WebVc = [[KWWebViewController alloc] init];
            WebVc.url = [NSURL URLWithString:item.linkUrl];
            if (![item.linkUrl containsString:@"http"]) {
                return;
            }
            [self.navigationController pushViewController:WebVc animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 140;
}

- (NSString *)charactersString:(NSString *)s {
    NSMutableArray *characters = [NSMutableArray array];
    NSMutableString *mutStr = [NSMutableString string];
    
    for (int i = 0; i < s.length; i ++) {
        NSString *subString = [s substringToIndex:i + 1];
        subString = [subString substringFromIndex:i];
        [characters addObject:subString];
    }
    
    for (NSString *b in characters) {
        NSString *regex = @"^[0-9]*$";
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
        BOOL isShu = [pre evaluateWithObject:b];
        if (isShu) {
            [mutStr appendString:b];
        }
        if ([b isEqualToString:@"."]) {
            [mutStr appendString:b];
        }
    }
    return mutStr;
}

#pragma mark - 加载数据
- (void)loadInFoTips {
    
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        [KWAFNetworking postWithUrlString:@"http://api.wegdufe.com:82/index.php?r=info/info-tips" parameters:parements success:^(id data) {
            NSArray *inFoAry = data[@"data"];;
            
            [Utils saveCache:gdufeAccount andID:@"InFoTips" andValue:inFoAry];
            
            NSArray *inFoModel = [KWInFoModel mj_objectArrayWithKeyValuesArray:inFoAry];
            _inFoModel = inFoModel;
            NSLog(@"%@",inFoModel);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                NSLog(@"请求今日信息数据成功~");
            });
        } failure:^(NSError *error) {
            
        }];
    });
}

#pragma mark - 加载数据
- (void)loadData:(NSString *)selectStuTime week:(NSString *)selectWeek {
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    parements[@"stu_time"] = selectStuTime;
    parements[@"week"] = selectWeek;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        [KWAFNetworking postWithUrlString:@"http://api.wegdufe.com:82/index.php?r=jw/get-schedule" parameters:parements success:^(id data) {
            NSArray *scheduleAry = data[@"data"];;
            
            _todayScheduleModel = [KWScheduleModel mj_objectArrayWithKeyValuesArray:scheduleAry];
            
            RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
            KWTodayScheduleObject __block *scheduleObject = [[KWTodayScheduleObject alloc] init];
            RLMResults *results = [KWTodayScheduleObject allObjectsInRealm:real];
            
            if (!results) {
                NSLog(@"1");
                for (int i = 0; i<_todayScheduleModel.count; i++) {
                    scheduleObject = [[KWTodayScheduleObject alloc] initWithValue:_todayScheduleModel[i]];
                    [KWRealm saveRLMObject:real rlmObject:scheduleObject];
                }
            } else {
                NSLog(@"2");
                [real beginWriteTransaction];
                RLMResults *scheduleResults = [KWTodayScheduleObject allObjectsInRealm:real];
                [real deleteObjects:scheduleResults];
                [real commitWriteTransaction];
                
                KWScheduleModel *schModel = [[KWScheduleModel alloc] init];
                for (int i = 0; i<_todayScheduleModel.count; i++) {
                    schModel = _todayScheduleModel[i];
                    schModel.num = i;
                    scheduleObject = [[KWTodayScheduleObject alloc] initWithValue:schModel];
                    [KWRealm saveRLMObject:real rlmObject:scheduleObject];
                }
            }
            NSLog(@"请求今日课程数据成功~");

        } failure:^(NSError *error) {
            
        }];
    });
}

- (NSArray *) getTodayClass {
    RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
    RLMResults *results = [KWTodayScheduleObject allObjectsInRealm:real];
    //    NSInteger dataCount = [KWRealm getNumOfLine:results];
    NSMutableArray *arraySchedule = [NSMutableArray array];
    for (RLMObject *object in results) {
        KWScheduleModel *todayModel = object;
        if (todayModel.dayInWeek == [Utils getNowWeekday]) {
            [arraySchedule addObject:object];
        }
    }
    return arraySchedule;
}

- (NSArray *) getTomorrowClass {
    RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
    RLMResults *results = [KWTodayScheduleObject allObjectsInRealm:real];
    //    NSInteger dataCount = [KWRealm getNumOfLine:results];
    NSMutableArray *arraySchedule = [NSMutableArray array];
    for (RLMObject *object in results) {
        KWScheduleModel *todayModel = object;
        if (todayModel.dayInWeek == [Utils getNowWeekday]+1) {
            [arraySchedule addObject:object];
        }
    }
    return arraySchedule;
}

@end
