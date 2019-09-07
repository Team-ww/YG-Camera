//
//  ACEditorViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/29.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACEditorViewController.h"
#import "constants.h"
#import "Utils.h"
#import "ACEditorCollectionViewCell.h"
#import "SAVideoRangeSlider.h"
#import "DragView.h"

#define EDGE_EXTENSION_FOR_THUMB 30
@interface ACEditorViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIScrollViewDelegate> {
    
    NSMutableArray *dataSourceArr;
    
    UIView *bottomView;
    DragView *leftDragView;
    DragView *rightDragView;
    UIView *line;
    
    editorStartBlock _startBlock;
    editorEndBlock _endBlock;
    editorPlayBlock _playBlock;
    startBeginBlock _beginBlock;
    didEndBlock _didEndBlock;
    
    NSTimer *lineTimer;
    NSTimer *repeatTimer;
}

@property (nonatomic,strong)UICollectionView *mainCollection;

//@property (strong, nonatomic) SAVideoRangeSlider *slider;
@property (nonatomic,assign)CGPoint leftStartPoint;
@property (nonatomic,assign)CGPoint rightStartPoint;
@property (nonatomic,assign)BOOL isDraggingRightOverlayView;
@property (nonatomic,assign)BOOL isDraggingLeftOverlayView;
@property (nonatomic,assign)CGFloat startTime;//编辑框内视频开始时间秒
@property (nonatomic,assign)CGFloat endTime;//编辑框内视频结束时间秒
@property (nonatomic,assign)CGFloat startPointX;//编辑框起始点
@property (nonatomic,assign)CGFloat endPointX;//编辑框结束时间点
@property (nonatomic,assign)CGFloat img_width;//视频帧宽度
@property (nonatomic,assign)CGFloat linePositionX;//播放条位置
@property (nonatomic,assign)CGFloat touchPointX;//编辑视图区域外触点
@property (nonatomic,assign)CGFloat isEdited;//yes：编辑完成
@property (nonatomic, strong) NSTimer  *lineMoveTimer; // 播放条移动计时器


@end

@implementation ACEditorViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

//    [self.slider getMovieFrame:self.editorAsset.URL];
//    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //初始化
    self.startTime = 0;
    self.endTime = 0;
    self.startPointX = 50.0;
    self.endPointX = MIN(KMainScreenWidth, KMainScreenHeight) - 50.0;
    self.img_width = (MIN(KMainScreenWidth, KMainScreenHeight) - 100)/10.0;

    
    CGFloat scrollH = [self getScrollViewHeight] - 60;
    dataSourceArr = [[NSMutableArray alloc] init];
    
    bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 30, MIN(KMainScreenWidth, KMainScreenHeight), scrollH - 60)];
    [self.view addSubview:bottomView];
    
    
    UICollectionViewFlowLayout *flowout = [[UICollectionViewFlowLayout alloc] init];
    flowout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowout.itemSize = CGSizeMake(self.img_width, scrollH - 60);
    flowout.minimumLineSpacing = 0;

    self.mainCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowout];
    self.mainCollection.frame = CGRectMake(0, 0, MIN(KMainScreenWidth, KMainScreenHeight), scrollH - 60);
    self.mainCollection.delegate = self;
    self.mainCollection.dataSource = self;
    self.mainCollection.bounces = NO;
    [bottomView addSubview:self.mainCollection];

    //register cell
    [self.mainCollection registerNib:[UINib nibWithNibName:@"ACEditorCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"Cell"];
    
    //添加左右编辑拖动
    leftDragView = [[DragView alloc] initWithFrame:CGRectMake(-(MIN(KMainScreenWidth, KMainScreenHeight)-50), 0, MIN(KMainScreenWidth, KMainScreenHeight), scrollH-60) Left:YES];
    leftDragView.hitTestEdgInsets = UIEdgeInsetsMake(0, -(EDGE_EXTENSION_FOR_THUMB), 0, -(EDGE_EXTENSION_FOR_THUMB));
    leftDragView.timeLabel.text = @"00:00:00";
    [bottomView addSubview:leftDragView];
    
    rightDragView = [[DragView alloc] initWithFrame:CGRectMake(MIN(KMainScreenWidth, KMainScreenHeight) - 50, 0, MIN(KMainScreenWidth, KMainScreenHeight), scrollH - 60) Left:NO];
    rightDragView.hitTestEdgInsets = UIEdgeInsetsMake(0, -(EDGE_EXTENSION_FOR_THUMB), 0, -(EDGE_EXTENSION_FOR_THUMB));
    rightDragView.timeLabel.text = @"00:00:10";
    [bottomView addSubview:rightDragView];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveOverlayView:)];
    [bottomView addGestureRecognizer:pan];
    
