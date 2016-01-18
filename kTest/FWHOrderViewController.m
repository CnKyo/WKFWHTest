//
//  FWHOrderViewController.m
//  kTest
//
//  Created by wangke on 15/12/23.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "FWHOrderViewController.h"
#import "FWHOrderTableViewCell.h"
#import "FWHOrderDetailViewController.h"
#import "FWHTongjiViewController.h"
@interface FWHOrderViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FWHOrderViewController
{
    UITableView *mTableView;
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([mUser isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
    [self.tableView headerBeginRefreshing];

}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ( !_FWHIsOrder ) {
        self.Title = self.mPageName = @"订单";
        self.navBar.leftBtn.hidden = YES;
        self.rightBtnTitle = @"历史订单";
        [self setRightBtnWidth:123];
    }else{
        self.Title = self.mPageName = @"历史订单";
        self.rightBtnTitle = @"统计";
        self.hiddenTabBar = YES;
    }


    mTableView = [UITableView new];
    self.tableView = mTableView;
    self.tableView.frame = CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-114);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (!_FWHIsOrder) {
        UINib *nib = [UINib nibWithNibName:@"FWHOrderTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    }else{
        UINib *nib = [UINib nibWithNibName:@"FWHHistoryCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"hcell"];
        CGRect  mFrame = self.tableView.frame;
        mFrame.size.height = DEVICE_Height-49;
        self.tableView.frame = mFrame;
    }

    
    self.haveHeader = YES;
    self.haveFooter = YES;

    [self.view addSubview:self.tableView];

    
}
#pragma mark ----顶部刷新数据
- (void)headerBeganRefresh{
    self.page=1;
    [SVProgressHUD showWithStatus:@"正在加载中" maskType:SVProgressHUDMaskTypeClear];
    [[mUser backNowUser]getOrderList:self.page andStatus:0 block:^(mBaseModel *mData, NSArray *mArray) {
        [self headerEndRefresh];
        [self.tempArray removeAllObjects];

        if (mData.mSucsess) {
            [SVProgressHUD showSuccessWithStatus:mData.mMessege];
            [self.tempArray addObjectsFromArray:mArray];
            [self.tableView reloadData];

        }else{
            [SVProgressHUD showErrorWithStatus:mData.mMessege];
            [self addEmptyView:nil];
        }
    }];

    
}
#pragma mark----地步刷新
-(void)footetBeganRefresh
{
    self.page++;
    [SVProgressHUD showWithStatus:@"正在加载中" maskType:SVProgressHUDMaskTypeClear];
    [[mUser backNowUser]getOrderList:self.page andStatus:0 block:^(mBaseModel *mData, NSArray *mArray) {
        [self headerEndRefresh];
        [self.tempArray removeAllObjects];

        if (mData.mSucsess) {
            [SVProgressHUD showSuccessWithStatus:mData.mMessege];
            [self.tempArray addObjectsFromArray:mArray];
            [self.tableView reloadData];

        }else{
            [SVProgressHUD showErrorWithStatus:mData.mMessege];
            [self addEmptyView:nil];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- tableviewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView              // Default is 1 if not implemented
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tempArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( !_FWHIsOrder ) {
        return 225;
    }else{
        return 180;
    }
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString    *cellstr = nil;
    if (!_FWHIsOrder) {
        cellstr = @"cell";
    }else{
        cellstr = @"hcell";
        
    }
    FWHOrderTableViewCell *cell = (FWHOrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellstr];
    cell.model = self.tempArray[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FWHOrderDetailViewController *FWHDetail = [FWHOrderDetailViewController new];
    FWHDetail.model = self.tempArray[indexPath.row];
    [self pushViewController:FWHDetail];
  
}
- (void)rightBtnTouched:(id)sender{
    
    if ( [mUser isNeedLogin] ) {
        [self gotoLoginVC];
        return;
    }
    
    if (!_FWHIsOrder) {
        FWHOrderViewController  *FWHHistory = [FWHOrderViewController new];
        FWHHistory.FWHIsOrder = YES;
        FWHHistory.mSelf = self;
        [self pushViewController:FWHHistory];
    }else{
        lll(@"统计");
        FWHTongjiViewController *FWHTongji = [FWHTongjiViewController new];
        FWHTongji.mMonth = 0;
        [self pushViewController:FWHTongji];
    }

}
@end
