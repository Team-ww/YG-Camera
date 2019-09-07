//
//  ACCameraSTViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/24.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACCameraSTViewController.h"
#import "ACCameraSTTableViewCell.h"
#import "ACCameraSwitchTableViewCell.h"
#import "constants.h"
#import "UIButton+Category.h"
#import "UISwitch+Category.h"
#import "PreviewVC.h"
#import "LineView.h"
#import "NineView.h"

@interface ACCameraSTViewController ()<UITableViewDataSource,UITableViewDelegate> {
    NSMutableArray *datasourceArray;//所有数据
    selectedIndexBlock _block;
}

@property (weak, nonatomic) IBOutlet UIView *infoView;

@end

@implementation ACCameraSTViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CGFloat width = MIN(KMainScreenWidth, KMainScreenHeight);
    
    //初始化
    self.cameraModel = [[CameraSetModel alloc] init];
    datasourceArray = [[NSMutableArray alloc] init];
    
    //模拟数据
    NSArray *resolution = @[@"3840 X 2160",@"1920x1080",@"1280 X 720"];
    NSArray *grad = @[@"无",@"九宫格",@"对角线"];
    NSArray *preview = @[@"全屏",@"最佳预览"];
    NSNumber * model = @1;
    NSNumber *shake = @1;
    NSArray *speed = @[@"快",@"中",@"慢"];
    
    self.cameraModel.videoResolution_indx = 0;
    self.cameraModel.videoResolution = resolution[self.cameraModel.videoResolution_indx];
    self.cameraModel.gridType_indx = 0;
    self.cameraModel.gridType = grad[self.cameraModel.gridType_indx];
    self.cameraModel.previewModel_indx = 0;
    self.cameraModel.previewModel = preview[self.cameraModel.previewModel_indx];
    self.cameraModel.speed_indx = 1;
    self.cameraModel.shakeIndex = 1;
    self.cameraModel.speed = speed[self.cameraModel.speed_indx];
    [self getResolutionIndex];
    [datasourceArray addObject:resolution];
    [datasourceArray addObject:grad];
    [datasourceArray addObject:preview];
    [datasourceArray addObject:model];
    [datasourceArray addObject:shake];
    [datasourceArray addObject:speed];

    //创建tableView
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, width * 0.8 - 44) style:UITableViewStylePlain];
    [self.infoView addSubview:self.mainTableView];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.bounces = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, 20)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width * 0.8, 10)];
    self.mainTableView.tableHeaderView = view;
    self.mainTableView.backgroundColor =  [UIColor whiteColor];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    //注册cell
    [self.mainTableView registerNib:[UINib nibWithNibName:@"ACCameraSTTableViewCell" bundle:nil] forCellReuseIdentifier:@"STCell"];
    
    [self.mainTableView registerNib:[UINib nibWithNibName:@"ACCameraSwitchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
}



#pragma mark tableView delegate


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0 || indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 5) {
        ACCameraSTTableViewCell *STCell = [tableView dequeueReusableCellWithIdentifier:@"STCell" forIndexPath:indexPath];
        //设置cell
        
        [self getResolutionIndex];
        [self getGirdTypeIndex];
        [self getPreviewModeIndex];
        [self getZoomSpeedMode];
       
        if (indexPath.row == 0) {
            [STCell setCellDataWithArr:datasourceArray[0] index:indexPath selected:self.cameraModel.videoResolution_indx];
        }else if (indexPath.row == 1){
            [STCell setCellDataWithArr:datasourceArray[1] index:indexPath selected:self.cameraModel.gridType_indx];
        }else if (indexPath.row == 2){
            [STCell setCellDataWithArr:datasourceArray[2] index:indexPath selected:self.cameraModel.previewModel_indx];
        }else if (indexPath.row == 5){
            [STCell setCellDataWithArr:datasourceArray[5] index:indexPath selected:self.cameraModel.speed_indx];
        }
        //回调滑动offset
        [STCell setScrollViewContentOffsetWithBlock:^(NSInteger offset) {
            
            if (indexPath.row == 0) {
                self.cameraModel.videoResolution_indx = offset;
                self.cameraModel.videoResolution = self->datasourceArray[0][self.cameraModel.videoResolution_indx];
                //更新
                [self updateCameraResolutionWithIndex:self.cameraModel.videoResolution_indx];
            }else if (indexPath.row == 1){
                self.cameraModel.gridType_indx = offset;
                self.cameraModel.gridType = self->datasourceArray[1][offset];
                //更新
                [self setGirdTypeWithIndex: self.cameraModel.gridType_indx];
            }else if (indexPath.row == 2){
                self.cameraModel.previewModel_indx = offset;
                self.cameraModel.previewModel = self->datasourceArray[2][offset];
                
                //更新
                [self setPreviewModeWithIndex:self.cameraModel.previewModel_indx];
            }else if (indexPath.row == 5){
                self.cameraModel.speed_indx = offset;
                self.cameraModel.speed = self->datasourceArray[5][offset];
            }
            
        }];

//        [STCell setCellDataWithArr:@[self.cameraModel.videoResolution,
//                                      self.cameraModel.gridType,
//                                      self.cameraModel.previewModel,
//                                      self.cameraModel.speed] index:indexPath];
        //设置向前
        [STCell.leftButton addTargetBlock:^(UIButton * _Nonnull sender) {
            
            NSLog(@"====> index = %ld",indexPath.row);
            
            if (indexPath.row == 0) {
                NSInteger index = self.cameraModel.videoResolution_indx - 1;
                if (index >= 0 && index < [self->datasourceArray[0] count]) {
                    
                    self.cameraModel.videoResolution_indx -= 1;
                    self.cameraModel.videoResolution = self->datasourceArray[0][self.cameraModel.videoResolution_indx];
                }
                
                [self updateCameraResolutionWithIndex:self.cameraModel.videoResolution_indx];
                if (self->_block) {
                    self->_block(indexPath.row,self.cameraModel.videoResolution_indx,self.cameraModel.videoResolution);
                }
            }else if (indexPath.row == 1){
                
                NSInteger index = self.cameraModel.gridType_indx - 1;
                if (index >=0 && index < [self->datasourceArray[1] count]) {
                    self.cameraModel.gridType_indx -= 1;
                    self.cameraModel.gridType = self->datasourceArray[1][self.cameraModel.gridType_indx];
                }
                
                [self setGirdTypeWithIndex: self.cameraModel.gridType_indx];
                if (self->_block) {
                    self->_block(indexPath.row,self.cameraModel.gridType_indx,self.cameraModel.gridType);
                }
                
            }else if (indexPath.row == 2){
                
                NSInteger index = self.cameraModel.previewModel_indx - 1;
                if (index >= 0 && index < [self->datasourceArray[2] count]) {
                    self.cameraModel.previewModel_indx -= 1;
                    
                    //NSLog(@"previewModel_indx ====%ld",(long)self.cameraModel.previewModel_indx);
                    self.cameraModel.previewModel = self->datasourceArray[2][self.cameraModel.previewModel_indx];
                }
                
                [self setPreviewModeWithIndex:self.cameraModel.previewModel_indx];
                if (self->_block) {
                    self->_block(indexPath.row,self.cameraModel.previewModel_indx,self.cameraModel.previewModel);
                }
                
            }else if (indexPath.row == 5){
                
                NSInteger index = self.cameraModel.speed_indx - 1;
                if (index >= 0 && index < [self->datasourceArray[5] count]) {
                    self.cameraModel.speed_indx -= 1;
                    self.cameraModel.speed = self->datasourceArray[5][self.cameraModel.speed_indx];
                }
                [self setZoomSpeedWithIndex:self.cameraModel.speed_indx];
                if (self->_block) {
                    self->_block(indexPath.row,self.cameraModel.speed_indx,self.cameraModel.speed);
                }
            }
            
            [tableView reloadData];
        }];
        
        //相后
        [STCell.rightButton addTargetBlock:^(UIButton * _Nonnull sender) {
            
            NSLog(@"====> index = %ld",indexPath.row);
            
            if (indexPath.row == 0) {
                NSInteger index = self.cameraModel.videoResolution_indx + 1;
                if (index >= 0 && index < [self->datasourceArray[0] count]) {
                    self.cameraModel.videoResolution_indx += 1;
                    self.cameraModel.videoResolution = self->datasourceArray[0][self.cameraModel.videoResolution_indx];
                }
                [self updateCameraResolutionWithIndex:self.cameraModel.videoResolution_indx];
                if (self->_block) {
                    self->_block(indexPath.row,self.cameraModel.videoResolution_indx,self.cameraModel.videoResolution);
                }
            }else if (indexPath.row == 1){
                
                NSInteger index = self.cameraModel.gridType_indx + 1;
                if (index >=0 && index < [self->datasourceArray[1] count]) {
                    self.cameraModel.gridType_indx += 1;
                    self.cameraModel.gridType = self->datasourceArray[1][self.cameraModel.gridType_indx];
                }
                [self setGirdTypeWithIndex: self.cameraModel.gridType_indx];
                if (self->_block) {
                    self->_block(indexPath.row,self.cameraModel.gridType_indx,self.cameraModel.gridType);
                }
                
            }else if (indexPath.row == 2){
                
                NSInteger index = self.cameraModel.previewModel_indx + 1;
                if (index >= 0 && index < [self->datasourceArray[2] count]) {
                    self.cameraModel.previewModel_indx += 1;
                    self.cameraModel.previewModel = self->datasourceArray[2][self.cameraModel.previewModel_indx];
                }
                [self setPreviewModeWithIndex:self.cameraModel.previewModel_indx];
                if (self->_block) {
                    self->_block(indexPath.row,self.cameraModel.previewModel_indx,self.cameraModel.previewModel);
                }
                
            }else if (indexPath.row == 5){
                
                NSInteger index = self.cameraModel.speed_indx + 1;
                if (index >= 0 && index < [self->datasourceArray[5] count]) {
                    self.cameraModel.speed_indx += 1;
                    self.cameraModel.speed = self->datasourceArray[5][self.cameraModel.speed_indx];
                }
                
                if (self->_block) {
                    self->_block(indexPath.row,self.cameraModel.speed_indx,self.cameraModel.speed);
                }
            }
            
            [tableView reloadData];
        }];
        return STCell;
    }
    
    ACCameraSwitchTableViewCell *switchCell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell" forIndexPath:indexPath];
    [self getCameraParameterShowStatus];
    [self getShakeMode];
    //设置cell
    [switchCell setSwitchStatus:@[@(self.cameraModel.cameraModel),
                                  @(self.cameraModel.shakeIndex)] index:indexPath];
    
    //调试
    [switchCell.modelSwitch addTargetWithBlock:^(UISwitch * _Nonnull sender) {

        NSInteger flag = [self->datasourceArray[indexPath.row] integerValue];
        self->datasourceArray[indexPath.row] = @(!flag);
        if (indexPath.row == 3) {
            self.cameraModel.cameraModel = !flag;
            [self openCameraParameterHandleChange:sender.on];
            if (self->_block) {
                self->_block(indexPath.row,self.cameraModel.cameraModel,nil);
            }
        }else if(indexPath.row == 4){
            self.cameraModel.shakeIndex = !flag;
            [self setShakeMode:sender.on];
            if (self->_block) {
                self->_block(indexPath.row,self.cameraModel.shakeIndex,nil);
            }
        }
        [tableView reloadData];
        NSLog(@" switch is %d  index %ld",!flag,indexPath.row);
    }];
    
    return switchCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark ---block

