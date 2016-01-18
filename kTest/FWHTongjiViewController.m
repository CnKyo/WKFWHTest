//
//  FWHTongjiViewController.m
//  kTest
//
//  Created by wangke on 16/1/13.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import "FWHTongjiViewController.h"
#import "FWHTongjiTableViewCell.h"
#import "FWHOrderDetailViewController.h"
@interface FWHTongjiViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FWHTongjiViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.hiddenTabBar = YES;
    if (_mMonth == 0) {
        self.mPageName = self.Title = @"收入统计";
        self.rightBtnTitle = @"按月份";
        [self setRightBtnWidth:123];

    }else if (_mMonth == -1){
    self.Title = self.mPageName = @"月份收入汇总";
    }else if (_mMonth > 0 || _mMonth < 13){
        self.Title = self.mPageName = [NSString stringWithFormat:@"%d年%d月",_mYear,_mMonth];
    }else{
        [SVProgressHUD showErrorWithStatus:@"日期错误！"];
    }
    [self initView];
}
- (void)initView{
    
    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-49) delegate:self dataSource:self];

    UINib *nib = nil;
    if (_mMonth == 0) {
        nib = [UINib nibWithNibName:@"FWHTongjiTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    }else if (_mMonth == -1){
        nib = [UINib nibWithNibName:@"FWHMonthCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"mcell"];
    }else if (_mMonth > 0 || _mMonth < 13){
        nib = [UINib nibWithNibName:@"FWHTongjiTableViewCell" bundle:nil];
        [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    }

    self.haveHeader = YES;
    self.haveFooter = YES;
    
    [self.tableView headerBeginRefreshing];
    
}
- (void)headerBeganRefresh{
    self.page = 1;
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];

    [[mUser backNowUser] getStatisic:_mYear andMonth:_mMonth andPage:self.page block:^(mBaseModel *mData, NSArray *mArray) {
        [self removeEmptyView];
        [self.tempArray removeAllObjects];
        [self headerEndRefresh];
        if (mData.mSucsess) {
            if (mArray.count == 0) {
                [self addEmptyView:nil];
                return;
            }
            [SVProgressHUD showSuccessWithStatus:mData.mMessege];
            [self.tempArray addObjectsFromArray:mArray];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:mData.mMessege];
            [self addEmptyView:nil];
        }
    }];
    
}
- (void)footetBeganRefresh{
    self.page++;
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [[mUser backNowUser] getStatisic:_mYear andMonth:_mMonth andPage:self.page block:^(mBaseModel *mData, NSArray *mArray) {
        [self removeEmptyView];
        [self.tempArray removeAllObjects];
        [self headerEndRefresh];
        if (mData.mSucsess) {
            if (mArray.count == 0) {
                [self addEmptyView:nil];
                return;
            }
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
    return 65;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString    *cellid = nil;


    if (_mMonth == -1) {
        cellid = @"mcell";

    }else {
        cellid = @"cell";

    }
    
    FWHTongjiTableViewCell *cell = (FWHTongjiTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellid];
    cell.model = self.tempArray[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    SStatistical *SStatist = self.tempArray[indexPath.row];
    
    if (_mMonth == -1) {
        
        FWHTongjiViewController *FWHTongji = [FWHTongjiViewController new];
        FWHTongji.mMonth = SStatist.mMonth;
        FWHTongji.mYear = SStatist.mYear;
        [self pushViewController: FWHTongji];
        
    }else if(_mMonth == 0){
        FWHOrderDetailViewController    *FWHOrder = [FWHOrderDetailViewController new];
        FWHOrder.model = SSOrder.new;
        FWHOrder.model.mId = SStatist.mOrderId;
        [self pushViewController:FWHOrder];
    }
    
}

- (void)rightBtnTouched:(id)sender{
    FWHTongjiViewController *FWHTongji = [FWHTongjiViewController new];
    FWHTongji.mMonth = -1;
    [self pushViewController: FWHTongji];
}
@end