//    line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 3, scrollH - 60)];
//    line.backgroundColor = [UIColor blueColor];
//    [bottomView addSubview:line];
//    line.hidden = YES;

}

#pragma mark 拖动手势
- (void)moveOverlayView:(UIPanGestureRecognizer *)gesture {
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            if (_beginBlock) {
                _beginBlock(self.startPointX);
            }
            [self stopTimer];
//            [self.player pause];
            BOOL isRight = [rightDragView pointInsideImgView:[gesture locationInView:rightDragView]];
            BOOL isLeft = [leftDragView pointInsideImgView:[gesture locationInView:leftDragView]];
            _isDraggingLeftOverlayView = NO;
            _isDraggingRightOverlayView = NO;
            
            self.touchPointX = [gesture locationInView:bottomView].x;
            if (isRight) {
                self.rightStartPoint = CGPointMake(rightDragView.frame.origin.x, 0);
                _isDraggingRightOverlayView = YES;
                _isDraggingLeftOverlayView = NO;
            }else if (isLeft){
                self.leftStartPoint = CGPointMake(leftDragView.frame.origin.x + MIN(KMainScreenWidth, KMainScreenHeight), 0);
                _isDraggingLeftOverlayView = YES;
                _isDraggingRightOverlayView = NO;
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint point = [gesture locationInView:bottomView];
            
            //left
            if (_isDraggingLeftOverlayView) {
                
                CGFloat deltX = point.x - self.leftStartPoint.x;
                CGPoint center = leftDragView.center;
                center.x += deltX;
                
                CGRect frame = leftDragView.frame;
                frame.origin.x += deltX;
                
                CGFloat durationTime = self.img_width * 2;//最小间距2s
                BOOL flag = ((self.endPointX - frame.origin.x - MIN(KMainScreenWidth, KMainScreenHeight)) - durationTime) > 0;
                
                NSLog(@"------------- %f view frame x = %f",self.endPointX -point.x,frame.origin.x);
                
                if (center.x >= (50 - MIN(KMainScreenWidth, KMainScreenHeight)/2.0) && flag) {
                    leftDragView.center = center;
                    self.leftStartPoint = CGPointMake(leftDragView.frame.origin.x + MIN(KMainScreenWidth, KMainScreenHeight), 0);
                    self.startTime = (leftDragView.center.x - (50 - MIN(KMainScreenWidth, KMainScreenHeight)/2)+self.mainCollection.contentOffset.x)/self.img_width;
                    self.startPointX = leftDragView.frame.origin.x + MIN(KMainScreenWidth, KMainScreenHeight);
                    NSLog(@"=========1 === point x = %f",point.x);
                    
                    int offset = (leftDragView.center.x - (50 - MIN(KMainScreenWidth, KMainScreenHeight)/2) + self.mainCollection.contentOffset.x)/self.img_width;
                    leftDragView.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)offset/3600,(int)(offset/60)%60,(int)offset%60];
                    if (_startBlock) {
                        _startBlock(offset);
                    }
                    
                }else{
                    NSLog(@"=========2");
                }

            }else if (_isDraggingRightOverlayView) {
                //right
                CGFloat deltaX = point.x - self.rightStartPoint.x;
                CGPoint center = rightDragView.center;
                center.x += deltaX;
                
                CGRect frame = rightDragView.frame;
                frame.origin.x += deltaX;
                
                CGFloat durationTime = self.img_width * 2;//最小范围2s
                BOOL flag = ((frame.origin.x - self.startPointX) - durationTime )> 0;
                
                if (center.x <= (MIN(KMainScreenWidth, KMainScreenHeight) * 1.5 - 50) && flag) {
                    rightDragView.center = center;
                    self.rightStartPoint = CGPointMake(rightDragView.frame.origin.x, 0);
                    self.endTime = (rightDragView.frame.origin.x - (leftDragView.frame.origin.x + MIN(KMainScreenWidth, KMainScreenHeight)) +self.mainCollection.contentOffset.x)/self.img_width;
                    self.endPointX = rightDragView.frame.origin.x;
                    
                    int offset = (rightDragView.frame.origin.x - (leftDragView.frame.origin.x + MIN(KMainScreenWidth, KMainScreenHeight)) +self.mainCollection.contentOffset.x)/self.img_width;
                    rightDragView.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)offset/3600,(int)(offset/60)%60,(int)offset%60];
                    
                    if (_endBlock) {
                        _endBlock(offset);
                    }
                }

            }else{
                //移动scrollview
                CGFloat deltax = point.x - self.touchPointX;
                CGFloat newOffset = self.mainCollection.contentOffset.x - deltax;
                CGPoint currentOffset = CGPointMake(newOffset, 0);
                
                if (currentOffset.x >= 0 && currentOffset.x <= (self.mainCollection.contentSize.width - MIN(KMainScreenWidth, KMainScreenHeight))) {
                    self.mainCollection.contentOffset = CGPointMake(newOffset, 0);
                    self.touchPointX = point.x;
                }

            }
        }
            break;
        case UIGestureRecognizerStateEnded:
            if (_didEndBlock) {
                _didEndBlock(self.startPointX);
            }
            [self startTimer];
            break;
        default:
            break;
    }
}

