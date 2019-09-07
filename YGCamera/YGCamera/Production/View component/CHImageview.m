//
//  CHImageview.m
//  YGCamera
//
//  Created by chen hua on 2019/4/7.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "CHImageview.h"

@implementation CHImageview


+(UIView *)getInstanceWithImage:(NSInteger)imageIndex frame:(CGRect)frame userInteractionEnabled:(BOOL)userInteractionEnabled{
    
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1.JPEG"]];
    imageView.userInteractionEnabled = userInteractionEnabled;
    imageView.frame = view.bounds;
    imageView.contentMode =  UIViewContentModeScaleAspectFill;
    
    view.layer.shadowColor = [UIColor blackColor].CGColor;
    view.layer.shadowOpacity = 0.2f;
    view.layer.shadowRadius = 8.f;
    view.layer.cornerRadius = 5;
    //myImageView.backgroundColor=kRedColor;
    view.layer.shadowOffset = CGSizeMake(0,10);
    
    view.layer.masksToBounds = YES;
    [view addSubview:imageView];
    
    return view;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
