//
//  ACCameraSetPreViewViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/27.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#define BOTTOM_ITEAM_COUNT  6

#define TOP_VIEW_HEIGHT 60
#define BOTTOM_VIEW_HEIGHT 80
#define VIEW_WIDTH   (MIN(KMainScreenWidth, KMainScreenHeight)*0.85)

#import "ACCameraSetPreViewViewController.h"
#include "ACCameraSetDetailCollectionViewCell.h"
#import "constants.h"
#import "ACCameraDetailsCollectionViewCell.h"
#import "PreviewVC.h"

@interface ACCameraSetPreViewViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout> {
    
    //最上层的默认、点击、title
    NSArray *topViewArr_nor;
    NSArray *topViewArr_sel;
    NSArray *topViewArr_title;
    
    //第一个
    NSArray *cameraArr_nor;
    NSArray *cameraArr_sel;
    NSArray *cameraArr_title;
    
    //第二个
    NSArray *filterArr_nor;
    NSArray *filterArr_sel;
    NSArray *filterArr_title;
    
    //第三个
    NSArray *timerArr_nor;
    NSArray *timerArr_sel;
    NSArray *timerArr_title;
    
    //第四个
    NSArray *hdrArr_nor;
    NSArray *hdrArr_sel;
    NSArray *hdrArr_title;
    
    //第五个
    NSArray *lightArr_nor;
    NSArray *lightArr_sel;
    NSArray *lightArr_title;
    
    //第六个
    NSArray *modelArr_nor;
    NSArray *modelArr_sel;
    NSArray *modelArr_title;
    
    //最上面的collectionView
    UICollectionView *topCollectionView;//第一级
    //下面的View
//    UIView *bottomContainView;//第二级
    UICollectionView *cameraCollectionView;//
    UICollectionView *filterCollectionView;
    UICollectionView *timerCollectionView;
    UICollectionView *hdrCollectionView;
    UICollectionView *lightCollectionView;
    UICollectionView *modelCollectionView;
    
    UIView *topLineView;//一级栏中线
    
    NSInteger topNumber;//上
    NSInteger bottomNumber;//下
}


@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation ACCameraSetPreViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initDataSource];
    [self initSubView];
    [self initData];
    [self addNotification];
}


