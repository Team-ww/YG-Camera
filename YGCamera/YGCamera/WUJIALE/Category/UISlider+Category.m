//
//  UISlider+Category.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "UISlider+Category.h"
#import <objc/runtime.h>
#import "constants.h"


@implementation UISlider (Category)


- (void)addTargetWithBlock:(void (^)(UISlider *))target {
    
    self.block = target;
    
    [self addTarget:self action:@selector(clickTheSwitch:) forControlEvents:UIControlEventValueChanged];
}

- (void)clickTheSwitch:(UISlider *)sender{
    
   // dispatch_main_async_safe(^{
        if (self.block) {
            self.block(sender);
        }
  //  });
}

- (void)setBlock:(void(^)(UISlider *))block {
    objc_setAssociatedObject(self,@selector(block), block,OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(UISlider*))block
{
    return objc_getAssociatedObject(self,@selector(block));
}


@end
