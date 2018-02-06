//
//  KWEducationalViewCell.m
//  KWGdufe
//
//  Created by korwin on 2017/10/26.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWEducationalViewCell.h"
#import "KWFunctionsCell.h"
#import <QuartzCore/QuartzCore.h>
#import "KWGradeCell.h"
#import "KWSztzTableView.h"
#import "KWGradeView.h"
#import "KWCurrentBookView.h"
#import "KWHisCurrentBookView.h"
#import "KWRequestUrl.h"
#import "KWSearchBookView.h"
#import "KWTodayBuyViewController.h"

#define ID @"cell"

@interface KWEducationalViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic,strong) NSArray  *homeBackGColors;

@end

@implementation KWEducationalViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _homeBackGColors = @[@"#011935",@"#00343F",@"#1DB0B8",@"#37C6C0",@"#96B8FF",@"B3ADE9"];
        
        //创建布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(KWSCreenW/5, KWSCreenW/5);
        NSLog(@"%lf",KWSCreenW/5);
        layout.minimumLineSpacing = 0.1;
        layout.minimumInteritemSpacing = 0.1;
        
        //创建UICollectView
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, 0, KWSCreenW-40, 2 * KWSCreenW/5) collectionViewLayout:layout];
        
        collectView.dataSource = self;
        collectView.delegate = self;
        collectView.scrollEnabled = NO;//collectionView不能滚动
        collectView.backgroundColor = [UIColor clearColor];
        [self addSubview:collectView];
        
        //注册cell
        [collectView registerNib:[UINib nibWithNibName:@"KWFunctionsCell" bundle:nil] forCellWithReuseIdentifier:ID];
    }
    return self;
}

#pragma mark - UICollectViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UINib *nib = [UINib nibWithNibName:@"KWFunctionsCell"bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:ID];
    KWFunctionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.backGColor = _homeBackGColors[indexPath.row];
    if (indexPath.row == 0) {
        cell.name = @"成绩查询";
    } else if (indexPath.row == 1) {
        cell.name = @"素拓信息";
    } else if (indexPath.row == 2) {
        cell.name = @"当前借阅";
    } else if (indexPath.row == 3) {
        cell.name = @"历史借阅";
    } else if (indexPath.row == 4) {
        cell.name = @"馆藏查询";
    } else if (indexPath.row == 5) {
        cell.name = @"校园校卡";
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

#pragma mark - UICollectionDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        KWGradeView *gradeVc = [[KWGradeView alloc]init];
        [_delegate pushVc:gradeVc];
    } else if (indexPath.row == 1) {
        KWSztzTableView *sztzVc = [[KWSztzTableView alloc]init];
        [_delegate pushVc:sztzVc];
    }  else if (indexPath.row == 2) {
        KWCurrentBookView *currentVc = [[KWCurrentBookView alloc]init];
        currentVc.url = GetCurrentBookAPI;
        currentVc.modelSaveName = @"CurrentBookModel";
        currentVc.vcName = @"当前借阅";
        currentVc.boolHistory = 0;
        [_delegate pushVc:currentVc];
    } else if (indexPath.row == 3) {
#warning 需要简化历史续借页面
        KWHisCurrentBookView *borrowVc = [[KWHisCurrentBookView alloc]init];
        borrowVc.url = GetBorrowedBookAPI;
        borrowVc.modelSaveName = @"BorrowedBookModel";
        borrowVc.vcName = @"历史借阅";
        borrowVc.boolHistory = 1;
        [_delegate pushVc:borrowVc];
    } else if (indexPath.row == 4) {
        KWSearchBookView *searchBookVc = [[KWSearchBookView alloc]init];
        //        borrowVc.url = GetBorrowedBookAPI;
        //        borrowVc.modelSaveName = @"BorrowedBookModel";
        //        borrowVc.vcName = @"历史借阅";
        [_delegate pushVc:searchBookVc];
    } else if (indexPath.row == 5) {
        KWTodayBuyViewController *todayBuyVc = [[KWTodayBuyViewController alloc]init];
        [_delegate pushVc:todayBuyVc];
    }
}

@end