- (void)initDataSource {
    
    if (self.index == 1) {
        
        topViewArr_nor = @[@"camera_n",@"filter_n1",@"time_n",@"hdr_n",@"light_n"];
        topViewArr_sel = @[@"camera_sel",@"filter_sel",@"time_select",@"hdr_sel",@"light_sel"];
        topViewArr_title = @[@"拍摄",@"滤镜",@"拍照定时",@"HDR",@"白平衡"];
        
        cameraArr_nor = @[@"default_n",@"180_n",@"360_n"];
        cameraArr_sel = @[@"default_sel",@"180_sel",@"360_sel"];
        cameraArr_title = @[@"默认",@"180°全景",@"360°全景"];
        
        filterArr_nor = @[@"filter_1",@"filter_2",@"filter_3",@"filter_4",@"filter_5",@"filter_6",@"filter_7",@"filter_8",@"filter_9",@"filter_10"];
        filterArr_sel = @[@"filter_1",@"filter_2",@"filter_3",@"filter_4",@"filter_5",@"filter_6",@"filter_7",@"filter_8",@"filter_9",@"filter_10"];
        filterArr_title = @[@"原图",@"素描",@"晕影",@"怀旧",@"负片",@"黑白",@"布鲁克林",@"移轴",@"柔美",@"旧时光"];
        
        timerArr_nor = @[@"time_close",@"time_n",@"time_n",@"time_n"];
        timerArr_sel = @[@"time_close",@"time_select",@"time_select",@"time_select"];
        timerArr_title = @[@"关闭",@"3s",@"5s",@"10s"];
        
        hdrArr_nor = @[@"hdr_b_n",@"hdr_b_n"];
        hdrArr_sel = @[@"hdr_b_se",@"hdr_b_se"];
        hdrArr_title = @[@"开启",@"f关闭"];
        
        lightArr_nor = @[@"auto_n",@"sunny_n",@"cloudly_n",@"light_b_n",@"white_light_n"];
        lightArr_sel = @[@"auto_se",@"sunny_n",@"cloudly_sel",@"light_b_sel",@"white_light_sel"];
        lightArr_title = @[@"自动",@"晴天",@"阴天",@"荧光灯",@"白炽灯"];
        
        modelArr_nor = @[@"add_n",@"run_n",@"walk_n"];
        modelArr_sel = @[@"add_sel",@"run_sel",@"walk_sel"];
        modelArr_title = @[@"自定义",@"运动模式",@"行走模式"];

        
    }else{
        
        topViewArr_nor = @[@"camera_n",@"filter_n1",@"time_n",@"hdr_n",@"light_n",@"model_n"];
        topViewArr_sel = @[@"camera_sel",@"filter_sel",@"time_select",@"hdr_sel",@"light_sel",@"model_sel"];
        topViewArr_title = @[@"拍摄",@"滤镜",@"拍照定时",@"HDR",@"白平衡",@"情景模式"];
        
        cameraArr_nor = @[@"default_n",@"active_n",@"move_n",@"static_n",@"area_n"];
        cameraArr_sel = @[@"default_sel",@"active_sel",@"move_sel",@"static_sel",@"area_sel"];
        cameraArr_title = @[@"默认",@"慢动作",@"移动延时",@"静态延时",@"希区柯克"];
        
        filterArr_nor = @[@"filter_1",@"filter_2",@"filter_3",@"filter_4",@"filter_5",@"filter_6",@"filter_7",@"filter_8",@"filter_9",@"filter_10"];
        filterArr_sel = @[@"filter_1",@"filter_2",@"filter_3",@"filter_4",@"filter_5",@"filter_6",@"filter_7",@"filter_8",@"filter_9",@"filter_10"];
        filterArr_title = @[@"原图",@"素描",@"晕影",@"怀旧",@"负片",@"黑白",@"布鲁克林",@"移轴",@"柔美",@"旧时光"];
        
        timerArr_nor = @[@"time_close",@"time_n",@"time_n",@"time_n"];
        timerArr_sel = @[@"time_close",@"time_select",@"time_select",@"time_select"];
        timerArr_title = @[@"关闭",@"3s",@"5s",@"10s"];
        
        hdrArr_nor = @[@"hdr_b_n",@"hdr_b_n"];
        hdrArr_sel = @[@"hdr_b_se",@"hdr_b_se"];
        hdrArr_title = @[@"开启",@"f关闭"];
        
        lightArr_nor = @[@"auto_n",@"sunny_n",@"cloudly_n",@"light_b_n",@"white_light_n"];
        lightArr_sel = @[@"auto_se",@"sunny_n",@"cloudly_sel",@"light_b_sel",@"white_light_sel"];
        lightArr_title = @[@"自动",@"晴天",@"阴天",@"荧光灯",@"白炽灯"];
        
        modelArr_nor = @[@"add_n",@"run_n",@"walk_n"];
        modelArr_sel = @[@"add_sel",@"run_sel",@"walk_sel"];
        modelArr_title = @[@"自定义",@"运动模式",@"行走模式"];//0 步行模式  1 运动模式  2 自定义模式
    }
    
}

- (NSInteger)getMaxIndexWithTopIndex:(NSInteger)topIndex{
    
    if (self.index == 1) {
        //照片
        if (topIndex == 0) {
            return cameraArr_title.count;
        }else if (topIndex == 1){
            return filterArr_title.count;
        }else if (topIndex == 2){
            return timerArr_title.count;
        }else if (topIndex == 3){
            return hdrArr_title.count;
        }else if (topIndex == 4){
            return lightArr_title.count;
        }
        return 0;
    }else{
        
        //视频
        if (topIndex == 0) {
            return cameraArr_title.count;
        }else if (topIndex == 1){
            return filterArr_title.count;
        }else if (topIndex == 2){
            return timerArr_title.count;
        }else if (topIndex == 3){
            return hdrArr_title.count;
        }else if (topIndex == 4){
            return lightArr_title.count;
        }else if (topIndex == 5){
            return modelArr_title.count;
        }
        return 0;
    }
}

