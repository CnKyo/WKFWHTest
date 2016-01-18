//
//  FWHOrderDetailViewController.m
//  kTest
//
//  Created by wangke on 15/12/31.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "FWHOrderDetailViewController.h"

#import "FWHOrderDetailTableViewCell.h"
#import "FWHOrderDetailContentCell.h"
#import "FWHOrderDetailBtnTableViewCell.h"

#import "FWHOrderDetailHeader.h"

@interface FWHOrderDetailViewController ()<UITableViewDataSource,UITableViewDelegate,WKSegmentControlDelagate>

@end

@implementation FWHOrderDetailViewController
{
    UITableView *mTableView;
    FWHOrderDetailHeader    *FWHtableHeader;
    
    WKSegmentControl        *FWHSegmentControl;
    
    int                 FWHIsSelected;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.Title = self.mPageName = @"订单详情";
    self.hiddenRightBtn = YES;
    self.hiddenTabBar = YES;
    
    [self initView];
}
- (void)initView{
    mTableView = [UITableView new];
    self.tableView = mTableView;
    self.tableView.frame = CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-49);
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;

    self.haveHeader = YES;
    [self.tableView headerBeginRefreshing];
    [self.view addSubview:self.tableView];


    UINib *nib = [UINib nibWithNibName:@"FWHOrderDetailTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"detailcell"];
    
    nib = [UINib nibWithNibName:@"FWHOrderDetailContentCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"contentcell"];
    
    nib = [UINib nibWithNibName:@"FWHOrderDetailBtnTableViewCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"btncell"];
    
    [self.view addSubview:self.tableView];
    [self initHeader];

}
- (void)headerBeganRefresh{
    [SVProgressHUD showWithStatus:@"正在加载中" maskType:SVProgressHUDMaskTypeClear];

    [_model getOrderDetail:^(mBaseModel *mData) {
        [self headerEndRefresh];
        [self removeEmptyView];
        [SVProgressHUD dismiss];
        if (mData.mSucsess) {
            [SVProgressHUD showSuccessWithStatus:mData.mMessege];
            [self.tableView reloadData];
        }else{
            [SVProgressHUD showErrorWithStatus:mData.mMessege];
            [self addEmptyView:nil];

        }
    }];
}
- (void)initHeader{
    FWHtableHeader = [FWHOrderDetailHeader initWithView];
    [FWHtableHeader.FWHHeaderImg sd_setImageWithURL:[NSURL URLWithString:_model.mServiceImgUrl] placeholderImage:[UIImage imageNamed:@"img_def"]];
    FWHtableHeader.FWHServiceName.text = _model.mServiceName;
    self.tableView.tableHeaderView = FWHtableHeader;
    
    NSArray *btnArr = @[@"确认订单",@"服务内容"];
    
    FWHSegmentControl = [WKSegmentControl initWithSegmentControlFrame:CGRectMake(0, 44, self.view.bounds.size.width, 44) andTitleWithBtn:btnArr andBackgroudColor:[UIColor whiteColor] andBtnSelectedColor:[UIColor colorWithRed:0.490 green:0.682 blue:0.231 alpha:1] andBtnTitleColor:[UIColor grayColor] andUndeLineColor:[UIColor colorWithRed:0.490 green:0.682 blue:0.231 alpha:1] andBtnTitleFont:[UIFont fontWithName:@".Helvetica Neue Interface" size:16.0f] andInterval:20 delegate:self];
    
}
#pragma mark -- 遵守代理 实现代理方法
- (void)WKDidSelectedIndex:(NSInteger)mIndex{
    lll(@"%ld",(long)mIndex);
    
    switch (mIndex) {
        case 0:
        {
            lll(@"左");
            FWHIsSelected = 0;
        }
            break;
        case 1:
        {
            lll(@"右");
            FWHIsSelected = 1;
        }
            break;
            
        default:
            break;
    }
    
    [self.tableView reloadData];

}

#pragma mark----更新header的数据
- (void)loadDataWithHeader{

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
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return FWHSegmentControl.bounds.size.height;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return FWHSegmentControl;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (FWHIsSelected == 0) {
        if (indexPath.row == 0) {
            FWHOrderDetailTableViewCell *cell = (FWHOrderDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"detailcell"];
            
            CGFloat aa = [Util labelText:_model.mAddress fontSize:14 labelWidth:cell.FWHAddress.mwidth];
            CGFloat rr = [Util labelText:_model.mReMark fontSize:14 labelWidth:cell.FWHNote.mwidth];

            CGFloat tth = 320+aa+rr-34;
            
            if (tth<=320) {
                tth = 320;
            }
            
            return tth;
        }else{
            return 70;
        }
    }else{
        if (indexPath.row == 0) {
            
            FWHOrderDetailContentCell *cell = (FWHOrderDetailContentCell *)[tableView dequeueReusableCellWithIdentifier:@"contentcell"];
            CGFloat th = [Util labelText:_model.mServiceBrief fontSize:15 labelWidth:cell.FWHSErviceContent.mwidth];
            
            CGFloat tth = 44+th-21;
            
            if (tth<=44) {
                tth = 44;
            }

            return tth;
        }else{
            return 70;
        }
    }


}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (FWHIsSelected == 0) {
        if (indexPath.row == 0) {
            FWHOrderDetailTableViewCell *cell = (FWHOrderDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"detailcell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.model = _model;
            return cell;
        }else{
            FWHOrderDetailBtnTableViewCell *cell = (FWHOrderDetailBtnTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"btncell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.FWHServiceBtn addTarget:self action:@selector(serviceAcion:) forControlEvents:UIControlEventTouchUpInside];

            switch ([_model getUIShowbt]) {
                case E_UIShow_StartSrv:
                {
                    [cell.FWHServiceBtn setTitle:@"开始服务" forState:UIControlStateNormal];

                }
                    break;
                case E_UIShow_CompleteSrv:
                {
                    [cell.FWHServiceBtn setTitle:@"服务完成" forState:UIControlStateNormal];

                }
                    break;
                default:
                    cell.FWHServiceBtn.hidden = YES;
                    break;
            }
            return cell;
        }
    }else{
        if (indexPath.row == 0) {
            FWHOrderDetailContentCell *cell = (FWHOrderDetailContentCell *)[tableView dequeueReusableCellWithIdentifier:@"contentcell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            cell.FWHSErviceContent.text = _model.mServiceBrief;
            return cell;
        }else{
            FWHOrderDetailBtnTableViewCell *cell = (FWHOrderDetailBtnTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"btncell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            switch ([_model getUIShowbt]) {
                case E_UIShow_StartSrv:
                {
                    [cell.FWHServiceBtn setTitle:@"开始服务" forState:UIControlStateNormal];
                    
                }
                    break;
                case E_UIShow_CompleteSrv:
                {
                    [cell.FWHServiceBtn setTitle:@"开始服务" forState:UIControlStateNormal];
                    
                }
                    break;
                default:
                    cell.FWHServiceBtn.hidden = YES;
                    break;
            }

            return cell;
        }
    }


    
}
#pragma mark----服务按钮
#warning 服务完成不可再点击服务按钮
- (void)serviceAcion:(UIButton *)sender{
    
    switch ([_model getUIShowbt]) {
        case E_UIShow_StartSrv:
        {
            [SVProgressHUD showWithStatus:@"正在操作中..." maskType:SVProgressHUDMaskTypeClear];

            [_model updateService:4 andBlock:^(mBaseModel *mData) {
                [SVProgressHUD dismiss];

                if (mData.mSucsess) {
                    [SVProgressHUD showErrorWithStatus:mData.mMessege];
                    [self.tableView reloadData];

                }else{
                    [SVProgressHUD showErrorWithStatus:mData.mMessege];

                }
            }];
        }
            break;
        case E_UIShow_CompleteSrv:
        {
            [SVProgressHUD showWithStatus:@"正在操作中..." maskType:SVProgressHUDMaskTypeClear];
            
            [_model updateService:5 andBlock:^(mBaseModel *mData) {
                [SVProgressHUD dismiss];
                
                if (mData.mSucsess) {
                    [SVProgressHUD showErrorWithStatus:mData.mMessege];
                    [self.tableView reloadData];
                    
                }else{
                    [SVProgressHUD showErrorWithStatus:mData.mMessege];
                    
                }
            }];
        }
            break;
        default:
            sender.hidden = YES;
            break;
    }
}

@end