#pragma mark  - 开启计时器
- (void)startTimer{
    double duarationTime = (self.endPointX-self.startPointX)/self.img_width;
//    line.hidden = NO;
//    self.linePositionX = self.startPointX+1;
//    lineTimer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(lineMove) userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:lineTimer forMode:NSRunLoopCommonModes];
    // 开启循环播放
    repeatTimer = [NSTimer scheduledTimerWithTimeInterval:duarationTime target:self selector:@selector(repeatPlay) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:repeatTimer forMode:NSRunLoopCommonModes];
//    NSLog(@"==================> 视频回放时间 = %f end - start = %f",duarationTime,self.endTime - self.startTime);
}

- (void)stopTimer {
    
    if (lineTimer) {
        [lineTimer invalidate];
        lineTimer = nil;
    }
    
    if (repeatTimer) {
        [repeatTimer invalidate];
        repeatTimer = nil;
    }
    
    line.hidden = YES;
}



#pragma mark  - 编辑区域循环播放
- (void)repeatPlay{

    if (_playBlock) {
        _playBlock(self.startTime);
    }
}

#pragma mark  - 播放条移动
- (void)lineMove{
    
//    double duarationTime = (self.endPointX-self.startPointX-20)/MIN(KMainScreenWidth, KMainScreenHeight)*10;
//    self.linePositionX += 0.01*(self.endPointX - self.startPointX-20)/duarationTime;
//
//    if (self.linePositionX >= CGRectGetMinX(rightDragView.frame)-3) {
//        self.linePositionX = CGRectGetMaxX(leftDragView.frame)+3;
//    }
//
//    line.frame = CGRectMake(self.linePositionX, 0, 3, CGRectGetHeight(bottomView.frame));
}

