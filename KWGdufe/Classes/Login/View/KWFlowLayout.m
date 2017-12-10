//
//  KWFlowLayout.m
//  KWImageMaxView
//
//  Created by korwin on 2017/10/10.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWFlowLayout.h"
/*
     自定义布局：主要了解5个方法
 */
@implementation KWFlowLayout

// 重写方法
/*
调用时机：collectionView第一次布局，collectionView刷新的时候也会调用
作用：计算cell的布局
- (void)prepareLayout;
 
确认cell的尺寸
UICollectionViewLayoutAttributes对象就对应一个cell
拿到UICollectionViewLayoutAttributes相当于拿到cell
作用：返回很多cell的尺寸（指定一个区域给你这个短区域的cell）(可以一次性返回所有cell，也可以每隔一个距离返回一个cell，取决于rect)
- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect;

在滚动的时候是否允许刷新布局
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds;

调用时机：用户手指一松手的时候就会调用
作用：确认最终的偏移量
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity;
 
- (CGSize)collectionViewContentSize;
*/

- (void)prepareLayout
{
    [super prepareLayout];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    //设置cell尺寸-->UICollectionViewLayoutAttributes
    //1.获取当前显示cell的布局
    NSArray *attrs = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        //2.越靠近中心点，cell尺寸越大，计算中心点位置
        CGFloat delta = fabs((attr.center.x - self.collectionView.contentOffset.x) - self.collectionView.bounds.size.width * 0.5);
        //3.计算比例
        CGFloat scale = 1 - delta / (self.collectionView.bounds.size.width * 0.5) * 0.2;
        attr.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return attrs;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    //拖动比较快，最终偏移量不等于手指离开时的偏移量
    CGFloat collectionWith = self.collectionView.bounds.size.width;
    
    CGPoint target = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    
    //1.获取最终显示cell的区域（用偏移量x）
    //最终偏移量
    CGRect targetRect = CGRectMake(target.x, 0, collectionWith, MAXFLOAT);
    
    //2.获取cell(layoutAttributesForElementsInRect)
    NSArray *attrs = [super layoutAttributesForElementsInRect:targetRect];
    
    CGFloat minDelta = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        //获取距离中心点距离
        CGFloat delta = (attr.center.x - target.x) - self.collectionView.bounds.size.width * 0.5;
        if (fabs(delta) < fabs(minDelta)) {
            minDelta = delta;
        }
    }
    
    target.x += minDelta;
    
    if (target.x < 0) {
        target.x = 0;
    }
    return target;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
