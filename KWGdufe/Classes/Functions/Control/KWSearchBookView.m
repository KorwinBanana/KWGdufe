//
//  KWSearchBookView.m
//  KWGdufe
//
//  Created by korwin on 2017/11/21.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWSearchBookView.h"
#import <MJExtension/MJExtension.h>
#import "KWAFNetworking.h"
#import "KeychainWrapper.h"
#import "KWSearchBookModel.h"
#import "KWSearchBookEndCell.h"
#import "KWSBookMostMsgView.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Utils.h"

@interface KWSearchBookView ()<UISearchBarDelegate>

@property(nonatomic,strong) NSArray *searchBookModel;
@property(nonatomic,strong) UISearchBar *searchBar;

@end

@implementation KWSearchBookView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWSCreenW, 50)];
    self.tableView.tableHeaderView = header;
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    _searchBar = searchBar;
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    for (id obj in [searchBar subviews]) {
        if ([obj isKindOfClass:[UIView class]]) {
            for (id obj2 in [obj subviews]) {
                if ([obj2 isKindOfClass:[UIButton class]]) {
                    UIButton *btn = (UIButton *)obj2;
                    [btn setTitle:@"取消" forState:UIControlStateNormal];
                    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                }
            }
        }
    }
    [header addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.mas_left);
        make.right.equalTo(header.mas_right);
        make.top.equalTo(header.mas_top);
    }];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_searchBar becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.view endEditing:YES];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - loadData
- (void)loadSearchBookWithBookName: (NSString *)bookName {
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"bookName"] = bookName;
    
    [KWAFNetworking postWithUrlString:@"http://api.wegdufe.com:82/index.php?r=opac/search-book" vController:self parameters:parements success:^(id data) {
        NSLog(@"data = %@",data);
        NSDictionary *searchBookDict = data[@"data"];
        NSString *code = [data objectForKey:@"code"];
        NSString *codeStr = [NSString stringWithFormat:@"%@",code];
        
        
        if ([codeStr isEqualToString:@"0"]) {
            NSArray *searchBookModel = [KWSearchBookModel mj_objectArrayWithKeyValuesArray:searchBookDict];
            _searchBookModel = searchBookModel;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
                NSLog(@"查询书本信息成功~");
                [SVProgressHUD dismiss];
            });
        } else if ([codeStr isEqualToString:@"2003"]) {
            NSLog(@"喵～馆藏查询系统崩啦～～");
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                [self showDismissWithTitle:@"喵～馆藏查询系统崩啦～～" message:nil parent:self];
            });
        }
    } failure:^(NSError *error) {
        
    } noNetworking:^{
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return _searchBookModel.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KWSearchBookEndCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[KWSearchBookEndCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    KWSearchBookModel *model = _searchBookModel[indexPath.row];
    cell.model = model;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    KWSBookMostMsgView *sbMostMsgVc = [[KWSBookMostMsgView alloc]init];
    KWSearchBookModel *model = _searchBookModel[indexPath.row];
    sbMostMsgVc.sBookModel = model;
    [self.navigationController pushViewController:sbMostMsgVc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108;
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"文字改变 = %@",searchBar.text);
    [self.view endEditing:YES];//取消键盘响应
    [SVProgressHUD showWithStatus:@"搜索中"];
    [self loadSearchBookWithBookName:searchBar.text];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - AlertController
- (void)showDismissWithTitle:(NSString *)title  message:(NSString *)message parent:(UIViewController *)parentController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    [self presentViewController:alert animated:YES completion:nil];
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(creatAlert:) userInfo:alert repeats:NO];
}

- (void)creatAlert:(NSTimer *)timer {
    UIAlertController * alert = (UIAlertController *)[timer userInfo];
    [alert dismissViewControllerAnimated:YES completion:nil];
    alert = nil;
}

@end
