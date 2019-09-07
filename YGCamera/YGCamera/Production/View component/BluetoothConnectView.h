//
//  BluetoothConnectView.h
//  YGCamera
//
//  Created by chen hua on 2019/4/8.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLEConnect_CollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@interface BluetoothConnectView : UIView

@property (weak, nonatomic) IBOutlet BLEConnect_CollectionView *bleconnectView;




- (void)handleBlueConnectBlock:(void(^)())blueConnectBlock;




@end

NS_ASSUME_NONNULL_END