- (void)reloadScrollViewWith:(AVURLAsset *)asset {
    
    if (dataSourceArr.count > 0) {
        return;
    }
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    imageGenerator.appliesPreferredTrackTransform = YES;
    //防止时间出现偏差
    imageGenerator.requestedTimeToleranceBefore = kCMTimeZero;
    imageGenerator.requestedTimeToleranceAfter = kCMTimeZero;
    
    long sumTime = asset.duration.value/asset.duration.timescale;

    if (sumTime >= 10 ) {
        rightDragView.timeLabel.text = @"00:00:10";
        self.endTime = 10;
    }else{
        rightDragView.timeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",sumTime/3600,(sumTime/60)%60,sumTime%60];
        self.endTime = sumTime;
    }
    
    
    NSMutableArray *timeArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < sumTime; i++) {
        CMTime time = CMTimeMake(i * asset.duration.timescale, asset.duration.timescale);
        NSValue *value = [NSValue valueWithCMTime:time];
        [timeArr addObject:value];
    }
    
    [imageGenerator generateCGImagesAsynchronouslyForTimes:timeArr completionHandler:^(CMTime requestedTime, CGImageRef  _Nullable image, CMTime actualTime, AVAssetImageGeneratorResult result, NSError * _Nullable error) {
    
        if (result == AVAssetImageGeneratorSucceeded) {

            if ([NSThread isMainThread]) {
                [self->dataSourceArr addObject:[UIImage imageWithCGImage:image]];
                [self.mainCollection reloadData];
            }else{
                dispatch_sync(dispatch_get_main_queue(), ^{
                   
                    [self->dataSourceArr addObject:[UIImage imageWithCGImage:image]];
                    [self.mainCollection reloadData];
                    
                });
            }
            
        }else if (result == AVAssetImageGeneratorCancelled){
            NSLog(@"AVAssetImageGeneratorCancelled");
        }else if (result == AVAssetImageGeneratorFailed){
            NSLog(@"AVAssetImageGeneratorFailed = %@",[error localizedDescription]);
        }
    }];
    
}


#pragma mark -UICollectionDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataSourceArr.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ACEditorCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if (indexPath.row < dataSourceArr.count) {
        cell.edtorImageView.image = (UIImage *)dataSourceArr[indexPath.row];
    }
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 50, 0, 50);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetx = scrollView.contentOffset.x;
    
    if (leftDragView) {
        int totalOffset = (self.startPointX + offsetx - 50)/self.img_width;
        leftDragView.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)totalOffset/3600,(int)(totalOffset/60)%60,(int)totalOffset%60];
        self.startTime = totalOffset;
        if (_startBlock) {
            _startBlock(totalOffset);
        }
        NSLog(@"=======> totalOffset = %d start = %f offset = %f",totalOffset,self.startPointX,offsetx);
    }
    if (rightDragView) {
        int totalOffset = (self.endPointX + offsetx - 50)/self.img_width;
        rightDragView.timeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",(int)totalOffset/3600,(int)(totalOffset/60)%60,(int)totalOffset%60];
        if (_endBlock) {
            _endBlock(totalOffset);
        }
        NSLog(@"=======> totalOffset = %d start = %f offset = %f",totalOffset,self.startPointX,offsetx);
    }
    
}


#pragma mark 获取自适应View的高度
- (CGFloat)getScrollViewHeight {
    
    CGFloat offsetH = 0;
    if ([Utils isiphoneX]) {
        offsetH = MAX(KMainScreenWidth, KMainScreenHeight) - 84 - 34 - 100 - 100 - MIN(KMainScreenWidth, KMainScreenHeight) * 9/16.0;
    }else{
        offsetH = MAX(KMainScreenWidth, KMainScreenHeight) - 64 - 100 - 100 - MIN(KMainScreenWidth, KMainScreenHeight) * 9/16.0;
    }
    
    return offsetH;
}


//#pragma mark -block
//- (void)setPlayerTimeWithBlock:(scrollPlayerBlock)block {
//    _block = block;
//}

#pragma mark - block

- (void)editorVideoStartWirhBlock:(editorStartBlock)startBlock {
    _startBlock = startBlock;
}

- (void)editorVideoEndWithBlock:(editorEndBlock)endBlock {
    _endBlock = endBlock;
}

- (void)editorVideoPlayWithBlock:(editorPlayBlock)playBlock {
    _playBlock = playBlock;
}

- (void)startDragViewWithBlock:(startBeginBlock)beginBlock {
    _beginBlock = beginBlock;
}

- (void)EndDragViewWithBlock:(didEndBlock)didEndBlock {
    _didEndBlock = didEndBlock;
}


@end
