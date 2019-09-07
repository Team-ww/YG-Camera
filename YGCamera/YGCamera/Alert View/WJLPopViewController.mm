//
//  WJLPopViewController.m
//  弹出下拉菜单
//
//  Created by 王建龙 on 16/4/12.
//  Copyright © 2016年 王建龙. All rights reserved.
//

#import "WJLPopViewController.h"
#import "CameraFunctionCell.h"

@interface WJLPopViewController ()<UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate>

@property(nonatomic,strong) UITableView  *listTabView;
@property (nonatomic,assign)CGRect sourceRect;

@end

@implementation WJLPopViewController

- (instancetype)initWithPopView:(UIView*)soureceV orBaritem:(UIBarButtonItem*)item{

    if (self = [super init]) {

        self.modalPresentationStyle = UIModalPresentationPopover;

        if (soureceV) {
            
            self.popoverPresentationController.sourceView = soureceV;
            _sourceRect = soureceV.bounds;
            self.popoverPresentationController.sourceRect = soureceV.bounds;
            
        }else{
            self.popoverPresentationController.barButtonItem = item;
        }
        self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.popoverPresentationController.backgroundColor = [UIColor blackColor];
        self.popoverPresentationController.delegate =self;
    }
    return self;

}
- (void)viewDidLoad {
    [super viewDidLoad];

    self.popoverPresentationController.backgroundColor = [UIColor colorWithRed:224.0/255.0 green:224.0/255.0 blue:224.0/255.0 alpha:1];
//    self.popoverPresentationController.backgroundColor = [UIColor colorWithRed:10.0/255.0 green:10.0/255.0 blue:10.0/255.0 alpha:0.4];
    
    UITableView *tab = [UITableView new];
    tab.delegate = self;
    tab.dataSource = self;
    [self.view addSubview:tab];
    tab.backgroundColor = [UIColor clearColor];
   
//    if (_isPreview) {
//         tab.rowHeight = 40;
//    }else
        tab.rowHeight = 50;
    tab.separatorInset = UIEdgeInsetsZero;
    tab.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.listTabView = tab;
    self.listTabView.scrollEnabled = NO;
    self.listTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (_isPreview) {
        [self.listTabView registerNib:[UINib nibWithNibName:@"CameraFunctionCell" bundle:nil] forCellReuseIdentifier:@"CameraFunctionCell"];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.listTabView.frame = self.view.bounds;
    self.popoverPresentationController.sourceRect =_sourceRect;
    self.listTabView.layoutMargins = UIEdgeInsetsZero;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listsArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isPreview) {

        CameraFunctionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CameraFunctionCell" forIndexPath:indexPath];
        [cell.cameraFunctionImageview setImage:[UIImage imageNamed:self.imageArr[indexPath.row]]];
        cell.cameraFunctionLab.text = self.listsArr[indexPath.row];
        cell.cameraFunctionLab.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1];
        
//        if (_selectIndex == indexPath.row) {
//            cell.cameraFunctionLab.textColor = [UIColor colorWithRed:255/255.0 green:165/255.0 blue:0 alpha:1];
//        }else{
//            cell.cameraFunctionLab.textColor = [UIColor whiteColor];
//        }
        return cell;
        
    }else{
        
        static NSString *indenti = @"cellId";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indenti];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indenti];
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
        }
        cell.textLabel.text = self.listsArr[indexPath.row];
        return cell;
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (_isPreview) {
        if ( _selectIndex != indexPath.row) {
            if ([self.delegate respondsToSelector:@selector(popViewController:didSelectAtIndex:)]) {
                [self.delegate popViewController:self didSelectAtIndex:(int)indexPath.row];
            }
        }
    }else{
        if ([self.delegate respondsToSelector:@selector(popViewController:didSelectAtIndex:)]) {
            [self.delegate popViewController:self didSelectAtIndex:(int)indexPath.row];
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    if (!_isPreview) {
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}


- (CGSize)preferredContentSize{
    /**
     150 pop视图的宽度
     */
    
//    if (_isPreview) {
//        return CGSizeMake(130, self.listsArr.count*40);
//    }
    return CGSizeMake(150, self.listsArr.count*50);
    //[UIScreen mainScreen].bounds.size.width
}


- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller{
    
    return UIModalPresentationNone;
}




@end
