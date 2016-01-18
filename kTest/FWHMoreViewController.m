//
//  FWHMoreViewController.m
//  kTest
//
//  Created by wangke on 15/12/23.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "FWHMoreViewController.h"
#import "FWHMoreHeaderView.h"
#import "FWHMoreTableViewCell.h"
#import "FWHMessageViewController.h"
@interface FWHMoreViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FWHMoreViewController
{
    UITableView *mTableView;
    
    
    FWHMoreHeaderView   *FWHHeader;
    
    FWHMoreHeaderView   *FWHFooter;
    
    NSArray  *mArr;

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if ([mUser isNeedLogin]) {
        [self gotoLoginVC];
        return;
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.Title = self.mPageName = @"更多";
    self.navBar.leftBtn.hidden = YES;
    self.hiddenRightBtn = YES;
    
    mTableView = [UITableView new];
    mTableView.frame = CGRectMake(0, 64, DEVICE_Width, DEVICE_Height-114);
    mTableView.backgroundColor = COLOR(225, 225, 225);
    mTableView.delegate = self;
    mTableView.dataSource = self;
    UINib* nib = [UINib nibWithNibName:@"FWHMoreTableViewCell" bundle:nil];
    [mTableView registerNib:nib forCellReuseIdentifier:@"cell"];
    [self.view addSubview:mTableView];
    
    
    mArr = @[@"消息",@"关于我们",@"意见反馈"];
    
    [self initWithTableHeaderAndFooter];
}
- (void)initWithTableHeaderAndFooter{
    FWHHeader = [FWHMoreHeaderView initWithHeaderView];
    [FWHHeader.FWHHeaderImg sd_setImageWithURL:[NSURL URLWithString:[mUser backNowUser].mUserImg] placeholderImage:[UIImage imageNamed:@"img_def"]];
    FWHHeader.FWHName.text = [mUser backNowUser].mUserName;
    FWHHeader.FWHPhone.text = [mUser backNowUser].mUserPhone;
    mTableView.tableHeaderView = FWHHeader;
    
    FWHFooter = [FWHMoreHeaderView initWithFooterView];
    [FWHFooter.FWHLoginOut addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
    mTableView.tableFooterView = FWHFooter;
}
- (void)logout:(UIButton *)sender{
    UIAlertController   *alert = [UIAlertController alertControllerWithTitle:@"确定退出登录？" message:@"退出后将重新登录！" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction   *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        lll(@"取消");
    }];
    UIAlertAction   *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        lll(@"好的");
        [mUser loginOut];
        [SVProgressHUD showSuccessWithStatus:@"退出成功"];
        [self gotoLoginVC];

    }];
    [alert addAction:cancelAction];
    [alert addAction:okAction];

    [self presentViewController:alert animated:YES completion:nil];
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
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FWHMoreTableViewCell *cell = (FWHMoreTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.FWHTitle.text = mArr[indexPath.row];
    cell.FWHMsgpoint.hidden = YES;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        FWHMessageViewController    *FWHM = [FWHMessageViewController new];
        [self pushViewController:FWHM];
    }
}

@end
