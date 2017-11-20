//
//  KWOtherFuncViewCell.m
//  KWGdufe
//
//  Created by korwin on 2017/11/5.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWOtherFuncViewCell.h"
#import "KWFunctionsCell.h"
#import "KWSeElectViewController.h"
#import <QuartzCore/QuartzCore.h>

#define ID @"cell"

@interface KWOtherFuncViewCell()<UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation KWOtherFuncViewCell

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
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UINib *nib = [UINib nibWithNibName:@"KWFunctionsCell"bundle: [NSBundle mainBundle]];
    [collectionView registerNib:nib forCellWithReuseIdentifier:ID];
    KWFunctionsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    if (indexPath.row == 0) {
        cell.name = @"电控查询";
        cell.imageName = @"setup-head-default";
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        KWSeElectViewController *seElectVc = [[KWSeElectViewController alloc]init];
        [_delegate pushVc:seElectVc];
    }
}
@end
