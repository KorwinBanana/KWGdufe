//
//  KWMineViewController.m
//  KWGdufe
//
//  Created by korwin on 2017/9/28.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWMineViewController.h"
#import "KWMineCell.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "KWStuModel.h"
#import "KWMineMsgViewController.h"
#import "KWLoginViewController.h"

@interface KWMineViewController ()

@property(nonatomic,strong) KWStuModel *stuModel;
@property (nonatomic,strong) KWMineMsgViewController  *msgVc;

@end

@implementation KWMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.msgVc = [[KWMineMsgViewController alloc]init];//初始化

    [self setupNavBar];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.bounds style:UITableViewStyleGrouped];
    
    self.tableView.contentInset = UIEdgeInsetsMake(-34, 0, 0, 0);
    
    [self loadData];//加载数据
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

#pragma mark - 加载数据
- (void)loadData
{
    //创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    //获取登陆的账号密码
    NSString *sno  = [[NSUserDefaults standardUserDefaults] objectForKey:@"sno"];
    NSString *pwd  = [[NSUserDefaults standardUserDefaults] objectForKey:@"pwd"];
    
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"sno"] = sno;
    parements[@"pwd"] = pwd;

    //发送请求
    [mgr POST:@"http://api.wegdufe.com:82/index.php?r=jw/get-basic" parameters:parements progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSLog(@"%@",responseObject);
//        [responseObject writeToFile:@"/Users/k/iOS-KW/project/stuModel.plist" atomically:nil];
        
        //获取字典
        NSDictionary *adDict = responseObject[@"data"];
        
        //字典转模型
        _stuModel = [KWStuModel mj_objectWithKeyValues:adDict];
        
#warning 设置学生模型给信息展示界面
        self.msgVc.stuModel = _stuModel;
//        NSLog(@"_StuModel.name = %@",_stuModel.classroom);
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"失败啦～～");
    }];
}

#pragma mark - 退出注销服务器缓存
- (void)logout {
    KWLoginViewController *loginVc = [[KWLoginViewController alloc]init];
    [UIApplication sharedApplication].keyWindow.rootViewController = loginVc;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //删除账号密码
    [defaults removeObjectForKey:@"sno"];
    [defaults removeObjectForKey:@"pwd"];
    [defaults synchronize];
}

#pragma mark - 设置导航条
-(void)setupNavBar
{
    //设置按钮
    self.navigationItem.title = @"我";
    
}

//点击跳转到设置页面
- (void)tomsgVc {
    [self.navigationController pushViewController:self.msgVc animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 3;
    } else return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc]init];
//    NSLog(@"%@",NSStringFromCGRect(cell.frame));
    if (indexPath.section == 0) {
        KWMineCell *cell = [[KWMineCell alloc]init];
        cell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([KWMineCell class]) owner:nil options:nil][0];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.model = _stuModel;
        return cell;
    } if (indexPath.section == 2) {
        cell.textLabel.text = @"退出";
    } else cell.textLabel.text = @"我是谁！！";
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 88;
    } else return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [self tomsgVc];
        }
    }
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            [self logout];
        }
    }
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
