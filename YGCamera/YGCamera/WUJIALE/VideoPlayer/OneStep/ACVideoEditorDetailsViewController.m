//
//  ACVideoEditorDetailsViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/29.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACVideoEditorDetailsViewController.h"

@interface ACVideoEditorDetailsViewController (){
    cancelVideoEditorBlock _block;
    saveVideoEditorBlock _blockSave;
}

@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation ACVideoEditorDetailsViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark 放弃修改

- (IBAction)dismiss:(id)sender {
    if (_block) {
        _block();
    }
}

#pragma mark 保存
- (IBAction)save:(id)sender {
    if (_blockSave) {
        _blockSave();
    }
}

#pragma mark block
- (void)clickButtonCancelWithBlock:(cancelVideoEditorBlock)block {
    _block = block;
}

- (void)clickButtonSaveEditorVideoWithBlock:(saveVideoEditorBlock)block {
    _blockSave = block;
}

@end
