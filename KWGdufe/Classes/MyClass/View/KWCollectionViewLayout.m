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

/*
 *返回集合视图内容的宽度和高度。这些值表示所有内容的宽度和高度，而不仅仅是当前可见的内容。集合视图使用这些信息来配置自己的内容大小以方便滚动。
 */
- (CGSize)collectionViewContentSize{
//    NSLog(@"%f",_height*12);
    //设置collectionView内容大小
    return  CGSizeMake(self.collectionView.frame.size.width, (_height + 8)*12);
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
//    NSLog(@"%f %f %f %f",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    
    NSMutableArray *attrs = [NSMutableArray array];
    
    /*
     CGRectGetHeight返回rect本身的高度
     CGRectGetMinY返回rect顶部的坐标
     CGRectGetMaxY 返回rect底部的坐标
     CGRectGetMinX 返回rect左边缘的坐标
     CGRectGetMaxX 返回rect右边缘的坐标
     CGRectGetMidX表示得到一个rect中心点的X坐标
     CGRectGetMidY表示得到一个rect中心点的Y坐标
     */
    
    CGFloat minY = CGRectGetMinY(rect);
    CGFloat maxY = CGRectGetMaxY(rect);
    CGFloat temp = _height;
    
//    NSLog(@"minY = %f",minY);
//    NSLog(@"maxY = %f",maxY);
//    NSLog(@"temp = %f",temp);
    
    int tagMinY = 1;
    int  tagMaxY;
    
    //计算最小行
    while (minY>temp) {
        tagMinY++;
        temp += _height;
    }
//    NSLog(@"tagMinY = %d",tagMinY);
    
    tagMaxY = tagMinY;
    
    //计算最大行
    while(maxY>temp)
    {
        tagMaxY++;
        temp += _height;
    }
//    NSLog(@"tagMaxY = %d",tagMaxY);
    
    for(int i =tagMinY;i<=tagMaxY;i++)
    {
        NSIndexPath *path = [NSIndexPath indexPathForRow:i-1 inSection:0];//标记第几行，path.row
        //把最左边节数的cell的UICollectionViewLayoutAttributes记录到attrs
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
            //如果开始的数值等于i或结束的数值等于i。决定课程在第几行开始
            if(model.startSec == i)
            {
                
                NSIndexPath *path = [NSIndexPath indexPathForRow:j inSection:0];//设置课程cell的indexPath.row
                tag.weekDay = model.dayInWeek;
                tag.start = model.startSec;
                tag.end = model.endSec;
                //把课程表的大小位置UICollectionViewLayoutAttributes记录到attrs
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
//    NSLog(@"layoutAttributesForItemAtIndexPath = %@",NSStringFromCGRect(attributes.frame));
//    NSLog(@"aaaaaa = %ld",aaaaaa++);
    return attr;
}


- (UICollectionViewLayoutAttributes*)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:elementKind withIndexPath:indexPath];
    attr.frame = CGRectMake(0, _height * indexPath.row, 26.5, _height);
//    NSLog(@"layoutAttributesForSupplementaryViewOfKind = %@",NSStringFromCGRect(attributes.frame));
//    NSLog(@"abc = %ld",abc++);
    return attr;
    
}

@end
