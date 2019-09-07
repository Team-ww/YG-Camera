//
//  ACCameraRockerViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraRockerViewController.h"
#import "ACCameraAirTableViewCell.h"
#import "constants.h"
#import "UISlider+Category.h"


@interface ACCameraRockerViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *infoView;

@property (nonatomic,strong)UITableView *mainTableView;

@end

@implementation ACCameraRockerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    CGFloat view_width = width * 0.8 - 44 - 50;
    
    //初始化
    self.airModel = [[AirCameraModel alloc] init];
    //    dataSourceArray = [[NSMutableArray alloc] init];
    
    self.airModel.pitch_sd = 50;
    self.airModel.roll_sd = 50;
    self.airModel.yaw_sd = 50;
    
    self.airModel.pitch_dh = 50;
    self.airModel.roll_dh = 50;
    self.airModel.yaw_dh = 50;
    
    
    //创建tableView
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, view_width) style:UITableViewStyleGrouped];
    [self.infoView addSubview:self.mainTableView];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.bounces = NO;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.tableFooterView = [[UIView alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, 10)];
    self.mainTableView.tableHeaderView = view;
    self.mainTableView.backgroundColor =  [UIColor whiteColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //注册cell
    [self.mainTableView registerNib:[UINib nibWithNibName:@"ACCameraAirTableViewCell" bundle:nil] forCellReuseIdentifier:@"AirCell"];

}


#pragma mark 点击重置按钮
- (IBAction)clickResetButton:(UIButton *)sender {
    
    self.airModel.pitch_sd = 50;
    self.airModel.roll_sd = 50;
    self.airModel.yaw_sd = 50;
    
    self.airModel.pitch_dh = 50;
    self.airModel.roll_dh = 50;
    self.airModel.yaw_dh = 50;
    
    [self.mainTableView reloadData];
}

#pragma mark 点击按钮保存数据
- (IBAction)clickButtonSaveData:(id)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(rockerClickButtonSaveDateWithViewController:)]) {
        [_delegate rockerClickButtonSaveDateWithViewController:self];
    }
}


#pragma mark delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ACCameraAirTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AirCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell setCellDataWithModel:self.airModel indexPath:indexPath];
    
    //事件
    [cell.ariSlider addTargetWithBlock:^(UISlider * _Nonnull sender) {
        
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                self.airModel.pitch_sd = sender.value;
            }else if (indexPath.row == 1){
                self.airModel.roll_sd = sender.value;
            }else{
                self.airModel.yaw_sd = sender.value;
            }
            
        }else{
            
            if (indexPath.row == 0) {
                self.airModel.pitch_dh = sender.value;
            }else if (indexPath.row == 1){
                self.airModel.roll_dh = sender.value;
            }else {
                self.airModel.yaw_dh = sender.value;
            }
        }
        
        [tableView reloadData];
    }];
    
    return cell;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [[UIView alloc] init];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, 100, 20)];
    [view addSubview:label];
    label.font = [UIFont systemFontOfSize:11 weight:700];
    if (section == 0) {
        label.text = @"跟随速度";
    }else{
        label.text = @"跟随死区";
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0000000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

-  (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}





@end
