//
//  KWSBookMostMsgView.m
//  KWGdufe
//
//  Created by korwin on 2017/11/23.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWSBookMostMsgView.h"
#import "KWSearchBookModel.h"
#import <MJExtension/MJExtension.h>
#import "KWAFNetworking.h"
#import "KWSBookModel.h"
#import "KWSBookShowCell.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface KWSBookMostMsgView ()

@property(nonatomic,strong) NSArray *bookModel;

@end

@implementation KWSBookMostMsgView

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVProgressHUD show];
    [self loadSBookWithmacno:_sBookModel.macno];
    self.navigationItem.title = _sBookModel.name;
}

#pragma mark - loadData
- (void)loadSBookWithmacno: (NSString *)macno {
    //拼接数据
    NSMutableDictionary *parements = [NSMutableDictionary dictionary];
    parements[@"macno"] = macno;
    
    [KWAFNetworking postWithUrlString:@"http://api.wegdufe.com:82/index.php?r=opac/get-book-store-detail" parameters:parements success:^(id data) {
        NSLog(@"data = %@",data);
        //获取字典
        NSDictionary *bookDict = data[@"data"];
        NSString *code = [data objectForKey:@"code"];
        NSString *codeStr = [NSString stringWithFormat:@"%@",code];
        
        if ([codeStr isEqualToString:@"0"]) {
            //字典转模型
            NSArray *bookModel = [KWSBookModel mj_objectArrayWithKeyValuesArray:bookDict];
            _bookModel = bookModel;
            
            [self.tableView reloadData];
            [SVProgressHUD dismiss];
            NSLog(@"刷新成功");
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _bookModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    KWSBookShowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"sBookCell"];
    if (!cell) {
        cell = [[KWSBookShowCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sBookCell"];
    }
    KWSBookModel *model = _bookModel[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = model;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 86;
}

@end
