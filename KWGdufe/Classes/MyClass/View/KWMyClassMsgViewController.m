//
//  KWMyClassMsgViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/11/2.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWMyClassMsgViewController.h"
#import "KWScheduleModel.h"

@interface KWMyClassMsgViewController ()

@end

@implementation KWMyClassMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = _model.name;
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classMsgCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"classMsgCell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = @"课程名";
        cell.detailTextLabel.text = _model.name;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = @"教师";
        cell.detailTextLabel.text = _model.teacher;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = @"教室";
        cell.detailTextLabel.text = _model.location;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = @"当前周";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"第%ld周", (long)_model.dayInWeek];
    } else if (indexPath.row == 4) {
        cell.textLabel.text = @"节数";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%ld-%ld节", (long)_model.startSec,(long)_model.endSec];
    } else if (indexPath.row == 5) {
        cell.textLabel.text = @"周数";
        cell.detailTextLabel.text = _model.period;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
