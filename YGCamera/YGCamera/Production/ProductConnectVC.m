//
//  ProductConnectVC.m
//  YGCamera
//
//  Created by iOS_App on 2019/4/6.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ProductConnectVC.h"
#import "iCarousel.h"
#import "ConnectButton.h"
#import "CHImageview.h"
#import "BluetoothConnectView.h"
#import "PreviewVC.h"
#import "ConnectBackView.h"
#import "BLEControlManager.h"
#import "BLEConnect_CollectionView.h"
#import "BleListCell.h"
#import "NoticeSelectBleDeviceCell.h"
#import "NODeviceFoundCell.h"
#import "BLEMode.h"
#import "WJLPopViewController.h"

@interface ProductConnectVC ()<WJLPopViewControllerDelegate,BLEControlManagerDelegate> {
    
    NSTimer *updateBLE_Timer;
    NSArray *tempBle_Device_Arr;
}

@property (nonatomic, assign) BOOL wrap;
@property (weak, nonatomic) IBOutlet iCarousel *icarousel;
@property (weak, nonatomic) IBOutlet UIPageControl *pagControl;
@property (weak, nonatomic) IBOutlet BluetoothConnectView *blueConnectView;
@property (weak, nonatomic) IBOutlet ConnectBackView *backView;

@end

@implementation ProductConnectVC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _wrap = YES;


    UIImage *image = [UIImage imageNamed:@"connectTitleImage"];
    UIImageView *titleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    titleView.image = image;
    self.navigationItem.titleView = titleView;
    //self.navigationItem.title = @"产品名称";
    
   // self.blueConnectView.hidden = YES;
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [BLEControlManager sharedInstance].delegate = self;
    [self.icarousel bringSubviewToFront:self.pagControl];
}

- (IBAction)connectClick:(ConnectButton *)sender {
 
    if (![[BLEControlManager sharedInstance] checkConnectStatus]) {

        [[BLEControlManager sharedInstance] initCentralManager];
    }
    
    if (![self.view.window.subviews containsObject:self.backView]) {
        if (![self.backView.subviews containsObject:self.blueConnectView]) {
            __weak ProductConnectVC *weakSelf =  self;
            [weakSelf.backView addSubview:weakSelf.blueConnectView];
            self.blueConnectView.frame = CGRectMake(0, 0, self.view.frame.size.width *0.3 +150, self.view.frame.size.height *0.15 +150);
            self.blueConnectView.center = self.view.center;
            [self.blueConnectView handleBlueConnectBlock:^{
                //PreviewVC
                [weakSelf performSegueWithIdentifier:@"showPreviewSegue" sender:weakSelf];
            }];
        }
        self.backView.frame = [UIScreen mainScreen].bounds;
        [self.view.window addSubview:self.backView];
    }else{
        self.backView.hidden = NO;
    }
}



- (IBAction)helpClick:(UIBarButtonItem *)sender {
    
    NSArray *itemArr = @[@"说明书",@"教程",@"常见问题"];
    WJLPopViewController *popVC = [[WJLPopViewController alloc] initWithPopView:nil  orBaritem:sender];
    popVC.isPreview = YES;
    popVC.imageArr = @[@"notePDF",@"learnVideo",@"normalQuestion"];
    popVC.listsArr = itemArr;
    popVC.delegate = self;
    
    [self presentViewController:popVC animated:NO completion:nil];
}

#pragma mark - WJLPopViewControllerDelegate

- (void)popViewController:(WJLPopViewController *)con didSelectAtIndex:(int)index{
    
}

#pragma makr -- Delegate/DataSource

//cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat kwidth = collectionView.bounds.size.width;
     return CGSizeMake(kwidth, 45);

}

////cell的间距

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 2, 0, 2);
}

//cell的纵向距离
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger totolNunm = [[[BLEControlManager sharedInstance] peripheralArr] count];
    if (totolNunm == 0) return 1;
    if ([BLEControlManager sharedInstance].peripheral) {
        return totolNunm ;
    }else{
        return totolNunm +1;
    }
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[BLEControlManager sharedInstance] peripheralArr].count == 0 ) {
        
        NODeviceFoundCell *cell = (NODeviceFoundCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"NODeviceFoundCell" forIndexPath:indexPath];
        return cell;
        
    }else{
        
        if ([[BLEControlManager sharedInstance] peripheral]) {
            BleListCell *cell = (BleListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"BleListCell" forIndexPath:indexPath];
            
            NSArray *mac_arr =  [[BLEControlManager sharedInstance] peripheralArr];
            BLEMode *ble =mac_arr[indexPath.row];
            cell.macNameLab.text = ble.macStr;
            cell.selectStatusImageView.hidden = !ble.isconnected;
            [cell setImageWithRSSID:5];
            return cell;
        }else{
          
            if (indexPath.row < [[BLEControlManager sharedInstance] peripheralArr].count ) {
                
                BleListCell *cell = (BleListCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"BleListCell" forIndexPath:indexPath];
                
                NSArray *mac_arr =  [[BLEControlManager sharedInstance] peripheralArr];
                BLEMode *ble =mac_arr[indexPath.row];
                cell.macNameLab.text = ble.macStr;
                cell.selectStatusImageView.hidden = !ble.isconnected;
                [cell setImageWithRSSID:5];
                return cell;
            }else{
                
                NoticeSelectBleDeviceCell *cell = (NoticeSelectBleDeviceCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"NoticeSelectBleDeviceCell" forIndexPath:indexPath];
                cell.hidden = ([[BLEControlManager sharedInstance] peripheral] != nil ?YES:NO);
                
                return cell;
            }
        }
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row < [[BLEControlManager sharedInstance] peripheralArr].count) {
        
        NSArray *peripheral_arr =  [[BLEControlManager sharedInstance] peripheralArr];
        BLEMode *mode = peripheral_arr[indexPath.row];
        if (mode.isconnected) {
            mode.isconnected = NO;
            [BLEControlManager sharedInstance].delegate = nil;
            [[BLEControlManager sharedInstance].centralManager cancelPeripheralConnection:[BLEControlManager sharedInstance].peripheral];
            [BLEControlManager sharedInstance].peripheralArr = nil;
            return;
        }
        CBPeripheral *peripheral =  mode.peripheral;
       [[BLEControlManager sharedInstance] connectDevice:peripheral];
    }
    
}


#pragma mark- BLEControlManagerDelegate

- (void)connectResult:(BOOL )isuccess{
    
    if (isuccess) {
        [self.blueConnectView.bleconnectView reloadData];
    }else{
        [self.blueConnectView.bleconnectView reloadData];
    }
}

- (void)updateDiscoverPeripheral{

    [self.blueConnectView.bleconnectView reloadData];
}


@end
