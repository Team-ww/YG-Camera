//
//  HJTAnimationView.m
//  TestPopView
//
//  Created by AEE_ios on 2017/5/26.
//  Copyright © 2017年 AEE_ios. All rights reserved.
//

#import "HJTAnimationView.h"

#import "HJTView.h"
#define  HH  220
// 130
#define SCREENWIDTH      210.0
#define SCREENHEIGHT    [UIScreen mainScreen].bounds.size.height

@interface HJTAnimationView ()

@property (nonatomic) CGFloat count;
@property (nonatomic) CGFloat pointY;
@property (nonatomic) BOOL    isLeft;

//@property (nonatomic,strong) UIButton *chooseBtn;
@end

@implementation HJTAnimationView

- (id)initWithTitleArray:(NSArray *)titlearray picarray:(NSArray *)picarray pointY:(CGFloat)pointY isLeft:(BOOL)isLeft   margin:(CGFloat)margin  selectIndex:(NSInteger)selectIndex
{
    self = [super init];
    if (self) {
        
        _isLeft = isLeft;
        _pointY = pointY;
         _count = picarray.count;
        self.frame = [UIScreen mainScreen].bounds;
        self.largeView = [[UIView alloc]init];
        if (isLeft) {
            [_largeView  setFrame:CGRectMake(0 +margin, _pointY-30 ,SCREENWIDTH,60)];
        }else{
            [_largeView  setFrame:CGRectMake([UIScreen mainScreen].bounds.size.width -SCREENWIDTH, _pointY-30 ,SCREENWIDTH,60)];
        }
//        _largeView.backgroundColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:0.7];
        _largeView.backgroundColor = [UIColor whiteColor];
        _largeView.alpha = 0.8;
        [self addSubview:_largeView];
        __weak typeof (self) selfBlock = self;
        UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc]initWithTarget:selfBlock action:@selector(dismiss)];
        [selfBlock addGestureRecognizer:dismissTap];
        for (int i = 0; i < _count; i ++) {
            
            
            HJTView *rr = [[HJTView alloc]initWithFrame:CGRectMake(_isLeft?i*10:_largeView.frame.size.width+10*i , -5, 60, 60)];//20
//            if (i == 0) {
//                rr.backgroundColor = [UIColor redColor];
//            }
            
            rr.tag = 10 + i;
            rr.sheetBtn.tag = i + 1;
            if (isLeft) {
                
                NSString *str = [NSString stringWithFormat:@"%@",picarray[i]];
                if (i == selectIndex) {
                    str = [NSString stringWithFormat:@"%@Select",str];
                }
                [rr.sheetBtn setImage:[UIImage imageNamed:str] forState:UIControlStateNormal];
            }else{
                NSInteger index= _count-i-1;
                 [rr.sheetBtn setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",picarray[index]]] forState:UIControlStateNormal];
            }
            if (i != selectIndex ) {
                [rr.sheetLab setTextColor:[UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1]];
            }else{
                [rr.sheetLab setTextColor:[UIColor colorWithRed:174/255.0 green:204/255.0 blue:68/255.0 alpha:1]];
            }
            [rr.sheetLab setText:[NSString stringWithFormat:@"%@",titlearray[i]]];
            [rr selectedIndex:^(NSInteger index) {
                selfBlock.block(self->_isLeft?index:self->_count-index+1);
                selfBlock.block = nil;
                [selfBlock dismiss];
            }];
            [self.largeView addSubview:rr];
        }
        
        //selfBlock
    }
    return self;
}

- (void)selectedWithIndex:(CLBlock)block
{
    self.block = block;
}

- (void)CLBtnBlock:(CLBtnBlock)block
{
    self.btnBlock = block;
}

//- (void)chooseBtnClick:(UIButton *)sender
//{
//    if (self.btnBlock) {
//        self.btnBlock(sender);
//        [self dismiss];
//    }
//}

-(void)show
{
    
    CGFloat width = _largeView.frame.size.width;
    HJTView *tempRr =  (HJTView *)[self viewWithTag:10];
    CGFloat widthRR = tempRr.frame.size.width;
    CGFloat margin = (width - widthRR*_count)/(_count+1);
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.1 animations:^{
        
        [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
       // _largeView.transform = CGAffineTransformMakeTranslation(0,   HH+52);
        
    } completion:^(BOOL finished) {
        for (int i = 0; i < _count; i ++) {
            
           //HJTView *rr = [[HJTView alloc]initWithFrame:CGRectMake(150+i*100, 40, 70, 100)];//20
           
            if (_isLeft) {
                 CGPoint location = CGPointMake(margin+(widthRR+margin)*i+widthRR/2, 30);//120
                HJTView *rr =  (HJTView *)[self.largeView viewWithTag:10 +i];
                [UIView animateWithDuration:0.4 delay:i*0.06 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    rr.center=location;
                } completion:nil];
            }else{
                CGPoint location = CGPointMake(margin+(widthRR+margin)*(_count-i-1)+widthRR/2, 30);//120
                HJTView *rr =  (HJTView *)[self.largeView viewWithTag:10 + _count-i-1];
                [UIView animateWithDuration:0.4 delay:i*0.06 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    rr.center=location;
                } completion:nil];
            }
        }
    }];
}


- (void)dismiss {
//    if (self.block) {
//        self.block(1);
//    }
    [UIView animateWithDuration:0.0 animations:^{
        [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
        self->_largeView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {

        [self removeFromSuperview];
    }];
}

@end
