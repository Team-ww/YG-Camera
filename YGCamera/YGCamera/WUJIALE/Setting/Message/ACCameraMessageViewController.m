//
//  ACCameraMessageViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraMessageViewController.h"
#import "ACCameraMessageTableViewCell.h"
#import "ACCameraMessageArrowTableViewCell.h"
#import "constants.h"


@interface ACCameraMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (nonatomic,strong)UITableView *mainTableView;

@end

@implementation ACCameraMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    
    //初始化
    self.messageModel = [[CameraMessageModel alloc] init];
    self.messageModel.cameraName = @"SMART S1";
    self.messageModel.version = @"1.0.0";
    self.messageModel.liveMessage = @"正在开发中";
    
    //创建tableView
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, width * 0.8 - 44) style:UITableViewStylePlain];
    [self.infoView addSubview:self.mainTableView];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.bounces = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, 15)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, 10)];
    self.mainTableView.tableHeaderView = view;
    self.mainTableView.backgroundColor =  [UIColor whiteColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //注册cell
    [self.mainTableView registerNib:[UINib nibWithNibName:@"ACCameraMessageTableViewCell" bundle:nil] forCellReuseIdentifier:@"MessageCell"];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"ACCameraMessageArrowTableViewCell" bundle:nil] forCellReuseIdentifier:@"ArrowCell"];
    
}



#pragma mark tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2) {
        
        ACCameraMessageTableViewCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell" forIndexPath:indexPath];
        [messageCell setCellWithModel:self.messageModel indexPath:indexPath];
        return messageCell;
    }
    
    ACCameraMessageArrowTableViewCell *arrowCell = [tableView dequeueReusableCellWithIdentifier:@"ArrowCell" forIndexPath:indexPath];
    [arrowCell setCellWithIndex:indexPath];
    return arrowCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




















@end
