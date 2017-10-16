//
//  KWMineMsgViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/10/12.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWMineMsgViewController.h"
#import "KWMsgCell.h"

@interface KWMineMsgViewController ()

@end

@implementation KWMineMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.bounds style:UITableViewStyleGrouped];
    
    //网上移动34，与导航栏对齐
    self.tableView.contentInset = UIEdgeInsetsMake(-34, 0, 0, 0);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#warning 设置信息展示
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell.msgName = @"姓名";
            cell.msgValue = _stuModel.name;
            return cell;
        } if (indexPath.row == 1) {
            cell.msgName = @"学号";
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSString *number = [defaults objectForKey:@"sno"];
            if (number != nil) {
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