- (void)initSubView {
    
    self.bottomView.clipsToBounds = YES;
    //第一个
    UICollectionViewFlowLayout *flowLayout_1 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout_1.itemSize = CGSizeMake(VIEW_WIDTH / BOTTOM_ITEAM_COUNT, BOTTOM_VIEW_HEIGHT);
    flowLayout_1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout_1.minimumLineSpacing = 0;
    cameraCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, BOTTOM_VIEW_HEIGHT) collectionViewLayout:flowLayout_1];
    cameraCollectionView.backgroundColor = [UIColor whiteColor];
    cameraCollectionView.delegate = self;
    cameraCollectionView.dataSource = self;
    UIView *bottom_1 = [[UIView alloc] initWithFrame:CGRectMake(0, -(BOTTOM_VIEW_HEIGHT+1), VIEW_WIDTH, BOTTOM_VIEW_HEIGHT)];
    [bottom_1 addSubview:cameraCollectionView];
    [self.bottomView addSubview:bottom_1];
    //cell register
    [cameraCollectionView registerNib:[UINib nibWithNibName:@"ACCameraDetailsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cameraCell"];
    //第二个
    UICollectionViewFlowLayout *flowLayout_2 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout_2.itemSize = CGSizeMake(VIEW_WIDTH / filterArr_nor.count, BOTTOM_VIEW_HEIGHT);
    flowLayout_2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout_2.minimumLineSpacing = 0;
    filterCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, BOTTOM_VIEW_HEIGHT) collectionViewLayout:flowLayout_2];
    filterCollectionView.backgroundColor = [UIColor whiteColor];
    filterCollectionView.delegate = self;
    filterCollectionView.dataSource = self;
    UIView *bottom_2 = [[UIView alloc] initWithFrame:CGRectMake(0, -(BOTTOM_VIEW_HEIGHT+1), VIEW_WIDTH, BOTTOM_VIEW_HEIGHT)];
    [bottom_2 addSubview:filterCollectionView];
    [self.bottomView addSubview:bottom_2];
    //cell register
    [filterCollectionView registerNib:[UINib nibWithNibName:@"ACCameraDetailsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"fillterCell"];
    
    //第三个
    UICollectionViewFlowLayout *flowLayout_3 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout_3.itemSize = CGSizeMake(VIEW_WIDTH / BOTTOM_ITEAM_COUNT, BOTTOM_VIEW_HEIGHT);
    flowLayout_3.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout_3.minimumLineSpacing = 0;
    
    timerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout_3];
    timerCollectionView.bounds = CGRectMake(0, 0, VIEW_WIDTH/BOTTOM_ITEAM_COUNT * [timerArr_nor count], BOTTOM_VIEW_HEIGHT);
    timerCollectionView.center = CGPointMake(VIEW_WIDTH/BOTTOM_ITEAM_COUNT * 2.5, BOTTOM_VIEW_HEIGHT/2);
    timerCollectionView.backgroundColor = [UIColor whiteColor];
    timerCollectionView.delegate = self;
    timerCollectionView.dataSource = self;
    
    UIView *bottom_3 = [[UIView alloc] initWithFrame:CGRectMake(0, -(BOTTOM_VIEW_HEIGHT+1), VIEW_WIDTH, BOTTOM_VIEW_HEIGHT)];
    [bottom_3 addSubview:timerCollectionView];
    [self.bottomView addSubview:bottom_3];
    
    //cell register
    [timerCollectionView registerNib:[UINib nibWithNibName:@"ACCameraDetailsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"timerCell"];
    
    //第四个
    UICollectionViewFlowLayout *flowLayout_4 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout_4.itemSize = CGSizeMake(VIEW_WIDTH / BOTTOM_ITEAM_COUNT, BOTTOM_VIEW_HEIGHT);
    flowLayout_4.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout_4.minimumLineSpacing = 0;
    
    hdrCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout_4];
    hdrCollectionView.bounds = CGRectMake(0, 0, VIEW_WIDTH/BOTTOM_ITEAM_COUNT * [hdrArr_nor count], BOTTOM_VIEW_HEIGHT);
    hdrCollectionView.center = CGPointMake(VIEW_WIDTH/BOTTOM_ITEAM_COUNT * 3.5, BOTTOM_VIEW_HEIGHT/2);
    hdrCollectionView.backgroundColor = [UIColor whiteColor];
    hdrCollectionView.delegate = self;
    hdrCollectionView.dataSource = self;
    
    UIView *bottom_4 = [[UIView alloc] initWithFrame:CGRectMake(0, -(BOTTOM_VIEW_HEIGHT+1), VIEW_WIDTH, BOTTOM_VIEW_HEIGHT)];
    [bottom_4 addSubview:hdrCollectionView];
    [self.bottomView addSubview:bottom_4];
    
    //cell register
    [hdrCollectionView registerNib:[UINib nibWithNibName:@"ACCameraDetailsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"hdrCell"];
    
    //第五个
    UICollectionViewFlowLayout *flowLayout_5 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout_5.itemSize = CGSizeMake(VIEW_WIDTH / BOTTOM_ITEAM_COUNT, BOTTOM_VIEW_HEIGHT);
    flowLayout_5.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout_5.minimumLineSpacing = 0;
    
    lightCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout_5];
    lightCollectionView.backgroundColor = [UIColor whiteColor];
    lightCollectionView.frame = CGRectMake(VIEW_WIDTH / BOTTOM_ITEAM_COUNT, 0, VIEW_WIDTH / BOTTOM_ITEAM_COUNT * [lightArr_nor count], BOTTOM_VIEW_HEIGHT);
    lightCollectionView.delegate = self;
    lightCollectionView.dataSource = self;
    
    UIView *bottom_5 = [[UIView alloc] initWithFrame:CGRectMake(0, -(BOTTOM_VIEW_HEIGHT+1), VIEW_WIDTH, BOTTOM_VIEW_HEIGHT)];
    [bottom_5 addSubview:lightCollectionView];
    [self.bottomView addSubview:bottom_5];
    
    //cell register
    [lightCollectionView registerNib:[UINib nibWithNibName:@"ACCameraDetailsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"lightCell"];
    
    //第六个
    UICollectionViewFlowLayout *flowLayout_6 = [[UICollectionViewFlowLayout alloc] init];
    flowLayout_6.itemSize = CGSizeMake(VIEW_WIDTH / BOTTOM_ITEAM_COUNT, BOTTOM_VIEW_HEIGHT);
    flowLayout_6.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout_6.minimumLineSpacing = 0;
    
    modelCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout_6];
    modelCollectionView.backgroundColor = [UIColor whiteColor];
    modelCollectionView.frame = CGRectMake(VIEW_WIDTH / BOTTOM_ITEAM_COUNT * 3, 0, VIEW_WIDTH / BOTTOM_ITEAM_COUNT * [modelArr_nor count], BOTTOM_VIEW_HEIGHT);
    modelCollectionView.delegate = self;
    modelCollectionView.dataSource = self;
    
    UIView *bottom_6 = [[UIView alloc] initWithFrame:CGRectMake(0, -(BOTTOM_VIEW_HEIGHT+1), VIEW_WIDTH, BOTTOM_VIEW_HEIGHT)];
    [bottom_6 addSubview:modelCollectionView];
    [self.bottomView addSubview:bottom_6];

    //cell register
    [modelCollectionView registerNib:[UINib nibWithNibName:@"ACCameraDetailsCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"modelCell"];
    
    CGFloat scale = 1.0/[UIScreen mainScreen].scale;
    CGFloat space = scale;
    
    //实际屏幕宽度计算的cell宽度
    CGFloat orignalItemWidth = (VIEW_WIDTH - ([topViewArr_nor count] - 1)*space)/[topViewArr_nor count];
    //根据屏幕锁房率计算出cell宽度并进行调整
    CGFloat resultIteamWidth = floor(orignalItemWidth)+scale;
    
    if (resultIteamWidth < orignalItemWidth) {
        resultIteamWidth += scale;
    }
    
    //最上层view
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(resultIteamWidth, TOP_VIEW_HEIGHT);
    flowLayout.minimumLineSpacing = 0;
    
    topCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, TOP_VIEW_HEIGHT) collectionViewLayout:flowLayout];
    topCollectionView.backgroundColor = [UIColor whiteColor];
    topCollectionView.delegate = self;
    topCollectionView.dataSource = self;
    [self.topView addSubview:topCollectionView];
    
    //cell register
    [topCollectionView registerNib:[UINib nibWithNibName:@"ACCameraSetDetailCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"topCell"];
    
    topLineView = [[UIView alloc] initWithFrame:CGRectMake(10, TOP_VIEW_HEIGHT - 2, resultIteamWidth - 20, 2)];
    topLineView.backgroundColor = [UIColor colorWithRed:180/255.0 green:201/255.0 blue:91/255.0 alpha:1.0];
    [self.topView addSubview:topLineView];
    
//    NSLog(@"===> collection width = %f  width = %lf count = %ld",resultIteamWidth,VIEW_WIDTH/6,topViewArr_nor.count);
}

- (void)initData {
    
    self.setDetailModel = [[SetDetailModel alloc] init];
    self.setDetailModel.cameraModel = [[CameraModel alloc] init];
    self.setDetailModel.filterModel = [[FilterModel alloc] init];
    self.setDetailModel.timeModel = [[TimerModel alloc] init];
    self.setDetailModel.hdrModel = [[HDRModel alloc] init];
    self.setDetailModel.lightModel = [[LightModel alloc] init];
    self.setDetailModel.sportModel = [[SportModel alloc] init];
    
    self.setDetailModel.index = 0;
    self.setDetailModel.cameraModel.index = 0;
    self.setDetailModel.filterModel.index = 0;
    self.setDetailModel.timeModel.index = 0;
    self.setDetailModel.hdrModel.index = 0;
    self.setDetailModel.lightModel.index = 0;
    self.setDetailModel.sportModel.index = 0;
    
    topNumber = 0;
    bottomNumber = 0;
}


- (void)addNotification {
    
    //接收取消消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dimissPopView:) name:@"NSNotificationPopViewDismiss" object:nil];
}


#pragma mark --Method

- (void)scrollViewWithIndex:(NSInteger)index selectedModel:(SelectedModel *)selectedModel  {
    
    //line
    CGRect lineFrame = topLineView.frame;
    lineFrame.origin.x = index * (VIEW_WIDTH/[topViewArr_nor count]) + 10;
    [UIView animateWithDuration:0.15 animations:^{
        self->topLineView.frame = lineFrame;
    }];
    
    self.setDetailModel.index = index;
    //NSLog(@"index >>>>%ld",(long)index);
    [topCollectionView reloadData];
    
    //如果model=nil，默认为不弹出二级菜单
    if (selectedModel == nil) return;
    
    
    [self.bottomView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect animationFrame = obj.frame;
        
        if (index == idx) {
            *stop = YES;
            animationFrame.origin.y = 0;
        }
        
        [UIView animateWithDuration:0.15 animations:^{
            obj.frame = animationFrame;
        }];
    }];
    
    if (index == 0) {
        self.setDetailModel.cameraModel.index = selectedModel.bottomIndex;
        [self setCollectionView:cameraCollectionView row:selectedModel.bottomIndex];
       // [self collectionView:cameraCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathWithIndex:index]];
      //  [cameraCollectionView reloadData];
    }else if (index == 1){
        self.setDetailModel.filterModel.index = selectedModel.bottomIndex;
        [self setCollectionView:filterCollectionView row:selectedModel.bottomIndex];
        //[self collectionView:filterCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathWithIndex:index]];
       // [filterCollectionView reloadData];
    }else if (index == 2){
        self.setDetailModel.timeModel.index = selectedModel.bottomIndex;
        [self setCollectionView:timerCollectionView row:selectedModel.bottomIndex];
        //[self collectionView:timerCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathWithIndex:index]];
        //[timerCollectionView reloadData];
    }else if (index == 3){
        self.setDetailModel.hdrModel.index = selectedModel.bottomIndex;
        [self setCollectionView:hdrCollectionView row:selectedModel.bottomIndex];
        //[self collectionView:hdrCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathWithIndex:index]];
        //[hdrCollectionView reloadData];
    }else if (index == 4){
        self.setDetailModel.lightModel.index = selectedModel.bottomIndex;
        [self setCollectionView:lightCollectionView row:selectedModel.bottomIndex];
        //[self collectionView:lightCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathWithIndex:index]];
        //[lightCollectionView reloadData];
    }else if (index == 5){
        self.setDetailModel.sportModel.index = selectedModel.bottomIndex;
        [self setCollectionView:modelCollectionView row:selectedModel.bottomIndex];
        //[self collectionView:modelCollectionView didSelectItemAtIndexPath:[NSIndexPath indexPathWithIndex:index]];
        //[modelCollectionView reloadData];
    }
    
    
}

- (void)dimissPopView:(NSNotification *)notification {
    
    if ([notification.object isEqualToString:@"Remove_ALL"]) {
        if (_delegate && [_delegate respondsToSelector:@selector(setVCDismisWithController:)]) {
            [_delegate setVCDismisWithController:self];
        }
        return;
    }
    __block NSInteger flag  = -1;
    [self.bottomView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        CGRect animationFrame = obj.frame;
        if (animationFrame.origin.y == 0) {
            animationFrame.origin.y = - (BOTTOM_VIEW_HEIGHT+1);
            [UIView animateWithDuration:0.15 animations:^{
                obj.frame = animationFrame;
            }];
            
            flag = 1;//代表有二级
        }
        
        if (idx == [self.bottomView.subviews count] - 1) {
            if (flag != 1) {
                flag = 2;//代表取消整个VC
            }
        }
    }];
    if (flag == 2) {
        if (_delegate && [_delegate respondsToSelector:@selector(setVCDismisWithController:)]) {
            [_delegate setVCDismisWithController:self];
        }
    }
//    if (flag == 2) {
//        if (_delegate && [_delegate respondsToSelector:@selector(setVCDismisWithController:)]) {
//            [_delegate setVCDismisWithController:self];
//        }
//    }
    NSLog(@"receive message ========= flag = %ld",flag);
}

#pragma mark UICollection delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView == topCollectionView) {
        return topViewArr_nor.count;
    }
    
    if (collectionView == cameraCollectionView) {
        return cameraArr_nor.count;
    }
    
    if (collectionView == filterCollectionView) {
        return filterArr_nor.count;
    }
    
    if (collectionView == timerCollectionView) {
        return timerArr_nor.count;
    }
    
    if (collectionView == hdrCollectionView) {
        return hdrArr_nor.count;
    }
    
    if (collectionView == lightCollectionView) {
        return lightArr_nor.count;
    }
    
    if (collectionView == modelCollectionView) {
        return modelArr_nor.count;
    }
    
    return 0;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (collectionView == topCollectionView) {
        
        ACCameraSetDetailCollectionViewCell *topCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"topCell" forIndexPath:indexPath];
        [topCell setCellWithModel:self.setDetailModel defaultArr:topViewArr_nor select:topViewArr_sel titleArr:topViewArr_title index:indexPath];
        return topCell;
        
    }
    
    if (collectionView == cameraCollectionView) {
        
        //- (AVCapture_capturePhotoMode)getCurrentPhotoMode
         ACCameraDetailsCollectionViewCell *cameraCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cameraCell" forIndexPath:indexPath];
         PreviewVC *vc = (PreviewVC *)self.delegate;
        if (_index == 1) {
            self.setDetailModel.cameraModel.index = (int)[vc getCurrentPhotoMode];
        }else{
            self.setDetailModel.cameraModel.index = (int)[vc getCurrentVideoMode];
        }
        [cameraCell setCellWithData:self.setDetailModel defaultArr:cameraArr_nor selectedArr:cameraArr_sel titleArr:cameraArr_title item:0 index:indexPath];
        return cameraCell;
    }
    
    if (collectionView == filterCollectionView) {
        ACCameraDetailsCollectionViewCell *filterCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fillterCell" forIndexPath:indexPath];
//        filterCell.imageIcon.image = [UIImage imageNamed:filterArr_nor[indexPath.row]];
//        filterCell.titleLabel.text = filterArr_title[indexPath.row];
        PreviewVC *vc = (PreviewVC *)self.delegate;
        if (vc.filterMode == AVCapture_FilterMode_BeautyFilter) {
            vc.filterMode = AVCapture_FilterMode_NormalFilter;
        }
        self.setDetailModel.filterModel.index = vc.filterMode;
        [filterCell setCellWithData:self.setDetailModel defaultArr:filterArr_nor selectedArr:filterArr_sel titleArr:filterArr_title item:1 index:indexPath];
        return filterCell;
    }
    
    if (collectionView == timerCollectionView) {
        ACCameraDetailsCollectionViewCell *timerCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"timerCell" forIndexPath:indexPath];
//        timerCell.imageIcon.image = [UIImage imageNamed:timerArr_nor[indexPath.row]];
//        timerCell.titleLabel.text = timerArr_title[indexPath.row];
        PreviewVC *vc = (PreviewVC *)self.delegate;
        self.setDetailModel.timeModel.index = vc.timIndex;
        [timerCell setCellWithData:self.setDetailModel defaultArr:timerArr_nor selectedArr:timerArr_sel titleArr:timerArr_title item:2 index:indexPath];
        return timerCell;
    }
    
    if (collectionView == hdrCollectionView) {
        ACCameraDetailsCollectionViewCell *hdrCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hdrCell" forIndexPath:indexPath];
//        hdrCell.imageIcon.image = [UIImage imageNamed:hdrArr_nor[indexPath.row]];
//        hdrCell.titleLabel.text = hdrArr_title[indexPath.row];
        PreviewVC *vc = (PreviewVC *)self.delegate;
        self.setDetailModel.hdrModel.index = vc.controller.isHDROpen?0:1;
        [hdrCell setCellWithData:self.setDetailModel defaultArr:hdrArr_nor selectedArr:hdrArr_sel titleArr:hdrArr_title item:3 index:indexPath];
        return hdrCell;
    }
    
    if (collectionView == lightCollectionView) {
        ACCameraDetailsCollectionViewCell *lightCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"lightCell" forIndexPath:indexPath];
        PreviewVC *vc = (PreviewVC *)self.delegate;
        self.setDetailModel.lightModel.index = vc.whiteBalance_mode;
