//
//  BottomParametersView.m
//  YGCamera
//
//  Created by chen hua on 2019/7/27.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "BottomParametersView.h"
#import "PreviewVC.h"
#import "LZDividingRulerView.h"

@interface BottomParametersView (){
    
    NSInteger selectIndex;
}

@property (weak, nonatomic) IBOutlet UIView *topView;

@end

@implementation BottomParametersView

- (void)setBackColorWithShowParametersView:(BOOL)showParametersView{
    
    if (showParametersView) {
        self.collectionView.backgroundColor = [UIColor whiteColor];
        self.collectionView.alpha = 0.8;
    }else{
        self.collectionView.backgroundColor = [UIColor clearColor];
    }
}

#pragma makr -- Delegate/DataSource

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kwidth = collectionView.bounds.size.width/6;
    return CGSizeMake(kwidth, collectionView.bounds.size.height);
}

////cell的间距

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

//cell的纵向距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6 ;
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PreviewBottomCell *cell = (PreviewBottomCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"PreviewBottomCell" forIndexPath:indexPath];
    NSInteger index = indexPath.row;
    cell.backgroundColor = [UIColor clearColor];
    PreviewVC *vc = (PreviewVC *)[self getCurrentViewController];
    if ([vc.view viewWithTag:1000]) {
        cell.showPArametersView = YES;
        
        if (selectIndex == indexPath.row) {
            [cell setMiddleTextColor];
        }else{
            [cell setCellTextColor];
        }
        
    }else{
        cell.showPArametersView= NO;
        [cell setCellTextColor];
    }
    // WT变焦，MF对焦
    if (index == 0) {
        
        cell.parameterDetailLab.text = [NSString stringWithFormat:@"EV %.1f",vc.controller.getDeviceEV];
    }else if (index == 1){
        
        cell.parameterDetailLab.text = [NSString stringWithFormat:@"SEC 1/%d", (int)(vc.controller.getDeviceSEC)];
    }else if (index == 2){
        
        cell.parameterDetailLab.text = [NSString stringWithFormat:@"ISO %d",(int)vc.controller.getDeviceISO];
    }else if (index == 3){
        
        cell.parameterDetailLab.text = [NSString stringWithFormat:@"WB %d",(int)vc.controller.getWhiteBalanceTemparature];   //vc.controller.getDeviceWB
        
        //NSLog(@"maxWhiteBalanceGain =%f",[vc.controller activeDevice].maxWhiteBalanceGain);
    }else if (index == 4){
        
        cell.parameterDetailLab.text = [NSString stringWithFormat:@"MF %.1f",vc.controller.getDeviceFocus];
    }else if (index == 5){
        
        cell.parameterDetailLab.text = [NSString stringWithFormat:@"WT %.1f",vc.controller.getDeviceZoom];
    }
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PreviewVC *vc = (PreviewVC *)[self getCurrentViewController];
    [[vc.view viewWithTag:1000] removeFromSuperview];
    [[vc.view viewWithTag:1001] removeFromSuperview];
    selectIndex = indexPath.row;
    [self.collectionView reloadData];
    [self setBackColorWithShowParametersView:YES];
    if (indexPath.row == 0) {
        //EV
        [self setupEVRuler];
    }else if (indexPath.row == 1){
        //SEC
        [self setupSECRuler];
    }else if (indexPath.row == 2){
        //ISO
        [self setISORuler];
    }else if (indexPath.row == 3){
        //WB
        [self setWBRuler];
    }else if (indexPath.row == 4){
        //MF
        [self setMFRuler];
    }else if (indexPath.row == 5){
        //WT
        [self setWTRuler];
    }
    
}

- (UIViewController *)getCurrentViewController{
    UIResponder *next = [self nextResponder];
    do {if ([next isKindOfClass:[UIViewController class]]) {
        return (UIViewController *)next;
    }
        next = [next nextResponder];
    } while (next !=nil);
    return nil;
}

- (void)dismissClick{
    
    PreviewVC *vc = (PreviewVC *)[self getCurrentViewController];
    [[vc.view viewWithTag:1000] removeFromSuperview];
    [[vc.view viewWithTag:1001] removeFromSuperview];
    [self setBackColorWithShowParametersView:NO];
    [self.collectionView reloadData];
}


