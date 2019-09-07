//
//  UISwitch+Category.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/25.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "UISwitch+Category.h"
#import <objc/runtime.h>
#import "constants.h"


@implementation UISwitch (Category)

- (void)addTargetWithBlock:(void (^)(UISwitch *))target {
    
    self.block = target;
    
    [self addTarget:self action:@selector(clickTheSwitch:) forControlEvents:UIControlEventValueChanged];
}

- (void)clickTheSwitch:(UISwitch *)sender{
    
   // dispatch_main_async_safe(^{
        if (self.block) {
            self.block(sender);
        }
  //  });
}

- (void)setBlock:(void(^)(UISwitch *))block {
    objc_setAssociatedObject(self,@selector(block), block,OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void(^)(UISwitch*))block
{
    return objc_getAssociatedObject(self,@selector(block));
}


@end
