//
//  ACCameraMoveViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/23.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraMoveViewController.h"
#import "constants.h"

#import "CameraMoveTableViewCell.h"
#import "CameraMoveTimeTableViewCell.h"
#import "CameraPhotoTableViewCell.h"
#import "UISlider+Category.h"



@interface ACCameraMoveViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
    NSArray *everArr;
    NSArray *recordArr;
}

@property (weak, nonatomic) IBOutlet UIView *preView;

@property (nonatomic,strong)UITableView *mainTableView;

@property (nonatomic,strong)UILabel *messageLabel;//记录视频时间

@end

@implementation ACCameraMoveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    //初始化
    everArr = @[@1,@2,@60];
    recordArr = @[@30,@60,@(5*60*60)];
    self.moveModel = [[CameraMoveModel alloc] init];
    self.moveModel.mf_number = 15;
    self.moveModel.wt_number = 15;
    self.moveModel.ever_index = 1;
    self.moveModel.ever_number = [(NSNumber *)everArr[self.moveModel.ever_index] integerValue];
    
    self.moveModel.record_index = 1;
    self.moveModel.record_number = [(NSNumber *)recordArr[self.moveModel.record_index] integerValue];
    
    //设置scrollView的ContentSize
    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    CGFloat view_width = width * 0.8 - 44 - 40;
    
    //创建tableView
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, view_width) style:UITableViewStyleGrouped];
    [self.preView addSubview:self.mainTableView];
    self.mainTableView.bounces = NO;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, 30)];
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, 20)];
    self.messageLabel.font = [UIFont systemFontOfSize:12.0];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.text = @"生成 00:01:00 视频";
    
    //修改字体颜色
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.messageLabel.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:53/255.0 blue:56/255.0 alpha:1.0] range:NSMakeRange(3, 8)];
    self.messageLabel.attributedText = attrStr;
    [footerView addSubview:self.messageLabel];
    
    self.mainTableView.tableFooterView = footerView;
    self.mainTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, 10)];
    self.mainTableView.backgroundColor =  [UIColor whiteColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册
    [self.mainTableView registerNib:[UINib nibWithNibName:@"CameraMoveTableViewCell" bundle:nil] forCellReuseIdentifier:@"MoveCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"CameraMoveTimeTableViewCell" bundle:nil] forCellReuseIdentifier:@"TimeCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"CameraPhotoTableViewCell" bundle:nil] forCellReuseIdentifier:@"PhotoCell"];
    
}


#pragma mark 点击开始按钮
- (IBAction)clickStartButton:(UIButton *)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotification_Move" object:self.moveModel];
    
    if (_delegate && [_delegate  respondsToSelector:@selector(clickCancelledBtnWithViewController:)]) {
        [_delegate clickCancelledBtnWithViewController:self];
    }
    
}


#pragma mark tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        CameraPhotoTableViewCell *photoCell = [tableView dequeueReusableCellWithIdentifier:@"PhotoCell" forIndexPath:indexPath];
        return photoCell;
    }
    
    if (indexPath.row == 1 || indexPath.row == 2) {
        
        CameraMoveTableViewCell *moveCell = [tableView dequeueReusableCellWithIdentifier:@"MoveCell" forIndexPath:indexPath];
        [moveCell setCellWithModel:self.moveModel indexPath:indexPath];
        
        //slider滑动事件
        [moveCell.sliderAA addTargetWithBlock:^(UISlider * _Nonnull sender) {
            if (indexPath.row == 1) {
                self.moveModel.mf_number = (NSInteger)sender.value;
            }else if (indexPath.row == 2){
                self.moveModel.wt_number = (NSInteger)sender.value;
            }
            ((AASlider *)sender).valueText = [NSString stringWithFormat:@"%ld",(NSInteger)sender.value];
        }];
        return moveCell;
    }
    
    CameraMoveTimeTableViewCell *timeCell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell" forIndexPath:indexPath];
    [timeCell setCellWithModel:self.moveModel indexPath:indexPath];
    
    //回调
    [timeCell getTimeWithBlock:^(NSInteger leftIndex, NSInteger rightIndex) {
        if (leftIndex != self.moveModel.ever_index) {
            self.moveModel.ever_index = leftIndex;
            self.moveModel.ever_number = [(NSNumber *)self->everArr[leftIndex] integerValue];
        }
        
        if (rightIndex != self.moveModel.record_index) {
            self.moveModel.record_index = rightIndex;
            self.moveModel.record_number = [(NSNumber *)self->recordArr[rightIndex] integerValue];
            
            self.messageLabel.text = [NSString stringWithFormat:@"生成 %@ 视频",[self updateTimeWith:self.moveModel.record_number]];
            NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.messageLabel.text];
            [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:53/255.0 blue:56/255.0 alpha:1.0] range:NSMakeRange(3, 8)];
            self.messageLabel.attributedText = attrStr;
        }
        
        [tableView reloadData];
    }];
    
    return timeCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 70;
    }else if (indexPath.row == 1 || indexPath.row == 2){
        return 40;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark update time
- (NSString *)updateTimeWith:(NSInteger)timeValue {
    
    NSInteger hours = timeValue/3600;
    NSInteger minutes = (timeValue/60)%60;
    NSInteger seconds = timeValue % 60;
    NSString *format = @"%02i:%02i:%02i";
    return [NSString stringWithFormat:format,hours,minutes,seconds];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