-(void)setupEVRuler{
    PreviewVC *vc = (PreviewVC *)[self getCurrentViewController];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissClick)];
    [backView addGestureRecognizer:tap];
    
    // 变速区域
    LZDividingRulerView * rulerView = [[LZDividingRulerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 51)];
    //是否自定义刻度
    rulerView.isCustomScalesValue = YES;
    //刻度文案每 5 个刻度格 显示一个文案
    rulerView.scalesCountBetweenScaleText = 5;
    rulerView.isShowCurrentValue = YES;
    CGFloat maxValue = [vc.controller activeDevice].maxExposureTargetBias;
    //最小值
    CGFloat minValue = [vc.controller activeDevice].minExposureTargetBias;
    //单元值
    CGFloat unitValue = 0.1;
    rulerView.defaultScale = (vc.controller.getDeviceEV -  minValue) *5 *10;
    NSInteger totalCount = (int)(maxValue -  minValue)/unitValue;
    NSMutableArray *titleArray = [NSMutableArray array];
    for (int i = 0; i <= totalCount; i++) {
        NSString *str = [NSString stringWithFormat:@"%.1f",minValue + unitValue * i];
        [titleArray addObject:str];
    }
    rulerView.customScalesCount = (titleArray.count -1) *5;
    [rulerView setCustomScaleTextFormatBlock:^NSString *(CGFloat currentCalibrationIndex) {
        //NSLog(@"currentCalibrationIndex == %f",currentCalibrationIndex);
        //return [NSString stringWithFormat:@"%@",titleArray[(int)currentCalibrationIndex/5]];
        return [NSString stringWithFormat:@"%@",titleArray[(int)currentCalibrationIndex/5]];
    }];
    [rulerView setDividingRulerCustomScaleDidEndScrollingBlock:^NSString *(CGFloat index) {
        
        //NSLog(@"index ====%f",index);
        return nil;
    }];
    [rulerView setDividingRulerCustomScaleDidScrollBlock:^NSString *(double index) {
        return nil;
    }];
    __weak PreviewVC *weakSelf =  vc;
    [rulerView setDividingRulerValuegBlock:^(CGFloat value) {
        
        [weakSelf.controller cameraBackgroundDidChangeEV:value/5 * unitValue + minValue];
    }];
    [rulerView setFrame:CGRectMake(0, 0, MAX(self.frame.size.width, self.frame.size.height), 51)];
    [rulerView updateRuler];
    rulerView.tag = 1000;
    [vc.view addSubview:backView];
    backView.tag = 1001;
    [vc.view insertSubview:self aboveSubview:backView];
    //    [vc.view addSubview:rulerView];
    [self.topView addSubview:rulerView];
}

-(void)setupSECRuler{
    
    //cell.parameterDetailLab.text = [NSString stringWithFormat:@"SEC 1/%d", (int)(1.0/vc.controller.getDeviceSEC)];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissClick)];
    [backView addGestureRecognizer:tap];
    PreviewVC *vc = (PreviewVC *)[self getCurrentViewController];
    // 变速区域
    LZDividingRulerView * rulerView = [[LZDividingRulerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 51)];
    //是否自定义刻度
    rulerView.isCustomScalesValue = YES;
    //刻度文案每 5 个刻度格 显示一个文案
    rulerView.scalesCountBetweenScaleText = 5;
    rulerView.isShowCurrentValue = YES;
    ////    CGFloat maxValue = [vc.controller activeDevice].activeFormat.minExposureDuration.timescale/[vc.controller activeDevice].activeFormat.minExposureDuration.value;
    //    //最小值
    //    CGFloat minValue = [vc.controller activeDevice].activeFormat.maxExposureDuration.timescale/[vc.controller activeDevice].activeFormat.maxExposureDuration.value;
    //单元值
    //    CGFloat unitValue = 100;
    //
    //
    //   // rulerView.defaultScale = (vc.controller.getDeviceSEC -  minValue) *5 /100;
    ////    NSInteger totalCount = (int)(maxValue -  minValue)/unitValue;
    //    NSInteger totalCount = 50;
    NSArray *titleArray ;
    titleArray = @[@"1/30",@"1/50",@"1/100",@"1/200",@"1/500",@"1/1000",@"1/1500"];
    NSArray *countArry = @[@"30",@"50",@"100",@"200",@"500",@"1000",@"1500"];
    //  NSArray *countArry = @[@"1",@"1.5",@"2",@"2.5",@"3",@"3.5",@"4"];
    NSString *str = [NSString stringWithFormat:@"1/%d",(int)vc.controller.getDeviceSEC ];
    if ([titleArray containsObject:str]) {
        NSInteger index = [titleArray indexOfObject:str];
        rulerView.defaultScale = (titleArray.count -1) *5 - index *5 ;
    }
    
    //    for (int i = 0; i <= totalCount; i++) {
    //        NSString *str = [NSString stringWithFormat:@"1/%d",(int)(minValue + unitValue * i)];
    //        [titleArray addObject:str];
    //    }
    rulerView.customScalesCount = (titleArray.count -1) *5;
    [rulerView setCustomScaleTextFormatBlock:^NSString *(CGFloat currentCalibrationIndex) {
        
        //NSLog(@"currentCalibrationIndex == %f",currentCalibrationIndex);
        //return [NSString stringWithFormat:@"%@",titleArray[(int)currentCalibrationIndex/5]];
        return [NSString stringWithFormat:@"%@",titleArray[ titleArray.count-1 - (int)currentCalibrationIndex/5]];
    }];
    [rulerView setDividingRulerCustomScaleDidEndScrollingBlock:^NSString *(CGFloat index) {
        //NSLog(@"index ====%f",index);
        return nil;
    }];
    [rulerView setDividingRulerCustomScaleDidScrollBlock:^NSString *(double index) {
        return nil;
    }];
    __weak PreviewVC *weakSelf =  vc;
    [rulerView setDividingRulerValuegBlock:^(CGFloat value) {
        
        int index = value/5;
        CGFloat  shutter= [countArry[ index] floatValue];
        // countArry countArry.count -1 -
        NSLog(@"shutter=========%f",shutter);
        [weakSelf.controller cameraBackgroundDidChangeShutter_interval:shutter];
        //        [weakSelf.controller cameraBackgroundDidChangeShutter_interval:value/5 * unitValue + minValue];
    }];
    [rulerView setFrame:CGRectMake(0, 0, MAX(self.frame.size.width, self.frame.size.height), 51)];
    [rulerView updateRuler];
    rulerView.tag = 1000;
    [vc.view addSubview:backView];
    backView.tag = 1001;
    [vc.view insertSubview:self aboveSubview:backView];
    //    [vc.view addSubview:rulerView];
    [self.topView addSubview:rulerView];
}

