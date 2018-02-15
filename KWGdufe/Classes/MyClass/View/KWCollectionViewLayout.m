//
//  KWCollectionViewLayout.m
//  KWGdufe
//
//  Created by korwin on 2017/10/8.
//  Copyright © 2017年 korwin. All rights reserved.
//

#import "KWCollectionViewLayout.h"
#import "KWScheduleModel.h"

@implementation KWCollectionViewLayout
struct Tag{
    NSInteger weekDay;
    NSInteger start;
    NSInteger end;
}tag;

- (CGSize)collectionViewContentSize{
    return  CGSizeMake(self.collectionView.frame.size.width, (_height + 8)*12);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *attrs = [NSMutableArray array];
    
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    CGFloat temp = _height;

    int tagMinY = 1;
    int  tagMaxY;
    
    while (minY>temp) {
        tagMinY++;
        temp += _height;
    }
    
    tagMaxY = tagMinY;
    
    while(maxY>temp)
    {
        tagMaxY++;
        temp += _height;
    }
    
    for(int i =tagMinY;i<=tagMaxY;i++)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i-1 inSection:0];//标记第几行，path.row
        [attrs addObject:[self layoutAttributesForSupplementaryViewOfKind:@"number" atIndexPath:path]];
    }
    
    int j = 12;
    KWScheduleModel *model;
    int p = 0;
    for(int i = tagMinY; i <= tagMaxY; i++)
    {
        for(int k = p; k < _array.count ;k++)
        {
            model = _array[k];
            if(model.startSec == i)
            {
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:0];
                tag.weekDay = model.dayInWeek;
                tag.start = model.startSec;
                tag.end = model.endSec;
                [attrs addObject:[self layoutAttributesForItemAtIndexPath:path]];
                j++;
                p++;
            }
        }
    }
    return attrs;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attr.frame = CGRectMake(26.5 + _width*(tag.weekDay-1),_height*(tag.start-1), _width, _height*(tag.end-tag.start+1));
    return attr;
}


- (UICollectionViewLayoutAttributes*)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    attr.frame = CGRectMake(0, _height * indexPath.row, 26.5, _height);
    return attr;
    
}

@end
