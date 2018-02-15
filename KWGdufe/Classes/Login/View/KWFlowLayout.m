//
//  KWFlowLayout.m
//  KWImageMaxView
//
//  Created by korwin on 2017/10/10.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWFlowLayout.h"

@implementation KWFlowLayout

- (void)prepareLayout
{
    [super prepareLayout];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *attrs = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        CGFloat delta = fabs((attr.center.x - self.collectionView.contentOffset.x) - self.collectionView.bounds.size.width * 0.5);
        CGFloat scale = 1 - delta / (self.collectionView.bounds.size.width * 0.5) * 0.2;
        attr.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return attrs;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    CGFloat collectionWith = self.collectionView.bounds.size.width;
    
    CGPoint target = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    

    CGRect targetRect = CGRectMake(target.x, 0, collectionWith, MAXFLOAT);
    
    NSArray *attrs = [super layoutAttributesForElementsInRect:targetRect];
    
    CGFloat minDelta = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attr in attrs) {
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
