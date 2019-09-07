//
//  ACCameraAreaSettingViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/23.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraAreaSettingViewController.h"
#import "constants.h"
#import "CameraAreTableViewCell.h"
#import "CameraTimeAreaTableViewCell.h"
#import "UISwitch+Category.h"
#import "CameraAreaSwitchTableViewCell.h"


@interface ACCameraAreaSettingViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
    NSArray *wtArr;
    NSArray *mfArr;
    NSArray *recordArr;
}

@property (weak, nonatomic) IBOutlet UIView *infoView;
@property (nonatomic,strong)UITableView *mainTableView;

@end

@implementation ACCameraAreaSettingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    CGFloat view_width = width * 0.8 - 44 - 40;
    [self getReloadData];
//    wtArr = @[@(1),@(1.5),@(2.0),@(2.5),@(3),@(3.5),@(4),@(4.5),@(5),@(5.5),@(6),@(6.5),@(7),@(7.5),@(8),@(8.5),@(9),@(9.5),@(10)];
////    wtArr = @[@(0.0),@(0.5),@(1.0)];
////    mfArr = @[@0,@1,@2];
//    mfArr = @[@(0),@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(1.0)];
//
//    recordArr = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25,@26,@27,@28,@29,@30,@31,@32,@33,@34,@35,@36,@37,@38,@39,@40,@41,@42,@43,@44,@45,@46,@47,@48,@49,@50,@51,@52,@53,@54,@55,@56,@57,@58,@59,@60];
//
//    self.areaModel = [[CameraAreaModel alloc] init];
//    self.areaModel.wt_st_index = 1;
//    self.areaModel.wt_st_number = [(NSNumber *)wtArr[self.areaModel.wt_st_index] floatValue];
//
//    self.areaModel.mf_st_index = 1;
//    self.areaModel.mf_st_number = [(NSNumber *)mfArr[self.areaModel.mf_st_index] integerValue];
//
//    self.areaModel.st_flag = 1;
//
//    self.areaModel.wt_ed_index = 1;
//    self.areaModel.wt_ed_number = [(NSNumber *)wtArr[self.areaModel.wt_ed_index] floatValue];
//
//    self.areaModel.mf_ed_index = 1;
//    self.areaModel.mf_ed_number = [(NSNumber *)mfArr[self.areaModel.mf_ed_index] integerValue];
//
//    self.areaModel.ed_flag = 1;
//
//    self.areaModel.record_index = 1;
//    self.areaModel.record_time = [(NSNumber *)recordArr[self.areaModel.record_index] integerValue];
    
    //创建tableView
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, view_width) style:UITableViewStyleGrouped];
    [self.infoView addSubview:self.mainTableView];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.bounces = NO;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, 10)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, 10)];
    self.mainTableView.tableHeaderView = view;
    self.mainTableView.backgroundColor =  [UIColor whiteColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册cell
    [self.mainTableView registerNib:[UINib nibWithNibName:@"CameraAreTableViewCell" bundle:nil] forCellReuseIdentifier:@"AreaCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"CameraTimeAreaTableViewCell" bundle:nil] forCellReuseIdentifier:@"TimeCell"];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"CameraAreaSwitchTableViewCell" bundle:nil] forCellReuseIdentifier:@"switchCell"];
}

- (void)getReloadData{
    
    wtArr = @[@(1),@(1.5),@(2.0),@(2.5),@(3),@(3.5),@(4),@(4.5),@(5),@(5.5),@(6),@(6.5),@(7),@(7.5),@(8),@(8.5),@(9),@(9.5),@(10)];
    
    //    wtArr = @[@(0.0),@(0.5),@(1.0)];
    //    mfArr = @[@0,@1,@2];
    mfArr = @[@(0),@(0.1),@(0.2),@(0.3),@(0.4),@(0.5),@(0.6),@(0.7),@(0.8),@(0.9),@(1.0)];
    
    recordArr = @[@1,@2,@3,@4,@5,@6,@7,@8,@9,@10,@11,@12,@13,@14,@15,@16,@17,@18,@19,@20,@21,@22,@23,@24,@25,@26,@27,@28,@29,@30,@31,@32,@33,@34,@35,@36,@37,@38,@39,@40,@41,@42,@43,@44,@45,@46,@47,@48,@49,@50,@51,@52,@53,@54,@55,@56,@57,@58,@59,@60];
    
    self.areaModel = [[CameraAreaModel alloc] init];
    self.areaModel.wtArr = [NSMutableArray arrayWithArray:wtArr];
    self.areaModel.mfArr = [NSMutableArray arrayWithArray:mfArr];
    self.areaModel.recordArr = [NSMutableArray arrayWithArray:recordArr];
    
    
    self.areaModel.wt_st_index = 1;
    self.areaModel.wt_st_number = [(NSNumber *)wtArr[self.areaModel.wt_st_index] floatValue];
    self.areaModel.mf_st_index = 1;
    self.areaModel.mf_st_number = [(NSNumber *)mfArr[self.areaModel.mf_st_index] integerValue];
    self.areaModel.st_flag = 1;
    self.areaModel.wt_ed_index = 1;
    self.areaModel.wt_ed_number = [(NSNumber *)wtArr[self.areaModel.wt_ed_index] floatValue];
    
    self.areaModel.mf_ed_index = 1;
    self.areaModel.mf_ed_number = [(NSNumber *)mfArr[self.areaModel.mf_ed_index] integerValue];
    self.areaModel.ed_flag = 1;
    self.areaModel.record_index = 1;
    self.areaModel.record_time = [(NSNumber *)recordArr[self.areaModel.record_index] integerValue];
}

#pragma mark 点击开始按钮

- (IBAction)clickStartButton:(UIButton *)sender {
 
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotification_Area" object:self.areaModel];
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickBeginBtnWithViewController:)]) {
        [_delegate clickBeginBtnWithViewController:self];
    }
    NSLog(@"====> get status is wt_st = %.2f mf_st = %ld wt_ed = %.2f mf_ed = %ld record = %ld",self.areaModel.wt_st_number,self.areaModel.mf_st_number,self.areaModel.wt_ed_number,self.areaModel.mf_ed_number,self.areaModel.record_time);
}


