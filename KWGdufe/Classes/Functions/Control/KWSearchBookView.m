//
//  KWSearchBookView.m
//  KWGdufe
//
//  Created by korwin on 2017/11/21.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWSearchBookView.h"
#import <Masonry/Masonry.h>
#import <MJExtension/MJExtension.h>
#import "KWAFNetworking.h"
#import "KeychainWrapper.h"
#import "KWSearchBookModel.h"
#import "KWSearchBookEndCell.h"

@interface KWSearchBookView ()<UISearchBarDelegate>

@property(nonatomic,strong) NSArray *searchBookModel;

@end

@implementation KWSearchBookView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWSCreenW, 50)];
    // 设置header
    self.tableView.tableHeaderView = header;
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.showsCancelButton = YES;
    searchBar.delegate = self;
    [header addSubview:searchBar];
    [searchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(header.mas_left);
        make.right.equalTo(header.mas_right);
        make.top.equalTo(header.mas_top);
    }];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
}

#pragma mark - loadData

- (void)loadSearchBookWithBookName: (NSString *)bookName {
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"bookName"] = bookName;
    
    [KWAFNetworking postWithUrlString:@"http://api.wegdufe.com:82/index.php?r=opac/search-book" parameters:parements success:^(id data) {
        NSLog(@"data = %@",data);
        //获取字典
        NSDictionary *searchBookDict = data[@"data"];

        //缓存到本地
//        [Utils saveCache:gdufeAccount andID:_modelSaveName andValue:currentBookDict];

        //字典转模型
        NSArray *searchBookModel = [KWSearchBookModel mj_objectArrayWithKeyValuesArray:searchBookDict];
        _searchBookModel = searchBookModel;

        [self.tableView reloadData];
        NSLog(@"刷新成功");
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 108;
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
//    NSLog(@"文字改变 = %@",searchText);
    [self loadSearchBookWithBookName:searchText];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
