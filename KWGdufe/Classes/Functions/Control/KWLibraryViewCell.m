//
//  KWLibraryViewCell.m
//  KWGdufe
//
//  Created by korwin on 2017/10/30.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWLibraryViewCell.h"
#import "KWFunctionsCell.h"
#import "KWCurrentBookView.h"
#import <QuartzCore/QuartzCore.h>
#import "KWRequestUrl.h"
#import "KWSearchBookView.h"

#define ID @"cell"

@interface KWLibraryViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation KWLibraryViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //创建布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(KWSCreenW/5, KWSCreenW/5);
        layout.minimumLineSpacing = 0.1;
        layout.minimumInteritemSpacing = 0.1;
        
        //创建UICollectView
        UICollectionView *collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(20, 0, KWSCreenW-40, KWSCreenW/5) collectionViewLayout:layout];
        
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
    return 3;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UINib *nib = [UINib nibWithNibName:@"KWFunctionsCell"bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:ID];
    KWFunctionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.name = @"当前借阅";
        cell.imageName = @"setup-head-default";
    } else if (indexPath.row == 1) {
        cell.name = @"历史借阅";
        cell.imageName = @"setup-head-default";
    } else if (indexPath.row == 2) {
        cell.name = @"馆藏查询";
        cell.imageName = @"setup-head-default";
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        KWCurrentBookView *currentVc = [[KWCurrentBookView alloc]init];
        currentVc.url = GetCurrentBookAPI;
        currentVc.modelSaveName = @"CurrentBookModel";
        currentVc.vcName = @"当前借阅";
        [_delegate pushVc:currentVc];
    } else if (indexPath.row == 1) {
        KWCurrentBookView *borrowVc = [[KWCurrentBookView alloc]init];
        borrowVc.url = GetBorrowedBookAPI;
        borrowVc.modelSaveName = @"BorrowedBookModel";
        borrowVc.vcName = @"历史借阅";
        [_delegate pushVc:borrowVc];
    } else if (indexPath.row == 2) {
        KWSearchBookView *searchBookVc = [[KWSearchBookView alloc]init];
//        borrowVc.url = GetBorrowedBookAPI;
//        borrowVc.modelSaveName = @"BorrowedBookModel";
//        borrowVc.vcName = @"历史借阅";
        [_delegate pushVc:searchBookVc];
    }
}

@end
