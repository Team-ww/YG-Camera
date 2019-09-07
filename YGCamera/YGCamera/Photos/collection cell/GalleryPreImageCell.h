//
//  GalleryPreImageCell.h
//  YGCamera
//
//  Created by chen hua on 2019/4/10.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface GalleryPreImageCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *thumbImage;
@property (weak, nonatomic) IBOutlet UIImageView *videoTypeImag;
@property (weak, nonatomic) IBOutlet UIImageView *thumbImageSelectType;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLAb;

@end


NS_ASSUME_NONNULL_END
