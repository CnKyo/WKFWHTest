//
//  FWHDateViewController.m
//  kTest
//
//  Created by wangke on 15/12/23.
//  Copyright © 2015年 wangke. All rights reserved.
//

#import "FWHDateViewController.h"
#import "FWHDateNoneDateCell.h"

#import "FWHDateBottomView.h"
@interface FWHDateViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation FWHDateViewController
{
    ///顶部的日期滚动试图
    UIScrollView    *mTopScrollerView;
    ///每个按钮下面的线
    UIView          *mLineView;
    ///最后一个点击的按钮
    UIButton        *mLastBtn;
    ///最后一个日期
    NSDate          *mLastDate;
    ///顶部日期的数组
    NSMutableArray  *mHeaderTimeArr;
    
    int             mDate;
    
    FWHDateBottomView *FWHBottomView;
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
    
    mHeaderTimeArr = [NSMutableArray new];

    self.Title = self.mPageName = @"日程";


    [self setRightBtnWidth:80];
    
    if ( !_mIsEditing ) {

        self.hiddenBackBtn = YES;
        self.rightBtnTitle = @"编辑";
    }else{
        self.Title = @"编辑";
        self.hiddenTabBar = YES;
    }
    
    [self initTopView];
    
    CGFloat hh = DEVICE_Height-49-65;
    
    [self loadTableView:CGRectMake(0, 64, DEVICE_Width, hh) delegate:self dataSource:self];

    self.haveHeader = YES;
    UINib* nib = [UINib nibWithNibName:@"FWHDateNoneDateCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"cell1"];
    
    UINib* nib2 = [UINib nibWithNibName:@"FWHDateEditCell" bundle:nil];
    [self.tableView registerNib:nib2 forCellReuseIdentifier:@"cell2"];
    
    if ( _mIsEditing ) {
       
        FWHBottomView = [FWHDateBottomView initWithView];
        FWHBottomView.frame = CGRectMake(0, DEVICE_Height-65, DEVICE_Width, 65);
        
        [FWHBottomView.FWHSelectAllBtn addTarget:self action:@selector(allAction:) forControlEvents:UIControlEventTouchUpInside];
        [FWHBottomView.FWHStartBtn addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
        [FWHBottomView.FWHStopBtn addTarget:self action:@selector(stopAction:) forControlEvents:UIControlEventTouchUpInside];

        [self.view addSubview:FWHBottomView];
        
    }
    
}
#pragma mark----初始化顶部滚动试图
- (void)initTopView{
    
    mDate = 0;

    mTopScrollerView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 64, DEVICE_Width, 60)];
    mTopScrollerView.backgroundColor = [UIColor whiteColor];

    for (int i =0 ; i<6; i++) {
        [mHeaderTimeArr addObject:NumberWithInt(i*64)];
    }
    
    float x = 0;
    float   w = mTopScrollerView.frame.size.width/4;
    for (int i = 0;i<5;i++) {
        
        UIButton    *mBtn = [[UIButton alloc]initWithFrame:CGRectMake(x, 5, w, 50)];
        mBtn.titleLabel.numberOfLines = 2;
        mBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [mBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [mBtn addTarget:self action:@selector(topclicked:) forControlEvents:UIControlEventTouchUpInside];
        mBtn.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        
        mBtn.tag = i+1;
        
        [mTopScrollerView addSubview:mBtn];
        
        x +=w;
        ///按钮间的分割线
        UIView*mBtnLine = [[UIView alloc]initWithFrame:CGRectMake(x-0.5f, 0, 0.5, 60)];
        mBtnLine.backgroundColor = COLOR(120, 167, 58);
        [mTopScrollerView addSubview:mBtnLine];
        
        mLastBtn = nil;
        
    }
    
    mTopScrollerView.contentSize = CGSizeMake(x, 60);
    
    
    mLineView = [[UIView alloc]initWithFrame:CGRectMake(0, 57,mTopScrollerView.frame.size.width/4, 2)];
    mLineView.backgroundColor = COLOR(120, 167, 58);
    ///顶部scroller下面的线
    UIView  *mScrollerLine =[[UIView alloc]initWithFrame:CGRectMake(0, 59, mTopScrollerView.frame.size.width, 0.5f)];
    mScrollerLine.backgroundColor = [UIColor colorWithRed:0.867 green:0.859 blue:0.859 alpha:1.000];
    [mTopScrollerView addSubview:mScrollerLine];
    [mTopScrollerView addSubview:mLineView];
    
}
#pragma mark----刷新顶部按钮的数据
- (void)reloadTopBtn{
    for (int i = 0; i<self.tempArray.count; i++) {
        
        SSDate  *ssd = self.tempArray[i];
        
        UIButton *btn = (UIButton *)[mTopScrollerView viewWithTag:i+1];
        [btn setTitle:[NSString stringWithFormat:@"%@\n%@",ssd.mStringDate,ssd.mWeek] forState:UIControlStateNormal];
    }
}
-(void)topclicked:(UIButton*)sender
{
    if( mLastBtn == sender) return;
    
    [mLastBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setTitleColor:mLineView.backgroundColor forState:UIControlStateNormal];
    mLastBtn = sender;
    mLineView.tag = sender.tag - 1;
    
    [UIView animateWithDuration:0.15 animations:^{
        
        CGRect f = mLineView.frame;
        f.origin.x = mLastBtn.frame.origin.x;
        mLineView.frame = f;
        
    }];
    
    
    [self.tableView headerBeginRefreshing];
}

- (void)headerBeganRefresh{

    [SVProgressHUD showWithStatus:@"加载中" maskType:SVProgressHUDMaskTypeClear];
    [[mUser backNowUser] getDateList:^(mBaseModel *mData, NSArray *mArray) {
        [self removeEmptyView];
        [self.tempArray removeAllObjects];
        [self headerEndRefresh];
        if (mData.mSucsess) {
            [SVProgressHUD showSuccessWithStatus:mData.mMessege];

            if ( mArray.count == 0 ) {
                [self addEmptyView:nil];
                return;
            }
            [self.tempArray addObjectsFromArray:mArray];
            [self reloadTopBtn];

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
    NSInteger  i = mLastBtn.tag - 1;
    if( i < self.tempArray.count )
    {
        SSDate *ssd = self.tempArray[i];
        return ssd.mList.count;
    }else{
        return 0;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return mTopScrollerView.bounds.size.height;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return mTopScrollerView;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString    *cellstr = nil;
    NSInteger   i = mLastBtn.tag - 1;
    SSDate  *ssd = self.tempArray[i];
    SScheduleItem   *item = ssd.mList[indexPath.row];
    if (item.mbStringInfo) {
        
        cellstr = @"cell1";


    }else{
        cellstr = @"cell2";

    }
    
    FWHDateNoneDateCell *cell = (FWHDateNoneDateCell *)[tableView dequeueReusableCellWithIdentifier:cellstr];
    cell.model = item;

    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)rightBtnTouched:(id)sender{
    if ( !_mIsEditing ) {
        FWHDateViewController   *FWHDate = [FWHDateViewController new];
        FWHDate.mIsEditing = YES;
        FWHDate.FWHPushSelf = self;
        [self pushViewController:FWHDate];
    }
}
#pragma mark----全选
- (void)allAction:(UIButton *)sender{
    lll(@"全选");
}
#pragma mark----开始接单
- (void)startAction:(UIButton *)sender{
    lll(@"开始接单");

}
#pragma mark----停止接单
- (void)stopAction:(UIButton *)sender{
    lll(@"停止接单");

}
@end