- (void)selectedCellGetValueWith:(selectedIndexBlock)block {
    _block = block;
}


//设置分辨率
- (void)updateCameraResolutionWithIndex:(NSInteger)indexResolution{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    AVCaptureSessionPreset preset = vc.controller.captureSessionPreset ;
    if ([preset  isEqualToString:AVCaptureSessionPreset3840x2160] && indexResolution == 0) {
       
        return ;
    }else if ([preset  isEqualToString:AVCaptureSessionPreset1920x1080] && indexResolution == 1){
        
        return ;
    }else if ([preset  isEqualToString:AVCaptureSessionPreset1280x720] && indexResolution == 2){
       
        return;
    
    }
    if (indexResolution == 0) {
        
        preset = AVCaptureSessionPreset3840x2160;
    }else if (indexResolution == 1){
        
        preset = AVCaptureSessionPreset1920x1080;
    }else if (indexResolution == 2){
        
        preset = AVCaptureSessionPreset1280x720;
    }
    vc.controller.captureSessionPreset = preset;
    //[vc.controller cameraBackgroundDidChangeVideoQuality:preset desiredFPS:vc.controller.frameRate];
}

- (NSInteger)getResolutionIndex{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    AVCaptureSessionPreset preset = vc.controller.captureSessionPreset ;
    if ([preset  isEqualToString:AVCaptureSessionPreset3840x2160]) {
        self.cameraModel.videoResolution_indx = 0;
        self.cameraModel.videoResolution = @"3840 X 2160";
        return 0;
    }else if ([preset  isEqualToString:AVCaptureSessionPreset1920x1080]){
        self.cameraModel.videoResolution_indx = 1;
        self.cameraModel.videoResolution = @"1920x1080";
        return 1;
    }else if ([preset  isEqualToString:AVCaptureSessionPreset1280x720]){
        self.cameraModel.videoResolution_indx = 2;
        self.cameraModel.videoResolution = @"1280 X 720";
        return 2;
    }
    return 0;
}

