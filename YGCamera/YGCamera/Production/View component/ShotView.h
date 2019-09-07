//
//  ShotView.h
//  YGCamera
//
//  Created by iOS_App on 2019/4/20.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ShotView : UIView

@property(nonatomic,weak)IBOutlet UIButton *shotImgNormal_Button;
@property(nonatomic,weak)IBOutlet UIButton *menu180_Button;
@property(nonatomic,weak)IBOutlet UIButton *slowModel_Button;
@property(nonatomic,weak)IBOutlet UIButton *trackTime_Button;
@property(nonatomic,weak)IBOutlet UIButton *xqkk_Button;
@property(nonatomic,weak)IBOutlet UIButton *vague_Button;

@property (weak, nonatomic) IBOutlet UIImageView *shotImgNormal_Image;
@property (weak, nonatomic) IBOutlet UIImageView *menu180_Image;
@property (weak, nonatomic) IBOutlet UIImageView *slowModel_Image;
@property (weak, nonatomic) IBOutlet UIImageView *trackTime_Image;
@property (weak, nonatomic) IBOutlet UIImageView *xqkk_Image;
@property (weak, nonatomic) IBOutlet UIImageView *vague_Image;

@property (weak, nonatomic) IBOutlet UILabel *shotImgNormal_Label;
@property (weak, nonatomic) IBOutlet UILabel *menu180_Label;
@property (weak, nonatomic) IBOutlet UILabel *slowModel_Label;
@property (weak, nonatomic) IBOutlet UILabel *trackTime_Label;
@property (weak, nonatomic) IBOutlet UILabel *xqkk_Label;
@property (weak, nonatomic) IBOutlet UILabel *vague_Label;

@property (weak, nonatomic) IBOutlet UIStackView *shotImgNormal_StackView;
@property (weak, nonatomic) IBOutlet UIStackView *menu180_StackView;
@property (weak, nonatomic) IBOutlet UIStackView *slowModel_StackView;
@property (weak, nonatomic) IBOutlet UIStackView *trackTime_StackView;
@property (weak, nonatomic) IBOutlet UIStackView *xqkk_StackView;
@property (weak, nonatomic) IBOutlet UIStackView *vague_StackView;

@end

NS_ASSUME_NONNULL_END