//        lightCell.imageIcon.image = [UIImage imageNamed:lightArr_nor[indexPath.row]];
//        lightCell.titleLabel.text = lightArr_title[indexPath.row];
        [lightCell setCellWithData:self.setDetailModel defaultArr:lightArr_nor selectedArr:lightArr_sel titleArr:lightArr_title item:4 index:indexPath];
        return lightCell;
    }
    
    if (collectionView == modelCollectionView) {
        ACCameraDetailsCollectionViewCell *modelCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"modelCell" forIndexPath:indexPath];
//        modelCell.imageIcon.image = [UIImage imageNamed:modelArr_nor[indexPath.row]];
//        modelCell.titleLabel.text = modelArr_title[indexPath.row];
        PreviewVC *vc = (PreviewVC *)self.delegate;
        self.setDetailModel.sportModel.index = 2-vc.screenMode;
        [modelCell setCellWithData:self.setDetailModel defaultArr:modelArr_nor selectedArr:modelArr_sel titleArr:modelArr_title item:5 index:indexPath];
        return modelCell;
    }
    
    
    return nil;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    
    if (collectionView == topCollectionView) {
        
        //line
        CGRect lineFrame = topLineView.frame;
        lineFrame.origin.x = indexPath.row * (VIEW_WIDTH/[topViewArr_nor count]) + 10;
        [UIView animateWithDuration:0.15 animations:^{
            self->topLineView.frame = lineFrame;
        }];
        self.setDetailModel.index = indexPath.row;
        [self.bottomView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGRect animationFrame = obj.frame;
            
            if (indexPath.row == idx) {
                animationFrame.origin.y == 0 ? (animationFrame.origin.y = -(BOTTOM_VIEW_HEIGHT+1)) : (animationFrame.origin.y = 0);
            }else{
                if (animationFrame.origin.y == 0) {
                    animationFrame.origin.y = -(BOTTOM_VIEW_HEIGHT+1);
                }
            }
            
            [UIView animateWithDuration:0.15 animations:^{
                obj.frame = animationFrame;
            }];
        }];
        
        [collectionView reloadData];
     //增加
    }else{
        
       
        if ((_index == 2 && ( (collectionView == cameraCollectionView && (indexPath.row == 0 || indexPath.row == 1)) || collectionView == filterCollectionView || collectionView == timerCollectionView || collectionView == hdrCollectionView ||collectionView == lightCollectionView ||collectionView == modelCollectionView))   || _index == 1) {
            //默认不消失
        }else{
            if ([self.delegate respondsToSelector:@selector(setVCDismisWithController:)]) {
                [self.delegate setVCDismisWithController:self];
            }
        }
    }
    
    if (collectionView == cameraCollectionView) {
        
        self.setDetailModel.cameraModel.index = indexPath.row;
        [self setCameraMode:indexPath.row];
        [collectionView reloadData];
        if (_index == 2) {
            if (indexPath.row >= 2) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CameraFunction_Notify" object:@(indexPath.row)];
            }
        }
