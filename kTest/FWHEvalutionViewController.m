//
//  FWHEvalutionViewController.m
//  kTest
//
//  Created by wangke on 15/12/23.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "FWHEvalutionViewController.h"
#import "FWHEvalutionTableViewCell.h"
#import "FWHEvalutionHeader.h"
#import "FWHTopBtns.h"
@interface FWHEvalutionViewController ()<UITableViewDataSource,UITableViewDelegate,FWHBtnDelegate>

@end

@implementation FWHEvalutionViewController
{
    
    FWHEvalutionHeader  *FWHTableHeader;
    
    UIView  *FWHLineView;
    
    UIButton    *FWHLastBtn;

    
    WKSegmentControl  *FWHSectionHeader;
    
    NSInteger mType;
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
    self.Title = self.mPageName = @"用户评价";
    self.hiddenRightBtn = YES;
    self.hiddenBackBtn = YES;
    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-49) delegate:self dataSource:self];
    self.haveHeader = YES;
    self.haveFooter = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UINib* nib = [UINib nibWithNibName:@"FWHEvalutionTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell"];
    [self initHeader];
}
- (void)initHeader{
    FWHTableHeader  = [FWHEvalutionHeader loadViewAndData];
    [FWHTableHeader.FWHHeaderImg sd_setImageWithURL:[NSURL URLWithString:[mUser backNowUser].mUserImg] placeholderImage:[UIImage imageNamed:@"img_def"]];
    FWHTableHeader.FWHName.text = [mUser backNowUser].mUserName;
    
    [self.tableView setTableHeaderView:FWHTableHeader];
    
    NSArray *btnArr = @[@"全部",@"好评",@"中评",@"差评"];

    FWHSectionHeader = [WKSegmentControl initWithSegmentControlFrame:CGRectMake(0, 44, self.view.bounds.size.width, 44) andTitleWithBtn:btnArr andBackgroudColor:[UIColor whiteColor] andBtnSelectedColor:[UIColor colorWithRed:0.490 green:0.682 blue:0.231 alpha:1] andBtnTitleColor:[UIColor grayColor] andUndeLineColor:[UIColor colorWithRed:0.490 green:0.682 blue:0.231 alpha:1] andBtnTitleFont:[UIFont fontWithName:@".Helvetica Neue Interface" size:16.0f] andInterval:15 delegate:self];

}
- (void)loadHeaderData{
    
    FWHTableHeader.All = [[NSString stringWithFormat:@"%lu",(unsigned long)self.tempArray.count] intValue];
    NSMutableArray  *one = [NSMutableArray new];
    NSMutableArray  *two = [NSMutableArray new];
    NSMutableArray  *three = [NSMutableArray new];
    for (int i = 0; i<self.tempArray.count; i++) {
        SSEvolution *SSE = self.tempArray[i];
        if (SSE.mResultId == 1) {
            [one addObject:@"good"];
        }else if (SSE.mResultId == 2){
            [two addObject:@"mid"];
        }else if (SSE.mResultId == 3){
            [three addObject:@"bad"];
        }
    }
    FWHTableHeader.Good = [[NSString stringWithFormat:@"%lu",(unsigned long)one.count] intValue];
    FWHTableHeader.Mid = [[NSString stringWithFormat:@"%lu",(unsigned long)two.count] intValue];
    FWHTableHeader.Bad = [[NSString stringWithFormat:@"%lu",(unsigned long)three.count] intValue];

    
    
}
#pragma mark -- 遵守代理 实现代理方法
- (void)WKDidSelectedIndex:(NSInteger)mIndex{
    lll(@"%ld",(long)mIndex);
    mType = mIndex;
    [self.tableView headerBeginRefreshing];
    
}
- (void)headerBeganRefresh{
    self.page = 1;
    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [[mUser backNowUser]getEvaluationList:[[NSString stringWithFormat:@"%ld",(long)mType] intValue] andPage:self.page block:^(mBaseModel *mData, NSArray *mArray) {
        [self.tempArray removeAllObjects];
        [self removeEmptyView];
        [self headerEndRefresh];
        if (mData.mSucsess) {
            [SVProgressHUD showSuccessWithStatus:mData.mMessege];
            [self.tempArray addObjectsFromArray:mArray];
            [self loadHeaderData];
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
    [[mUser backNowUser]getEvaluationList:[[NSString stringWithFormat:@"%ld",(long)mType] intValue] andPage:self.page block:^(mBaseModel *mData, NSArray *mArray) {
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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FWHSectionHeader.bounds.size.height;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return FWHSectionHeader;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SSEvolution *SSE = self.tempArray[indexPath.row];
//    if ( SSE.mImages.count ) {
//        return 225;
//    }else{
//        return 145;
//    }

    return 225;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FWHEvalutionTableViewCell *cell = (FWHEvalutionTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.model = self.tempArray[indexPath.row];
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