//设置预览显示模式
- (void)setPreviewModeWithIndex:(NSUInteger)index{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    if (index == 1) { //最佳预览
        vc.myGPUImageView.fillMode = kGPUImageFillModePreserveAspectRatio;
    }else{//全屏
        vc.myGPUImageView.fillMode = kGPUImageFillModeStretch;
    }
   
}

//获取预览显示模式
- (NSInteger)getPreviewModeIndex{

    PreviewVC *vc = (PreviewVC *)self.delegate;
    GPUImageFillModeType modeType = vc.myGPUImageView.fillMode;
    if (modeType == kGPUImageFillModePreserveAspectRatio) {
        
        self.cameraModel.previewModel = @"最佳预览";
        self.cameraModel.previewModel_indx = 1;
        return 1;
    }else{
        self.cameraModel.previewModel = @"全屏";
        self.cameraModel.previewModel_indx = 0;
        return 0;
    }
}

- (void)setGirdTypeWithIndex:(NSInteger)index{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    if (vc.gridMode == index) {
        return;
    }
    vc.gridMode = index;
    if (index == 0) {
        [self removeDiagonalAndNineView];
    }else if (index == 1){
        [self addNineView];
    }else if (index == 2){
        [self addDiagonal];
    }
}

- (NSInteger)getGirdTypeIndex{
    PreviewVC *vc = (PreviewVC *)self.delegate;
    self.cameraModel.gridType_indx = vc.gridMode;
    NSArray *grad = @[@"无",@"九宫格",@"九宫格+对角线"];
    self.cameraModel.gridType = grad[self.cameraModel.gridType_indx];
    return vc.gridMode;
}


