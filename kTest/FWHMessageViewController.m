//
//  FWHMessageViewController.m
//  kTest
//
//  Created by wangke on 16/1/14.
//  Copyright © 2016年 wangke. All rights reserved.
//

#import "FWHMessageViewController.h"
#import "FWHMessageTableViewCell.h"
#import "FWHOrderDetailViewController.h"
@interface FWHMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation FWHMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.Title = self.mPageName = @"我的消息";
    [self setRightBtnWidth:133];
    self.rightBtnTitle = @"全部设为已读";
    self.hiddenTabBar = YES;
    [self.navBar.rightBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-60) delegate:self dataSource:self];
    self.haveHeader = YES;
    self.haveFooter = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UINib* nib = [UINib nibWithNibName:@"FWHMessageTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    [self.tableView headerBeginRefreshing];

}
- (void)headerBeganRefresh{
    self.page = 1;
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [[mUser backNowUser]getMessageList:self.page block:^(mBaseModel *mData, NSArray *mArray) {
        [self.tempArray removeAllObjects];
        [self removeEmptyView];
        [self headerEndRefresh];
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
- (void)footetBeganRefresh{
    self.page++;
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [[mUser backNowUser]getMessageList:self.page block:^(mBaseModel *mData, NSArray *mArray) {
        
        [self.tempArray removeAllObjects];
        [self removeEmptyView];
        [self headerEndRefresh];
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
    return 52;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FWHMessageTableViewCell *cell = (FWHMessageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.tempArray[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    SSMessage   *ssm = self.tempArray[indexPath.row];
    
    if ( !ssm.mRead ) {
        [ssm MsgRead];
    };
    
    ssm.mRead = YES;
    
    [tableView beginUpdates];
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    [tableView endUpdates];
    [tableView reloadData];

    if (ssm.mType == 1)
    {///状态为1，打开新界面，展示消息详情
        
    }
    else if (ssm.mType == 3)
    {///3为订单消息,args为订单id???
        FWHOrderDetailViewController *FWHOrder = [FWHOrderDetailViewController new];
        FWHOrder.model = SSOrder.new;
        FWHOrder.model.mId = [ssm.mArgs intValue];
        [self pushViewController:FWHOrder];
        
    }else if(ssm.mType == 2)
    {///状态为2，打开html界面
        
        WebVC *webView = [[WebVC alloc]init];
        webView.mName = @"消息详情";
        webView.mUrl = ssm.mArgs;
        [self pushViewController:webView];
        
    }

}

- (void)rightBtnTouched:(id)sender{
    lll(@"全部设为已读");
    [SVProgressHUD showWithStatus:@"正在操作中..." maskType:SVProgressHUDMaskTypeClear];
    [SSMessage readAll:^(mBaseModel *mData) {
        if (mData.mSucsess) {
            [SVProgressHUD dismiss];
            
            for (SSMessage *ssm in self.tempArray) {
                ssm.mRead = YES;
            }
            
            [self.tableView reloadData];
            
        }
        else{
            [SVProgressHUD showErrorWithStatus:mData.mMessege];
        }

    }];

}
@end
