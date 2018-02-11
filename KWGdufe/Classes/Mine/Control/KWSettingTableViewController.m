//
//  KWSettingTableViewController.m
//  KWGdufe
//
//  Created by korwin on 2018/2/9.
//  Copyright © 2018年 korwin. All rights reserved.
//

#import "KWSettingTableViewController.h"
#import "Utils.h"
#import "KWLogoutCell.h"
#import "KeychainWrapper.h"
#import <ActionSheetPicker-3.0/ActionSheetDatePicker.h>
#import <ActionSheetPicker-3.0/ActionSheetPicker.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "KWAFNetworking.h"
#import "KWRealm.h"
#import "KWTodayScheduleObject.h"
#import "KWScheduleModel.h"
#import <MJExtension/MJExtension.h>
#import "KWAboutViewController.h"
#import "KWIntroduceViewController.h"


@interface KWSettingTableViewController ()

@end

@implementation KWSettingTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.bounds style:UITableViewStyleGrouped];
    self.navigationItem.title = @"设置";
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"stuTimeCell"];
            cell.textLabel.text = [NSString stringWithFormat:@"开学日期:第%@周",[Utils getCache:gdufeAccount andID:@"schoolWeek"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中无色
            return cell;
        } else if (indexPath.row == 1) {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"stuTimeCell"];
            cell.textLabel.text = [NSString stringWithFormat:@"当前学期:%@",[Utils getCache:gdufeAccount andID:@"stuTime"]];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;//选中无色
            return cell;
        } else {
            UITableViewCell *cell = [[UITableViewCell alloc]init];
            cell.textLabel.text = @"关于我们";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }  else {
        KWLogoutCell *cell = [[KWLogoutCell alloc]init];
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([KWLogoutCell class]) owner:nil options:nil][0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            UITableViewCell *sender = [tableView cellForRowAtIndexPath:indexPath];
            [self selectBeginY:sender];
        } else if (indexPath.row == 1) {
            UITableViewCell *sender = [tableView cellForRowAtIndexPath:indexPath];
            [self selectNowStuTimeYear:sender];
        } else if (indexPath.row == 2) {
            [self toAboutVc];
        }
    } else {
        if (indexPath.row == 0) {
            [self logout];
        }
    }
}

#pragma mark - 开学日期选择器
- (void)selectBeginY:(UITableViewCell*)sender {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *minimumDateComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    [minimumDateComponents setYear:2000];
    NSDate *minDate = [calendar dateFromComponents:minimumDateComponents];
    NSDate *maxDate = [NSDate date];
    NSLog(@"%@",[NSDate date]);
    NSDateFormatter * df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd";
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    
    ActionSheetDatePicker *picker = [[ActionSheetDatePicker alloc] initWithTitle:@"设置开学时间"
                                                                  datePickerMode:UIDatePickerModeDate
                                                                    selectedDate:[NSDate date]
                                                                       doneBlock:^(ActionSheetDatePicker *picker, id selectedDate, id origin) {
                                                                           NSString *beginYear = [df stringFromDate:selectedDate];//当前日期;
                                                                           [Utils getSchoolWeek:beginYear];
                                                                           //                                                                           [Utils getNowYear:beginYear];
                                                                           [self.tableView reloadData];
                                                                           NSLog(@"%@",beginYear);
                                                                       }
                                                                     cancelBlock:^(ActionSheetDatePicker *picker) {
                                                                         NSLog(@"cancel");}
                                                                          origin:sender];
    
    [picker setMinimumDate:minDate];
    [picker setMaximumDate:maxDate];
    [picker setLocale:locale];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[Utils colorWithHexString:@"#1DB0B8"] forState:UIControlStateHighlighted];
    [cancelButton setFrame:CGRectMake(0, 0, 50, 45)];
    //    cancelButton.backgroundColor = [UIColor redColor];
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:[Utils colorWithHexString:@"#1DB0B8"] forState:UIControlStateHighlighted];
    [doneButton setFrame:CGRectMake(0, 0, 50, 45)];
    //    doneButton.backgroundColor = [UIColor redColor];
    [picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    [picker showActionSheetPicker];
}