#pragma mark tableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section != 2) {
        return 2;
    }
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        CameraTimeAreaTableViewCell *timeCell = [tableView dequeueReusableCellWithIdentifier:@"TimeCell" forIndexPath:indexPath];
        [timeCell setCellWithData:self.areaModel indexPath:indexPath];
        
        //回调
        [timeCell getRecordTimeWithBlock:^(NSInteger selectedIndex) {
            
            
            self.areaModel.record_index = selectedIndex;
            self.areaModel.record_time = [(NSNumber *)self->recordArr[self.areaModel.record_index] integerValue];
            [tableView reloadData];
            
            //设置时间
            
        }];
        return timeCell;
    }
    
    
    if ((indexPath.section == 0 && indexPath.row == 1) || (indexPath.section == 1 && indexPath.row == 1)) {
        
        CameraAreaSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"switchCell" forIndexPath:indexPath];
        [cell setCellWithData:self.areaModel indexPath:indexPath];
        //block
        [cell.areaSwitch addTargetWithBlock:^(UISwitch * _Nonnull sender) {
            
            if (indexPath.section == 0) {
                self.areaModel.st_flag = !self.areaModel.st_flag;
                sender.on = self.areaModel.st_flag;
                
                [cell.prewView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                   
                    if ([obj isKindOfClass:[UICollectionView class]]) {
                     
                        *stop = YES;
                        UICollectionView *view = (UICollectionView *)obj;
                        if (!self.areaModel.st_flag) {
                            view.scrollEnabled = NO;
                        }else{
                            view.scrollEnabled = YES;
                        }
                    }
                    
                }];
                
            }else{
                self.areaModel.ed_flag = !self.areaModel.ed_flag;
                sender.on = self.areaModel.ed_flag;
                
                [cell.prewView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([obj isKindOfClass:[UICollectionView class]]) {
                        
                        *stop = YES;
                        UICollectionView *view = (UICollectionView *)obj;
                        if (!self.areaModel.ed_flag) {
                            view.scrollEnabled = NO;
                        }else{
                            view.scrollEnabled = YES;
                        }
                    }
                    
                }];
            }
            
            
        }];
        
        [cell getMfValueWithBlock:^(NSInteger mfIndex) {
            
            if (indexPath.section == 0 && indexPath.row == 1) {
                self.areaModel.mf_st_index = mfIndex;
                self.areaModel.mf_st_number = [(NSNumber *)self->mfArr[self.areaModel.mf_st_index] integerValue];
            }else{
                self.areaModel.mf_ed_index = mfIndex;
                self.areaModel.mf_ed_number = [(NSNumber *)self->mfArr[self.areaModel.mf_ed_index] integerValue];
            }
            
        }];
        return cell;
    }
    
    
    CameraAreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AreaCell" forIndexPath:indexPath];
    [cell setCellWithData:self.areaModel index:indexPath];
    
    //回调
    [cell getStAdEdWithBlock:^(NSInteger wtIndex) {
        
        if (indexPath.section == 0) {
            
            self.areaModel.wt_st_index = wtIndex;
            self.areaModel.wt_st_number = [(NSNumber *)self->wtArr[self.areaModel.wt_st_index] floatValue];
            
        }else{
            
            self.areaModel.wt_ed_index = wtIndex;
            self.areaModel.wt_ed_number = [(NSNumber *)self->wtArr[self.areaModel.wt_ed_index] floatValue];
        }
        
        [tableView reloadData];
    }];
    
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 2) {
        
        return 40;
    }
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    if (section != 2) {
        return 10;
    }
    return 0.000001;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    
    return [[UIView alloc] init];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.00001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] init];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
