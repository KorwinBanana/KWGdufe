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

#define ID @"cell"

@interface KWEducationalViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation KWEducationalViewCell

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
        cell.name = @"成绩查询";
        cell.imageName = @"setup-head-default";
    } else if (indexPath.row == 1) {
        cell.name = @"素拓信息";
        cell.imageName = @"setup-head-default";
    } else {
        cell.name = @"查四六级";
        cell.imageName = @"setup-head-default";
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
    }
}

@end