#pragma mark - 设置当前学年
- (void)selectNowStuTimeYear:(UITableViewCell*)sender {
    
    NSArray *stuTimes = [Utils getCache:gdufeAccount andID:@"stuTimes"];
    
    NSLog(@"%@",stuTimes);
    ActionSheetStringPicker *picker = [[ActionSheetStringPicker alloc]initWithTitle:@"设置当前学期" rows:stuTimeForSchool2 initialSelection:0 doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
        
        [Utils saveCache:gdufeAccount andID:@"stuTime" andValue:stuTimes[selectedIndex]];
        [self loadData:[Utils getCache:gdufeAccount andID:@"stuTime"] week:[Utils getCache:gdufeAccount andID:@"schoolWeek"]];
        NSLog(@"%@",[Utils getCache:gdufeAccount andID:@"stuTime"]);
        NSLog(@"selectedValue = %@",stuTimes[selectedIndex]);
        [self.tableView reloadData];
    } cancelBlock:^(ActionSheetStringPicker *picker) {
        
    } origin:sender];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[Utils colorWithHexString:@"#1DB0B8"] forState:UIControlStateHighlighted];
    [cancelButton setFrame:CGRectMake(0, 0, 50, 45)];
    [picker setCancelButton:[[UIBarButtonItem alloc] initWithCustomView:cancelButton]];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [doneButton setTitle:@"完成" forState:UIControlStateNormal];
    [doneButton.titleLabel setFont:[UIFont boldSystemFontOfSize:17]];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton setTitleColor:[Utils colorWithHexString:@"#1DB0B8"] forState:UIControlStateHighlighted];
    [doneButton setFrame:CGRectMake(0, 0, 50, 45)];
    [picker setDoneButton:[[UIBarButtonItem alloc] initWithCustomView:doneButton]];
    
    [picker showActionSheetPicker];
}

#pragma mark - 退出注销服务器缓存
- (void)logout {
    //UIAlertController风格：UIAlertControllerStyleAlert
    UIAlertController *alertController = [[UIAlertController alloc]init];
    if ([Utils getIsIpad]) {
        //UIAlertController风格：UIAlertControllerStyleAlert
        alertController = [UIAlertController alertControllerWithTitle:@"退出后将删除所有数据" message:nil preferredStyle:UIAlertControllerStyleAlert];
    } else {
        //UIAlertController风格：UIAlertControllerStyleAlert
        alertController = [UIAlertController alertControllerWithTitle:@"退出后将删除所有数据" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    }
    
    //添加取消到UIAlertController中
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"退出" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * action) {
        
        dispatch_queue_t HUDQueue = dispatch_queue_create("HUDQueue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(HUDQueue, ^{
            
            KWIntroduceViewController *loginVc = [[KWIntroduceViewController alloc]init];
            
            [SVProgressHUD show];
            sleep(1);
            [SVProgressHUD dismiss];
            
            [SVProgressHUD showSuccessWithStatus:[NSString stringWithFormat:@"已登出"]];
            sleep(1);
            [SVProgressHUD dismiss];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //跳转页面
                [self presentViewController:loginVc animated:YES completion:nil];
            });
            
            NSString *account = [wrapper myObjectForKey:(id)kSecAttrAccount];
            
            //删除课程表缓存
            [Utils removeCache:account andID:@"stuTimes"];
            [Utils removeCache:account andID:@"stuTime"];
            [Utils removeCache:account andID:@"TodayBuyModel"];
            [Utils removeCache:account andID:@"CardModel"];
            [Utils removeCache:account andID:@"schoolWeek"];
            [Utils removeCache:account andID:@"schoolYear"];
            [Utils removeCache:account andID:@"stuTimeForGrade"];
            [Utils removeCache:account andID:@"schoolYearForGrade"];
            [Utils removeCache:account andID:@"InFoTips"];
            [Utils removeCache:account andID:@"gradeSelect"];
            [Utils removeCache:account andID:@"gradeSelectYear"];
            [Utils removeCache:account andID:@"Money"];
            [Utils removeCache:account andID:@"MyBBooks"];
            
            //删除账号密码
            [wrapper resetKeychainItem];
            
            //删除数据库
            RLMRealm *real = [KWRealm getRealmWith:GdufeDataBase];
            [KWRealm deleteAllObjects:real];
        });
    }];
    [alertController addAction:OKAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//点击跳转到今日交易界面
- (void)toAboutVc {
    KWAboutViewController *aboutVc = [[KWAboutViewController alloc]init];
    [self.navigationController pushViewController:aboutVc animated:YES];
}

#pragma mark - 加载数据
- (void)loadData:(NSString *)selectStuTime week:(NSString *)selectWeek {
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    parements[@"stu_time"] = selectStuTime;
    parements[@"week"] = selectWeek;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        [KWAFNetworking postWithUrlString:@"http://api.wegdufe.com:82/index.php?r=jw/get-schedule" parameters:parements success:^(id data) {
            NSArray *scheduleAry = data[@"data"];;
            
            //字典数组转模型数组
            NSArray *todayScheduleModel = [KWScheduleModel mj_objectArrayWithKeyValuesArray:scheduleAry];
            
            //存入数据库
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
@end