- (void)setISORuler{
    
    PreviewVC *vc = (PreviewVC *)[self getCurrentViewController];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissClick)];
    [backView addGestureRecognizer:tap];
    // 变速区域
    LZDividingRulerView * rulerView = [[LZDividingRulerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 51)];
    //是否自定义刻度
    rulerView.isCustomScalesValue = YES;
    //刻度文案每 5 个刻度格 显示一个文案x
    rulerView.scalesCountBetweenScaleText = 5;
    rulerView.isShowCurrentValue = YES;
    CGFloat maxValue = [vc.controller activeDevice].activeFormat.maxISO;
    //最小值
    CGFloat minValue = [vc.controller activeDevice].activeFormat.minISO;
    //单元值
    CGFloat unitValue = 1;
    //    rulerView.defaultScale = (vc.controller.getDeviceISO -  minValue) *5 *10;
    //    rulerView.defaultScale = (vc.controller.getDeviceISO - minValue) *5 ;
    rulerView.defaultScale = (vc.controller.getDeviceISO - minValue) *5 ;
    NSInteger totalCount = (int)(maxValue -  minValue)/unitValue;
    NSMutableArray *titleArray = [NSMutableArray array];
    for (int i = 0; i <= totalCount; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",(int)(minValue + unitValue * i)];
        [titleArray addObject:str];
    }
    rulerView.customScalesCount = (titleArray.count -1) *5;
    [rulerView setCustomScaleTextFormatBlock:^NSString *(CGFloat currentCalibrationIndex) {
        //NSLog(@"currentCalibrationIndex == %f",currentCalibrationIndex);
        //return [NSString stringWithFormat:@"%@",titleArray[(int)currentCalibrationIndex/5]];
        return [NSString stringWithFormat:@"%@",titleArray[(int)currentCalibrationIndex/5]];
    }];
    [rulerView setDividingRulerCustomScaleDidEndScrollingBlock:^NSString *(CGFloat index) {
        //NSLog(@"index ====%f",index);
        return nil;
    }];
    [rulerView setDividingRulerCustomScaleDidScrollBlock:^NSString *(double index) {
        return nil;
    }];
    __weak PreviewVC *weakSelf =  vc;
    [rulerView setDividingRulerValuegBlock:^(CGFloat value) {
        
        //NSLog(@"value ====%f",value/5);
        //        [weakSelf.controller cameraBackgroundDidChangeISO:value/5 * unitValue + minValue];
        [weakSelf.controller cameraBackgroundDidChangeISO:value/5 * unitValue + minValue];
    }];
    [rulerView setFrame:CGRectMake(0, 0, MAX(self.frame.size.width, self.frame.size.height), 51)];
    [rulerView updateRuler];
    rulerView.tag = 1000;
    [vc.view addSubview:backView];
    backView.tag = 1001;
    [vc.view insertSubview:self aboveSubview:backView];
    //    [vc.view addSubview:rulerView];
    [self.topView addSubview:rulerView];
}