//        @[@"默认",@"慢动作",@"移动延时",@"静态延时",@"希区柯克"];
    }
    
    if (collectionView == filterCollectionView) {
        
        self.setDetailModel.filterModel.index = indexPath.row;
        [self setFilterWithIndex:indexPath.row];
        [collectionView reloadData];
    }
    
    if (collectionView == timerCollectionView) {
        
        self.setDetailModel.timeModel.index = indexPath.row;
        [self setTimWithIndex:indexPath.row];
        [collectionView reloadData];
    }
    
    if (collectionView == hdrCollectionView) {
        self.setDetailModel.hdrModel.index = indexPath.row;
        [self setHDRWithIndex:indexPath.row];
        [collectionView reloadData];
    }
    
    if (collectionView == lightCollectionView) {
        self.setDetailModel.lightModel.index = indexPath.row;
        [self setWhiteBalance_modeWithIndex:indexPath.row];
        [collectionView reloadData];
    }
    
    if (collectionView == modelCollectionView) {
        
        self.setDetailModel.sportModel.index = indexPath.row;
        [self setScreenModeWithIndex:indexPath.row];
        [collectionView reloadData];
    }
    
}


- (void)setCollectionView:(UICollectionView *)collectionView  row:(NSInteger)row{
    
    if (collectionView == topCollectionView) {
        
        //line
        CGRect lineFrame = topLineView.frame;
        lineFrame.origin.x = row * (VIEW_WIDTH/[topViewArr_nor count]) + 10;
        [UIView animateWithDuration:0.15 animations:^{
            self->topLineView.frame = lineFrame;
        }];
        self.setDetailModel.index = row;
        [self.bottomView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            CGRect animationFrame = obj.frame;
            
            if (row == idx) {
                animationFrame.origin.y == 0 ? (animationFrame.origin.y = -(BOTTOM_VIEW_HEIGHT+1)) : (animationFrame.origin.y = 0);
            }else{
                if (animationFrame.origin.y == 0) {
                    animationFrame.origin.y = -(BOTTOM_VIEW_HEIGHT+1);
                }
            }
            
            [UIView animateWithDuration:0.15 animations:^{
                obj.frame = animationFrame;
            }];
        }];
        
        [collectionView reloadData];
        
    }
    
    if (collectionView == cameraCollectionView) {
        
        self.setDetailModel.cameraModel.index =row;
        [self setCameraMode:row];
        [collectionView reloadData];
        if (_index == 2) {
            if (row >= 2) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CameraFunction_Notify" object:@(row)];
            }
        }
        //        @[@"默认",@"慢动作",@"移动延时",@"静态延时",@"希区柯克"];
    }
    
    if (collectionView == filterCollectionView) {
        
        self.setDetailModel.filterModel.index = row;
        [self setFilterWithIndex:row];
        [collectionView reloadData];
    }
    
    if (collectionView == timerCollectionView) {
        
        self.setDetailModel.timeModel.index = row;
        [self setTimWithIndex:row];
        [collectionView reloadData];
    }
    
    if (collectionView == hdrCollectionView) {
        self.setDetailModel.hdrModel.index = row;
        [self setHDRWithIndex:row];
        [collectionView reloadData];
    }
    
    if (collectionView == lightCollectionView) {
        self.setDetailModel.lightModel.index = row;
        [self setWhiteBalance_modeWithIndex:row];
        [collectionView reloadData];
    }
    
    if (collectionView == modelCollectionView) {
        
        self.setDetailModel.sportModel.index = row;
        [self setScreenModeWithIndex:row];
        [collectionView reloadData];
    }
}


