//
//  KWMineMsgViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/10/12.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWMineMsgViewController.h"
#import "KWMsgCell.h"
#import <MJRefresh/MJRefresh.h>
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "KeychainWrapper.h"

@interface KWMineMsgViewController ()

@end

@implementation KWMineMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人信息";
    
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.bounds style:UITableViewStyleGrouped];
    
    CGRect frame = CGRectMake(0, 0, 0, 0.1);
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:frame];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 7;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KWMsgCell *cell = [tableView dequeueReusableCellWithIdentifier:@"msgCell"];
    if (cell == nil) {
        cell = [[KWMsgCell alloc]init];
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([KWMsgCell class]) owner:nil options:nil][0];
    }
//    KWMsgCell *cell = [[KWMsgCell alloc]init];
//    cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([KWMsgCell class]) owner:nil options:nil][0];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.msgName = @"姓名";
            cell.msgValue = _stuModel.name;
            return cell;
        } if (indexPath.row == 1) {
            cell.msgName = @"学号";
            NSString *number = [wrapper myObjectForKey:(id)kSecAttrAccount];
            if (![number isEqualToString:@"Account"]) {
                cell.msgValue = number;
            } else {
                cell.msgValue = @"喵~未登录~";
            }
            return cell;
        } if (indexPath.row == 2) {
            cell.msgName = @"组织";
            cell.msgValue = _stuModel.party;
            return cell;
        } if (indexPath.row == 3) {
            cell.msgName = @"教育";
            cell.msgValue = _stuModel.education;
            return cell;
        } if (indexPath.row == 4) {
            cell.msgName = @"学院";
            cell.msgValue = _stuModel.department;
            return cell;
        } if (indexPath.row == 5) {
            cell.msgName = @"专业";
            cell.msgValue = _stuModel.major;
            return cell;
        } if (indexPath.row == 6) {
            cell.msgName = @"班级";
            cell.msgValue = _stuModel.classroom;
            return cell;
        }
    }
    return cell;
}

@end
