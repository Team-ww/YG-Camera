//
//  CHImageview.h
//  YGCamera
//
//  Created by chen hua on 2019/4/7.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CHImageview : UIImageView


+(UIView *)getInstanceWithImage:(NSInteger)imageIndex frame:(CGRect)frame userInteractionEnabled:(BOOL)userInteractionEnabled;





@end

NS_ASSUME_NONNULL_END
