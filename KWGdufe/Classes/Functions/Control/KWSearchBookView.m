//
//  KWSearchBookView.m
//  KWGdufe
//
//  Created by korwin on 2017/11/21.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWSearchBookView.h"
#import <Masonry/Masonry.h>

@interface KWSearchBookView ()

@end

@implementation KWSearchBookView

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tableView = [[UITableView alloc]initWithFrame:self.tableView.frame style:UITableViewStyleGrouped];
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KWSCreenW, 30)];
    // 设置header
    self.tableView.tableHeaderView = header;
    
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.showsCancelButton = YES;
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

@end
