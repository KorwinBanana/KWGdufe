//
//  KWFunctionsViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/9/28.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWFunctionsViewController.h"
#import "KWEducationalViewCell.h"

@interface KWFunctionsViewController ()<KWPushDelegate>

@end

@implementation KWFunctionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.bounds style:UITableViewStyleGrouped];
    self.tableView.sectionFooterHeight = 0.1;//footView的高度
    [self setupNavBar];
}

- (void)setupNavBar
{
    self.navigationItem.title = @"快捷功能";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - KWPushDelegate
- (void)pushVc:(KWGradeView *)gradeVc {
    [self.navigationController pushViewController:gradeVc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    /*
     自定义cell，放置功能图标，通过加入选中手势，跳转到对应功能页面
     */
    if(indexPath.section == 0) {
        KWEducationalViewCell *cell = [[KWEducationalViewCell alloc]init];
//        cell.textLabel.text = @"教务系统的功能";
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        return cell;
    } else {
        UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"ID"];
        cell.textLabel.text = @"图书馆系统的功能";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//不可选择
        return cell;
    }
}

//自定义Header的UIView
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // create the parent view that will hold header Label
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, 320, KWSCreenW/15)];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.font = [UIFont italicSystemFontOfSize:16];
    headerLabel.frame = customView.frame;
    if (section == 0) {
        headerLabel.text = @"教务";
    } else {
        headerLabel.text = @"图书馆";
    }
    [customView addSubview:headerLabel];
    return customView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return KWSCreenW/15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return KWSCreenW/5;
}

@end