- (void)setWBRuler{
    
    PreviewVC *vc = (PreviewVC *)[self getCurrentViewController];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissClick)];
    [backView addGestureRecognizer:tap];
    // 变速区域
    LZDividingRulerView * rulerView = [[LZDividingRulerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 51)];
    //是否自定义刻度
    rulerView.isCustomScalesValue = YES;
    //刻度文案每 5 个刻度格 显示一个文案x
    rulerView.scalesCountBetweenScaleText = 5;
    rulerView.isShowCurrentValue = YES;
    CGFloat maxValue = 130;
    //最小值
    CGFloat minValue = -150;
    //单元值
    CGFloat unitValue = 1;
    //NSLog(@"maxWhiteBalanceGain == %f",[vc.controller activeDevice].maxWhiteBalanceGain);
    rulerView.defaultScale = (vc.controller.getWhiteBalanceTemparature - minValue)   *5/unitValue;
    NSInteger totalCount = (int)(maxValue -  minValue)/unitValue;
    NSMutableArray *titleArray = [NSMutableArray array];
    for (int i = 0; i <= totalCount; i++) {
        NSString *str = [NSString stringWithFormat:@"%d",(int)(minValue + unitValue * i)];
        [titleArray addObject:str];
    }
    rulerView.customScalesCount = (titleArray.count -1) *5;
    [rulerView setCustomScaleTextFormatBlock:^NSString *(CGFloat currentCalibrationIndex) {
        
        return [NSString stringWithFormat:@"%@",titleArray[(int)currentCalibrationIndex/5]];
    }];
    [rulerView setDividingRulerCustomScaleDidEndScrollingBlock:^NSString *(CGFloat index) {
        
        //NSLog(@"index ====%f",index);
        return nil;
    }];
    [rulerView setDividingRulerCustomScaleDidScrollBlock:^NSString *(double index) {
        return nil;
    }];
    __weak PreviewVC *weakSelf =  vc;
    [rulerView setDividingRulerValuegBlock:^(CGFloat value) {
        
        //NSLog(@"value ====%f",value/5);  value/5 * unitValue + minValue
        //[weakSelf.controller cameraBackgroundDidChangeISO:value/5 * unitValue + minValue];
        [weakSelf.controller setWhiteBalanceTemperature:value/5 * unitValue + minValue];
        weakSelf.whiteBalance_mode =  AVCapture_WhiteBalance_Mode_Auto;
    }];
    [rulerView setFrame:CGRectMake(0, 0, MAX(self.frame.size.width, self.frame.size.height), 51)];
    [rulerView updateRuler];
    rulerView.tag = 1000;
    [vc.view addSubview:backView];
    backView.tag = 1001;
    [vc.view insertSubview:self aboveSubview:backView];
    //    [vc.view addSubview:rulerView];
    [self.topView addSubview:rulerView];
}


