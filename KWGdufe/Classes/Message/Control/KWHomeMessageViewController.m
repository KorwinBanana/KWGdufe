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

@interface KWHomeMessageViewController ()

@property (nonatomic,strong) NSArray  *todayScheduleModel;
@property (nonatomic,strong) NSArray  *inFoModel;

@end

@implementation KWHomeMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavBar];
    [self loadInFoTips];
    [self loadData:[Utils getCache:gdufeAccount andID:@"stuTime"] week:[Utils getCache:gdufeAccount andID:@"schoolWeek"]];
    
}

- (void)setupNavBar {
    self.navigationItem.title = @"今日";
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _inFoModel.count;
}

#pragma mark - cell

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    
    KWInFoModel *model = _inFoModel[indexPath.row];
    
    cell.textLabel.text = model.title;
    if (indexPath.row == 1) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"您截止到昨天的余额是%@元。",[self charactersString:model.descrip]];
        [Utils saveCache:gdufeAccount andID:@"Money" andValue:[self charactersString:model.descrip]];//保存到本地沙盒
        NSLog(@"yue = %@",[self charactersString:model.descrip]);
    } else if (indexPath.row == 3) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"您共借阅%@本书。",[self charactersString:model.descrip]];
        [Utils saveCache:gdufeAccount andID:@"MyBBooks" andValue:[self charactersString:model.descrip]];//保存到本地沙盒
    } else {
        cell.detailTextLabel.text = model.descrip;
    }
    return cell;
}

- (NSString *)charactersString:(NSString *)s {
    NSMutableArray *characters = [NSMutableArray array];
    NSMutableString *mutStr = [NSMutableString string];
    
    // 分离出字符串中的所有字符，并存储到数组characters中
    for (int i = 0; i < s.length; i ++) {
        NSString *subString = [s substringToIndex:i + 1];
        subString = [subString substringFromIndex:i];
        [characters addObject:subString];
    }
    
    // 利用正则表达式，匹配数组中的每个元素，判断是否是数字，将数字拼接在可变字符串mutStr中
    for (NSString *b in characters) {
        NSString *regex = @"^[0-9]*$";
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];// 谓词
        BOOL isShu = [pre evaluateWithObject:b];// 对b进行谓词运算
        //判断是否为数字
        if (isShu) {
            [mutStr appendString:b];
        }
        //判断是否为小数
        if ([b isEqualToString:@"."]) {
            [mutStr appendString:b];
        }
    }
    return mutStr;
}

#pragma mark - 加载数据
- (void)loadInFoTips {
    
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = gdufeAccount;
    parements[@"pwd"] = gdufePassword;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{ // 1
        [KWAFNetworking postWithUrlString:@"http://api.wegdufe.com:82/index.php?r=info/info-tips" parameters:parements success:^(id data) {
            NSArray *inFoAry = data[@"data"];;
            
            [Utils saveCache:gdufeAccount andID:@"InFoTips" andValue:inFoAry];//保存到本地沙盒
            
            //字典数组转模型数组
            NSArray *inFoModel = [KWInFoModel mj_objectArrayWithKeyValuesArray:inFoAry];
            _inFoModel = inFoModel;
            NSLog(@"%@",inFoModel);
            
            dispatch_async(dispatch_get_main_queue(), ^{ //主线程刷新界面
                [self.tableView reloadData];
                NSLog(@"请求今日信息数据成功~");
            });
        } failure:^(NSError *error) {
            
        }];
    });
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
            _todayScheduleModel = [KWScheduleModel mj_objectArrayWithKeyValuesArray:scheduleAry];
            
            //存入数据库
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

@end
