//
//  ACCameraStaticViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/23.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraStaticViewController.h"
#import "constants.h"

#import "WZCollectionViewCell.h"
#import "WZLayout.h"

#import "CameraStaticTableViewCell.h"
#import "CameraStaticSwitchTableViewCell.h"
#import "UISwitch+Category.h"


@interface ACCameraStaticViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
    NSArray *everyArr;//快门间隔
    NSArray *recordArr;//录制时长
}

@property (weak, nonatomic) IBOutlet UIView *messageView;

@property (nonatomic,strong)UITableView *mainTableView;

@property (nonatomic,strong)UILabel *messageLabel;//记录视频时间

@end

@implementation ACCameraStaticViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    CGFloat view_width = width * 0.8 - 44 - 50;
    everyArr = @[@1,@2,@60];
    recordArr = @[@30,@60,@(5*60*60)];
    
    //init
    self.staticModel = [[CameraStaticModel alloc] init];
    self.staticModel.ever_index = 1;
    self.staticModel.every_time = [(NSNumber *)everyArr[self.staticModel.ever_index] integerValue];
    self.staticModel.record_index = 1;
    self.staticModel.record_time = [(NSNumber *)recordArr[self.staticModel.record_index] integerValue];
    self.staticModel.switchFlag = 1;
    
    //创建tableView
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, view_width) style:UITableViewStyleGrouped];
    [self.messageView addSubview:self.mainTableView];
    self.mainTableView.bounces = NO;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, 60)];
    self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, 20)];
    self.messageLabel.font = [UIFont systemFontOfSize:12.0];
    self.messageLabel.textAlignment = NSTextAlignmentCenter;
    self.messageLabel.text = @"生成 00:01:00 视频";
    
    //修改字体颜色
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.messageLabel.text];
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:53/255.0 blue:56/255.0 alpha:1.0] range:NSMakeRange(3, 8)];
    self.messageLabel.attributedText = attrStr;
    [footerView addSubview:self.messageLabel];
    
    [footerView addSubview:self.messageLabel];
    
    self.mainTableView.tableFooterView = footerView;
    self.mainTableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, 10)];
    self.mainTableView.backgroundColor =  [UIColor whiteColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    //注册
    [self.mainTableView registerNib:[UINib nibWithNibName:@"CameraStaticTableViewCell" bundle:nil] forCellReuseIdentifier:@"StaticCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"CameraStaticSwitchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];

}


#pragma mark 点击开始按钮
- (IBAction)clickStartButton:(UIButton *)sender {
 
    self.staticModel.every_time = [(NSNumber *)everyArr[self.staticModel.ever_index] integerValue];
    self.staticModel.record_time = [(NSNumber *)recordArr[self.staticModel.record_index] integerValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotification_static" object:self.staticModel];
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickStartButtonWithController:)]) {
        [_delegate clickStartButtonWithController:self];
    }
    
}


#pragma mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2) {
        
        CameraStaticSwitchTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
        [switchCell setSwitchWithData:self.staticModel.switchFlag];
        
        //事件
        [switchCell.staticSwitch addTargetWithBlock:^(UISwitch * _Nonnull sender) {
            self.staticModel.switchFlag = !self.staticModel.switchFlag;
            [tableView reloadData];
        }];
        
        return switchCell;
    }
    
    CameraStaticTableViewCell *staticCell = [tableView dequeueReusableCellWithIdentifier:@"StaticCell" forIndexPath:indexPath];
    [staticCell setCellWithData:@[] indexPath:indexPath];
    
    [staticCell getStaticTimeWithBlock:^(NSInteger index) {
        
        if (indexPath.row == 0) {
            if (index != self.staticModel.ever_index) {
                self.staticModel.ever_index = index;
                self.staticModel.every_time = [(NSNumber *)self->everyArr[index] integerValue];
            }
        }else{
            if (index != self.staticModel.record_index) {
                self.staticModel.record_index = index;
                self.staticModel.record_time = [(NSNumber *)self->recordArr[index] integerValue];
                
                self.messageLabel.text = [NSString stringWithFormat:@"生成 %@ 视频",[self updateTimeWith:self.staticModel.record_time]];
                NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.messageLabel.text];
                [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:244/255.0 green:53/255.0 blue:56/255.0 alpha:1.0] range:NSMakeRange(3, 8)];
                self.messageLabel.attributedText = attrStr;
                
            }
        }
    
    }];
        
    return staticCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
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