- (void)setMFRuler{
    
    PreviewVC *vc = (PreviewVC *)[self getCurrentViewController];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissClick)];
    [backView addGestureRecognizer:tap];
    // 变速区域
    LZDividingRulerView * rulerView = [[LZDividingRulerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 51)];
    //是否自定义刻度
    rulerView.isCustomScalesValue = YES;
    //刻度文案每 5 个刻度格 显示一个文案x
    rulerView.scalesCountBetweenScaleText = 5;
    rulerView.isShowCurrentValue = YES;
    //  vc.controller.getDeviceFocus
    CGFloat maxValue = 1;
    //最小值
    CGFloat minValue = 0;
    //单元值
    CGFloat unitValue = 0.1;
    
    rulerView.defaultScale = ([vc.controller getDeviceFocus] - minValue)   *5/unitValue;
    NSInteger totalCount = (int)(maxValue -  minValue)/unitValue;
    NSMutableArray *titleArray = [NSMutableArray array];
    for (int i = 0; i <= totalCount; i++) {
        NSString *str = [NSString stringWithFormat:@"%.1f",(minValue + unitValue * i)];
        [titleArray addObject:str];
    }
    rulerView.customScalesCount = (titleArray.count -1) *5;
    [rulerView setCustomScaleTextFormatBlock:^NSString *(CGFloat currentCalibrationIndex) {
        
        return [NSString stringWithFormat:@"%@",titleArray[(int)currentCalibrationIndex/5]];
    }];
    [rulerView setDividingRulerCustomScaleDidEndScrollingBlock:^NSString *(CGFloat index) {
        
        //NSLog(@"index ====%f",index);
        return nil;
    }];
    [rulerView setDividingRulerCustomScaleDidScrollBlock:^NSString *(double index) {
        return nil;
    }];
    __weak PreviewVC *weakSelf =  vc;
    [rulerView setDividingRulerValuegBlock:^(CGFloat value) {
        
        //NSLog(@"value ====%f",value/5);  value/5 * unitValue + minValue
        //[weakSelf.controller cameraBackgroundDidChangeISO:value/5 * unitValue + minValue];
        
        [weakSelf.controller cameraBackgroundDidChangeFocus:value/5 * unitValue + minValue];
    }];
    [rulerView setFrame:CGRectMake(0, 0, MAX(self.frame.size.width, self.frame.size.height), 51)];
    [rulerView updateRuler];
    rulerView.tag = 1000;
    [vc.view addSubview:backView];
    backView.tag = 1001;
    [vc.view insertSubview:self aboveSubview:backView];
    //    [vc.view addSubview:rulerView];
    [self.topView addSubview:rulerView];
}

//[NSString stringWithFormat:@"WT %.f",vc.controller.getDeviceZoom];

- (void)setWTRuler{
    
    PreviewVC *vc = (PreviewVC *)[self getCurrentViewController];
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissClick)];
    [backView addGestureRecognizer:tap];
    // 变速区域
    LZDividingRulerView * rulerView = [[LZDividingRulerView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 51)];
    //是否自定义刻度
    rulerView.isCustomScalesValue = YES;
    //刻度文案每 5 个刻度格 显示一个文案x
    rulerView.scalesCountBetweenScaleText = 5;
    rulerView.isShowCurrentValue = YES;
    //  vc.controller.getDeviceFocus
    CGFloat maxValue = [vc.controller activeDevice].activeFormat.videoMaxZoomFactor;;
    //最小值
    CGFloat minValue = 1;
    //单元值
    CGFloat unitValue = 0.1;
    
    rulerView.defaultScale = ([vc.controller getDeviceZoom] - minValue)   *5/unitValue;
    NSInteger totalCount = (int)(maxValue -  minValue)/unitValue;
    NSMutableArray *titleArray = [NSMutableArray array];
    for (int i = 0; i <= totalCount; i++) {
        NSString *str = [NSString stringWithFormat:@"%.1f",(minValue + unitValue * i)];
        [titleArray addObject:str];
    }
    rulerView.customScalesCount = (titleArray.count -1) *5;
    [rulerView setCustomScaleTextFormatBlock:^NSString *(CGFloat currentCalibrationIndex) {
        
        return [NSString stringWithFormat:@"%@",titleArray[(int)currentCalibrationIndex/5]];
    }];
    [rulerView setDividingRulerCustomScaleDidEndScrollingBlock:^NSString *(CGFloat index) {
        
        //NSLog(@"index ====%f",index);
        return nil;
    }];
    [rulerView setDividingRulerCustomScaleDidScrollBlock:^NSString *(double index) {
        return nil;
    }];
    __weak PreviewVC *weakSelf =  vc;
    [rulerView setDividingRulerValuegBlock:^(CGFloat value) {
        
        //NSLog(@"value ====%f",value/5);  value/5 * unitValue + minValue
        //[weakSelf.controller cameraBackgroundDidChangeISO:value/5 * unitValue + minValue];
        
        [weakSelf.controller cameraBackgroundDidChangeZoom:value/5 * unitValue + minValue];
        [weakSelf.myslider setValue:value/5 * unitValue + minValue animated:YES];
        // weakSelf.myslider.value = value/5 * unitValue + minValue;
    }];
    [rulerView setFrame:CGRectMake(0, 0, MAX(self.frame.size.width, self.frame.size.height), 51)];
    [rulerView updateRuler];
    rulerView.tag = 1000;
    [vc.view addSubview:backView];
    backView.tag = 1001;
    [vc.view insertSubview:self aboveSubview:backView];
    //    [vc.view addSubview:rulerView];
    [self.topView addSubview:rulerView];
}

@end
