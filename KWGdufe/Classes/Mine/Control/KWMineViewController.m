//
//  KWMineViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/9/28.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWMineViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "KWStuModel.h"
#import "KWMineMsgViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "KeychainWrapper.h"
#import "KWMyMsgCell.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Utils.h"
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import "KWCashModel.h"
#import "KWTodayBuyViewController.h"
#import "KWAFNetworking.h"
#import "KWRequestUrl.h"
#import "KWLogoutCell.h"
#import "KWIntroduceViewController.h"
#import "KWRealm.h"
#import "KWTodayScheduleObject.h"
#import "KWScheduleModel.h"
#import "KWSztzObject.h"
#import "KWEducationalViewCell.h"
#import "KWLibraryViewCell.h"
#import "KWOtherFuncViewCell.h"
#import "KWAboutViewController.h"
#import "KWSettingTableViewController.h"

@interface KWMineViewController ()<KWPushDelegate,KWLibraryPushDelegate,KWOtherPushDelegate>

@property (nonatomic,strong) KWStuModel *stuModel;
@property (nonatomic,strong) KWCashModel *cardModel;
@property (nonatomic,strong) KWMineMsgViewController  *msgVc;
@property (nonatomic,strong) KWTodayBuyViewController *todayBuyVc;

@end

@implementation KWMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *sno = [wrapper myObjectForKey:(id)kSecAttrAccount];
    _stuTime = [Utils getCache:sno andID:@"stuTime"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.msgVc = [[KWMineMsgViewController alloc]init];
    self.todayBuyVc = [[KWTodayBuyViewController alloc]init];//初始化二级页面

    [self setupNavBar];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.bounds style:UITableViewStyleGrouped];
    
    NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
    NSDictionary *cashAry = [Utils getCache:account andID:@"CardModel"];
    _cardModel = [KWCashModel mj_objectWithKeyValues:cashAry];
    self.todayBuyVc.cardModel = _cardModel;
    
    [self getDataFromCache];
    
    [self updateCashData];
}

- (void)getDataFromCache {
    NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
    NSDictionary *stuDict = [Utils getCache:account andID:@"StuModel"];
    if (stuDict) {
        _stuModel = [KWStuModel mj_objectWithKeyValues:stuDict];
        self.msgVc.stuModel = _stuModel;
        [SVProgressHUD dismiss];
        [self.tableView reloadData];
    } else {
        [self loadData];
    }
}

#pragma mark - 加载数据
- (void)loadData {
    
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        [KWAFNetworking postWithUrlString:GetBasicAPI parameters:parements success:^(id data) {
            NSDictionary *stuDict = data[@"data"];
            
            [Utils saveCache:gdufeAccount andID:@"StuModel" andValue:stuDict];
            
            _stuModel = [KWStuModel mj_objectWithKeyValues:stuDict];
            self.msgVc.stuModel = _stuModel;
            
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                [self.tableView reloadData];
                [SVProgressHUD dismiss]; // 3
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
            
            NSArray *todayScheduleModel = [KWScheduleModel mj_objectArrayWithKeyValuesArray:scheduleAry];
            
            RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
            KWTodayScheduleObject __block *scheduleObject = [[KWTodayScheduleObject alloc] init];
            RLMResults *results = [KWTodayScheduleObject allObjectsInRealm:real];
            
            if (!results) {
                NSLog(@"1");
                for (int i = 0; i<todayScheduleModel.count; i++) {
                    scheduleObject = [[KWTodayScheduleObject alloc] initWithValue:todayScheduleModel[i]];
                    [KWRealm saveRLMObject:real rlmObject:scheduleObject];
                }
            } else {
                NSLog(@"2");
                [real beginWriteTransaction];
                RLMResults *scheduleResults = [KWTodayScheduleObject allObjectsInRealm:real];
                [real deleteObjects:scheduleResults];
                [real commitWriteTransaction];
                
                KWScheduleModel *schModel = [[KWScheduleModel alloc] init];
                for (int i = 0; i<todayScheduleModel.count; i++) {
                    schModel = todayScheduleModel[i];
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

- (void)loadCardData {
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        [KWAFNetworking postWithUrlString:GetCashAPI parameters:parements success:^(id data) {
            NSDictionary *cardDict = data[@"data"];
            [Utils updateCache:gdufeAccount andID:@"CardModel" andValue:cardDict];

            _cardModel = [KWCashModel mj_objectWithKeyValues:cardDict];
            //        self.msgVc.stuModel = _stuModel;
            self.todayBuyVc.cardModel = _cardModel;
            //        NSLog(@"cardNum",_cardModel.cardNum);
            
            dispatch_async(dispatch_get_main_queue(), ^{ // 2
                [self.tableView reloadData]; // 3
            });
        } failure:^(NSError *error) {
            
        }];
    });
}


- (void) updateCashData {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager  sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus  status) {
        switch (status) {
            case  AFNetworkReachabilityStatusUnknown: {
                NSLog(@"未知");
                NSDictionary *cashAry = [Utils getCache:gdufeAccount andID:@"CardModel"];
                _cardModel = [KWCashModel mj_objectWithKeyValues:cashAry];
                self.todayBuyVc.cardModel = _cardModel;
                [self.tableView reloadData];
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"没有网络");
                NSDictionary *cashAry = [Utils getCache:gdufeAccount andID:@"CardModel"];
                _cardModel = [KWCashModel mj_objectWithKeyValues:cashAry];
                self.todayBuyVc.cardModel = _cardModel;
                [self.tableView reloadData];
                 break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN: {
                NSLog(@"3G|4G");
                [self loadCardData];
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi: {
                NSLog(@"WiFi");
                [self loadCardData];
                break;
            }
            default:
                break;
        }
    }];
    [manager startMonitoring];//开始监听
}

#pragma mark - 设置导航条
-(void)setupNavBar
{
    self.navigationItem.title = @"我";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:[UIImage imageNamed:@"mine_setting"] hightImage:[UIImage imageNamed:@"mine_setting"] target:self action:@selector(settingVc)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {

        KWMyMsgCell *cell = [[KWMyMsgCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = _stuModel;
        return cell;
    } else {
        KWEducationalViewCell *cell = [[KWEducationalViewCell alloc]init];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 88;
    } else if (indexPath.section == 1) {
        return 2 * KWSCreenW/5;
    } else return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 320, 5)];
    UIView *customView2 = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 320, 0.1)];
    if (section == 0) {
        return customView2;
    } else {
        return customView;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0.1;
    } else {
        return 3;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self tomsgVc];
        }
    }
}

//点击跳转到设置页面
- (void)tomsgVc {
    [self.navigationController pushViewController:self.msgVc animated:YES];
}

//点击跳转到今日交易界面
- (void)toTodayBuyVc {
    [self.navigationController pushViewController:self.todayBuyVc animated:YES];
}

//点击跳转到今日交易界面
- (void)toAboutVc {
    KWAboutViewController *aboutVc = [[KWAboutViewController alloc]init];
    [self.navigationController pushViewController:aboutVc animated:YES];
}

//点击跳转到设置界面
- (void)settingVc {
    KWSettingTableViewController *settingVc = [[KWSettingTableViewController alloc]init];
    [self.navigationController pushViewController:settingVc animated:YES];
}


#pragma mark - KWPushDelegate
- (void)pushVc:(id)gradeVc {
    [self.navigationController pushViewController:gradeVc animated:YES];
}

@end
