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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classMsgCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"classMsgCell"];
    }
    if (indexPath.row == 0) {
        cell.textLabel.text = _model.name;
    } else if (indexPath.row == 1) {
        cell.textLabel.text = _model.teacher;
    } else if (indexPath.row == 2) {
        cell.textLabel.text = _model.location;
    } else if (indexPath.row == 3) {
        cell.textLabel.text = _model.period;
    }
    return cell;
}

@end