#pragma mark 对角线加九宫格
- (void)addDiagonal {
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    [vc.functionView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LineView class]] || [obj isKindOfClass:[NineView class]]) {
            *stop = YES;
            [obj removeFromSuperview];
            obj = nil;
        }
    }];
    
    //添加View
    LineView *lineView = [[LineView alloc] initWithFrame:CGRectMake(0, 0, MAX(KMainScreenWidth, KMainScreenHeight), MIN(KMainScreenWidth, KMainScreenHeight))];
    lineView.backgroundColor = [UIColor clearColor];
    [vc.functionView addSubview:lineView];
    [vc.functionView insertSubview:lineView atIndex:1];
}

#pragma mark 九宫格
- (void)addNineView {
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    [vc.functionView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LineView class]] || [obj isKindOfClass:[NineView class]]) {
            *stop = YES;
            [obj removeFromSuperview];
            obj = nil;
        }
    }];
    
    NineView *nineView = [[NineView alloc] initWithFrame:CGRectMake(0, 0, MAX(KMainScreenWidth, KMainScreenHeight), MIN(KMainScreenWidth, KMainScreenHeight))];
    nineView.backgroundColor = [UIColor clearColor];
    [vc.functionView addSubview:nineView];
    [vc.functionView insertSubview:nineView atIndex:1];
}

#pragma mark 移除对角线 九宫格
- (void)removeDiagonalAndNineView{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    [vc.functionView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LineView class]] || [obj isKindOfClass:[NineView class]]) {
            *stop = YES;
            [obj removeFromSuperview];
            obj = nil;
        }
    }];
}

//NSArray *grad = @[@"无",@"九宫格",@"对角线"];
//相机手动模式

- (void)openCameraParameterHandleChange:(BOOL)isOPen{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    vc.bottomParametersView.hidden = !isOPen;
}


- (BOOL)getCameraParameterShowStatus{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    self.cameraModel.cameraModel = vc.bottomParametersView.hidden == YES?0:1;
    return  !vc.bottomParametersView.hidden ;
}

//相机防抖动

- (void)setShakeMode:(BOOL)isOpen{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    if (isOpen) {
        [vc.controller cameraAntiShakeMode:AVCaptureVideoStabilizationModeStandard];
    }else{
        [vc.controller cameraAntiShakeMode:AVCaptureVideoStabilizationModeOff];
    }

}

- (BOOL)getShakeMode{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    BOOL isSabilizationMode = [vc.controller isSabilizationMode];
    if (isSabilizationMode) {
        self.cameraModel.shakeIndex = 1;
    }else{
        self.cameraModel.shakeIndex = 0;
    }
    return isSabilizationMode;
}

//设置变焦速度

- (void)setZoomSpeedWithIndex:(NSInteger)index{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    vc.speedMode = index;
}

- (AVCapture_ZoomSpeedMode)getZoomSpeedMode{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    self.cameraModel.speed_indx = vc.speedMode;
    NSArray *speed = @[@"快",@"中",@"慢"];
    self.cameraModel.speed = speed[self.cameraModel.speed_indx];
    return vc.speedMode;
}



//@property (nonatomic,assign) NSInteger cameraModel;//相机手动模式
//@property (nonatomic,assign) NSInteger shakeIndex;//相机防抖动

@end