- (void)setCameraMode:(NSInteger)index{
    
     PreviewVC *vc = (PreviewVC *)self.delegate;
    if (_index == 1) {
        [vc setPhotoMode:(AVCapture_capturePhotoMode)(index)];
    }else{
        [vc setVideoMode:(AVCapture_videoMode)(index)];
    }
}

- (void)setFilterWithIndex:(NSInteger)index{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    [vc setFilterWithIndex:index];
    [vc.captureRightView showHDRView:vc.controller.isHDROpen timingImageHidden:(vc.timIndex == 0)?YES:NO timIndex:vc.timIndex];
}

- (void)setHDRWithIndex:(NSInteger)index{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    [vc.controller cameraBackgroundDidChangeHDR:index==0];
    [vc.captureRightView showHDRView:vc.controller.isHDROpen timingImageHidden:(vc.timIndex == 0)?YES:NO timIndex:vc.timIndex];
}

- (void)setWhiteBalance_modeWithIndex:(NSInteger)index{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    [vc.controller whiteBalanceMode:(AVCapture_WhiteBalance_Mode)index];
    vc.whiteBalance_mode = (AVCapture_WhiteBalance_Mode)index;
}

- (void)setTimWithIndex:(NSInteger)index{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    vc.timIndex = index;
    [vc.captureRightView showHDRView:vc.controller.isHDROpen timingImageHidden:(vc.timIndex == 0)?YES:NO timIndex:vc.timIndex];
}

