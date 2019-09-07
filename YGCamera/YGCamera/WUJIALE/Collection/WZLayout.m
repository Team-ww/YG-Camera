//
//  WZLayout.m
//  audioPickerDemo
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 吴家乐. All rights reserved.
//

#import "WZLayout.h"

@implementation WZLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}


- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    CGFloat collectionW = self.collectionView.bounds.size.width;
    
    NSArray<UICollectionViewLayoutAttributes *> *attrs = [super layoutAttributesForElementsInRect:self.collectionView.bounds];
    
    for (int i = 0; i < attrs.count; i++) {
        
        UICollectionViewLayoutAttributes *attr = attrs[i];
        
        //距离中心距离
        CGFloat margin = fabs((attr.center.x - self.collectionView.contentOffset.x) - collectionW * 0.5);
        
        //缩放比例
        CGFloat scale = 1 - (margin / (collectionW * 0.5)) * 0.35;
        
        attr.transform = CGAffineTransformMakeScale(scale, scale);
        
        
    }
    
    
    return attrs;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {

    CGFloat collectionW =  self.collectionView.bounds.size.width;
    
    CGPoint  targetp = proposedContentOffset;
    
    //横向滚动，所以只考虑x和width，纵向暂时不考虑
    NSArray *attrs = [super layoutAttributesForElementsInRect:CGRectMake(targetp.x, 0, collectionW, MAXFLOAT)];
    
    //距离中心点的最小间距
    CGFloat  minSpacing = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *attr in attrs) {
        //距离中心点的偏移量
        CGFloat centerOffsetX = attr.center.x - targetp.x - collectionW * 0.5;
        if (fabs(centerOffsetX) < fabs(minSpacing)) {
            minSpacing = centerOffsetX;
        }
    }
    
    targetp.x += minSpacing;
    
    return targetp;
    
}






@end
