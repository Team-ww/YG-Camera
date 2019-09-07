//
//  StepTwoViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/29.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "StepTwoViewController.h"

@interface StepTwoViewController (){
    clickNextBlock _block;
}
@property (weak, nonatomic) IBOutlet UIButton *nextButton;

@end

@implementation StepTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.nextButton.layer.cornerRadius = 5;
    self.nextButton.clipsToBounds = YES;
    
}

- (IBAction)clickNext:(id)sender {
    if (_block) {
        _block();
    }
}

- (void)clickButtonToNextWithBlock:(clickNextBlock)block {
    _block = block;
}

@end
