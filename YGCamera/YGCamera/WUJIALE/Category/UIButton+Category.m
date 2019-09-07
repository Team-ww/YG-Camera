//
//  UIButton+Category.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "UIButton+Category.h"
#import <objc/runtime.h>
#import "constants.h"

@implementation UIButton (Category)

- (void)addTargetBlock:(void (^)(UIButton * _Nonnull))target {
    self.block = target;
    [self addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)onClick:(UIButton *)sender {
    
    //dispatch_main_async_safe(^{
        if (self.block) {
            self.block(sender);
        }
   // });
}

- (void)setBlock:(void (^)(UIButton * _Nonnull))block {
    
    objc_setAssociatedObject(self, @selector(block), block, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIButton * _Nonnull))block {
    
    return objc_getAssociatedObject(self, @selector(block));
}



@end
