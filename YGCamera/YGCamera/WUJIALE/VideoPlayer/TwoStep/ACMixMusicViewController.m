//
//  ACMixMusicViewController.m
//  YGCamera
//
//  Created by 吴家乐 on 2019/7/29.
//  Copyright © 2019 Chenhua. All rights reserved.
//

#import "ACMixMusicViewController.h"
#import "constants.h"
#import "Utils.h"
#import "ACMixMusicTableViewCell.h"


@interface ACMixMusicViewController ()<UITableViewDelegate,UITableViewDataSource> {
    
    checkMusicBlock _block;
    NSArray *musicTitleArr;
}

@property(nonatomic,strong)UITableView *mainTableView;

@end

@implementation ACMixMusicViewController

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.indexNumber = -1;
    
    self.view.layer.cornerRadius = 5;
    self.view.clipsToBounds = YES;

    musicTitleArr = @[@"笑傲江湖",@"大话西游",@"梦幻西游",@"西游记",@"东游记"];
    
    CGFloat Height = [self getScrollViewHeight] - 60;
    CGFloat Width = MIN(KMainScreenWidth, KMainScreenHeight) - 40;
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(20, 0, Width, Height) style:UITableViewStylePlain];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    self.mainTableView.bounces = NO;
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MIN(KMainScreenWidth, KMainScreenHeight), 40)];
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MIN(KMainScreenWidth, KMainScreenHeight), 60)];
    headerView.backgroundColor = [UIColor colorWithRed:180/255.0 green:201/255.0 blue:91/255.0 alpha:1.0];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MIN(KMainScreenWidth, KMainScreenHeight), 60)];
    [headerView addSubview:label];
    label.font = [UIFont systemFontOfSize:12 weight:700];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"添加本地音乐";
    self.mainTableView.tableHeaderView = headerView;

    //cell register
    [self.mainTableView registerNib:[UINib nibWithNibName:@"ACMixMusicTableViewCell" bundle:nil] forCellReuseIdentifier:@"MixCell"];
    
}

#pragma mark --tableView delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return musicTitleArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ACMixMusicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MixCell" forIndexPath:indexPath];
    [cell setCellWithName:musicTitleArr[indexPath.row] indexPath:indexPath selcted:self.indexNumber];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexNumber = indexPath.row;
    [tableView reloadData];

    if (_block) {
        _block(indexPath.row);
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

#pragma mark -- block
- (void)setMusicWithBlock:(checkMusicBlock)block {
    _block = block;
}

@end
