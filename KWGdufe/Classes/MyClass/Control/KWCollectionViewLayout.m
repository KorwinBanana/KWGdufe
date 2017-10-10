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
//    NSLog(@"%f",_height*12);
    return  CGSizeMake(self.collectionView.frame.size.width, _height*14);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
//    NSLog(@"%f %f %f %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    
    NSMutableArray *attributes = [NSMutableArray array];
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    CGFloat temp = _height;
    
    int tagMinY = 1;
    int  tagMaxY;
    
    while (minY>temp) {
        tagMinY++;
        temp+=_height;
    }
    
    tagMaxY = tagMinY;
    
    while(maxY>temp)
    {
        tagMaxY++;
        temp+=_height;
    }
    
    for(int i =tagMinY;i<=tagMaxY;i++)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i-1 inSection:0];
        [attributes addObject:[self layoutAttributesForSupplementaryViewOfKind:@"number" atIndexPath:path]];
    }
    
    int j = 12;
    KWScheduleModel *model;
    int p = 0;
    for(int i = tagMinY ;i<=tagMaxY;i++)
    {
        for(int k = p; k< _array.count ;k++)
        {
            model = _array[k];
            if(model.startSec == i || model.endSec == i)
            {
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:0];
                tag.weekDay = model.dayInWeek;
                tag.start = model.startSec;
                tag.end = model.endSec;
                [attributes addObject:[self layoutAttributesForItemAtIndexPath:path]];
                j++;
                p++;
            }
        }
    }
    return attributes;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectMake(36.5+_width*(tag.weekDay-1),_height*(tag.start-1), _width, _height*(tag.end-tag.start+1));
    return attributes;
}


- (UICollectionViewLayoutAttributes*)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    attributes.frame = CGRectMake(0, _height*indexPath.row, 36.5, _height);
    return attributes;
    
}

@end