- (void)setScreenModeWithIndex:(NSInteger)index{
    
    PreviewVC *vc = (PreviewVC *)self.delegate;
    [[BLEControlManager sharedInstance] sendDataToBLE:[BLESendData sendPlatform_SpeedMode:(BLE_Control_SpeedMode)(2-index)]];
    vc.screenMode = (AVCapture_ScreenMode)(2-index);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    return CGSizeZero;
}


#pragma mark 上一层模拟

- (IBAction)top:(UIButton *)sender {
    
    topNumber++;
    if (topNumber == 5) {
        topNumber = 0;
    }
    SelectedModel *selected = nil;
    [self scrollViewWithIndex:topNumber selectedModel:selected];

}

#pragma mark 下一层模拟

- (IBAction)bottom:(UIButton *)sender {

    SelectedModel *model = [[SelectedModel alloc] init];
    model.topIndex = topNumber;
    model.bottomIndex = bottomNumber;

    [self scrollViewWithIndex:topNumber selectedModel:model];

    bottomNumber++;

    if (topNumber == 0) {

        if (bottomNumber == cameraArr_nor.count) {
            bottomNumber = 0;
        }

    }else if (topNumber == 1){

        if (bottomNumber == filterArr_nor.count) {
            bottomNumber = 0;
        }

    }else if (topNumber == 2){
        if (bottomNumber == timerArr_nor.count) {
            bottomNumber = 0;
        }
    }else if (topNumber == 3){
        if (bottomNumber == hdrArr_nor.count) {
            bottomNumber = 0;
        }
    }else if (topNumber == 4){
        if (bottomNumber == lightArr_nor.count) {
            bottomNumber = 0;
        }
    }else if (topNumber == 5){
        if (bottomNumber == modelArr_nor.count) {
            bottomNumber = 0;
        }
    }

}

#pragma mark 模拟发送通知

- (IBAction)sender:(id)sender {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationPopViewDismiss" object:self];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"====> popView dealloc");
}


#pragma mark -判断二级菜单存在不存在
- (BOOL)isSecondMenuIsshow {
    
    __block BOOL isShow = NO;
    [self.bottomView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.frame.origin.y == 0) {
            *stop = YES;
            isShow = YES;
        }
    }];
    return isShow;
}

@end
