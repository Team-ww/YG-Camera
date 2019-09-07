//
//  StepOneViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/29.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "StepOneViewController.h"

@interface StepOneViewController (){
    clickNextStep _block;
}

@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation StepOneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nextButton.layer.cornerRadius = 5;
    self.nextButton.clipsToBounds = YES;
    
}

- (IBAction)clickNext:(UIButton *)sender {
    if (_block) {
        _block();
    }
}

- (void)clickButtonToNextWithBlock:(clickNextStep)block {
    _block = block;
}


@end
